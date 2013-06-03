#!/usr/bin/perl
# Created by Paul Haas: phaas <AT> redspin <DOT> com
# Licensed under a NMAP Compatible License (GNU GPL v2)
# Dual licensed under the Fyodor may-use-as-he-pleases license
use Nmap::Parser;
use Socket; # For inet_aton
use DBI;
use strict;

use vars qw( $PROG );
( $PROG = $0 ) =~ s/^.*[\/\\]//;    # Truncate calling path from the prog name

main:
{       
    if ($#ARGV == -1){usage();exit(1);}
    my $xmlfile = $ARGV[0];
    my $dbfile = '';
    if (!defined($ARGV[1])) {$dbfile='nmap.db';} else {$dbfile=$ARGV[1];}

    my $dbh = createTables($dbfile);
    nmap_info($dbh,$xmlfile);
    
    $dbh->commit();
    
    # Output from our Database
    db_output($dbh);    
    
    $dbh->disconnect;
    
    exit(0);
}

sub usage {
    print "Usage: $PROG nmap.xml {optional db name}\n";
    print "\tConverts a NMAP Compatible XML File to a SQLite3 Database\n";
    exit;
}

sub createTables {
    my $dbfile = shift;
    print "# Writing Database to '$dbfile'.\n";
    
    # PrintError => 0 Prevents message by table recreation
    my $dbargs = {PrintError => 0,RaiseError => 0,AutoCommit => 0};
    my $dbh = DBI->connect("dbi:SQLite:$dbfile","","",$dbargs) or 
        die $DBI::errstr;
            
    my $id_type = "INTEGER PRIMARY KEY AUTOINCREMENT";
    # Information about the Scan
    eval {
        $dbh->do(
            "CREATE TABLE nmaps (
            sid $id_type,
            version TEXT,
            xmlversion TEXT,
            args TEXT,
            types TEXT,
            starttime INTEGER,
            startstr TEXT,
            endtime INTEGER,
            endstr TEXT,
            numservices INTEGER)"
        );
    };        
    
    # Information about Hosts
    eval {
        $dbh->do(
            "CREATE TABLE hosts ( 
            sid INTEGER,
            hid $id_type,
            ip4 TEXT, 
            ip4num INTEGER,           
            hostname TEXT,
            status TEXT,   
            tcpcount INTEGER,
            udpcount INTEGER,                 
            mac TEXT,
            vendor TEXT,
            ip6 TEXT,            
            distance INTEGER,
            uptime TEXT,
            upstr TEXT)"
        );
    };                    
     
    # Sequence Information (Used for OS Detection) 
    eval {
        $dbh->do(
            "CREATE TABLE sequencings ( 
            hid INTEGER,
            tcpclass TEXT,
            tcpindex TEXT,
            tcpvalues TEXT,
            ipclass TEXT,
            ipvalues TEXT,
            tcptclass TEXT,
            tcptvalues TEXT)"
        );
    };    
            
    # Port Information, including both TCP and UDP as indicated by 'type'   
    eval {
        $dbh->do(
            "CREATE TABLE ports (
            hid INTEGER,
            port INTEGER,
            type TEXT,
            state TEXT,
            name TEXT,
            tunnel TEXT,
            product TEXT,
            version TEXT,
            extra TEXT,
            confidence INTEGER,
            method TEXT,
            proto TEXT,  
            owner TEXT,          
            rpcnum TEXT,
            fingerprint TEXT)"
        );
    };
  
    # OS Information
    eval {
        $dbh->do(
            "CREATE TABLE os (
            hid INTEGER,
            name TEXT,
            family TEXT,
            generation TEXT,
            type TEXT,
            vendor TEXT,
            accuracy INTEGER)"
        );
    }; 
    
    return $dbh;        
}

sub nmap_info {
    my ($dbh,$xmlfile) = @_;
    print "# Reading from NMAP XML File '$xmlfile'.\n";
    
    my $np = new Nmap::Parser;
    $np->parsefile("$xmlfile"); # $name
        
    my $sth = $dbh->selectrow_hashref("SELECT max(sid) as msid FROM nmaps");     
    my $sid = $sth->{"msid"};
    if (!defined($sid)) {$sid = 0;}
    else {$sid++;}
            
    my $session = $np->get_session();   
    
    my $insert = $dbh->prepare('INSERT INTO nmaps VALUES (?,?,?,?,?,?,?,?,?,?)');
    my $success = $insert->execute(
        $sid,
        $session->nmap_version(),
        $session->xml_version(),
        $session->scan_args(),
        join(',',$session->scan_types()),
        $session->start_time(),
        $session->start_str(),
        $session->finish_time(),
        $session->time_str(),
        $session->numservices()         
    );

    my $sth = $dbh->selectrow_hashref("SELECT MAX(hid) as mhid from hosts");
    my $hid = $sth->{'mhid'};
    if (!defined($hid)) {$hid = 0;}
    else {$hid++;}
        
    for my $host ($np->all_hosts()) {
        my $os_sig = $host->os_sig();           
        
        my $insert = $dbh->prepare('INSERT INTO hosts VALUES 
            (?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
        my $success = $insert->execute(
            $sid,
            $hid,
            $host->ipv4_addr(), 
            unpack('N', inet_aton($host->ipv4_addr())), 
            #$host->hostname(),
            join(',',$host->all_hostnames()),
            $host->status(),                                            
            $host->tcp_port_count(),
            $host->udp_port_count(),
            $host->mac_addr(),  
            $host->mac_vendor(),
            $host->ipv6_addr(),
            $host->distance(),
            $host->uptime_seconds(),
            $host->uptime_lastboot()                    
        );
                
        my $insert = $dbh->prepare('INSERT INTO sequencings VALUES 
            (?,?,?,?,?,?,?,?)');
        my $success = $insert->execute( 
            $hid,
            $host->tcpsequence_class(),
            $host->tcpsequence_index(),
            $host->tcpsequence_values(),
            $host->ipidsequence_class(),
            $host->ipidsequence_values(),
            $host->tcptssequence_class(),
            $host->tcptssequence_values()       
        );

        for (my $index = 0; $index < $os_sig->class_count(); $index++){                 
            my $insert = $dbh->prepare('INSERT INTO os VALUES (?,?,?,?,?,?,?)'); 
            my $success = $insert->execute(     
                $hid,   
                $os_sig->name($index),
                $os_sig->osfamily($index),
                $os_sig->osgen($index),                         
                $os_sig->type($index),
                $os_sig->vendor($index),                        
                $os_sig->name_accuracy($index)                          
            );          
        }
    
        for my $tcp ($host->tcp_ports()){
            my $service = $host->tcp_service($tcp);
            
            my $insert = $dbh->prepare('INSERT INTO ports VALUES 
                (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');              
            my $success = $insert->execute(
                $hid,
                $service->port(),
                'tcp',
                $host->tcp_port_state($tcp),
                $service->name(),
                $service->tunnel(),
                $service->product(),
                $service->version(),
                $service->extrainfo(),
                $service->confidence(),                         
                $service->method(),
                $service->proto(),              
                $service->owner(),              
                $service->rpcnum(),
                $service->fingerprint()
            );                  
        }

        for my $udp ($host->udp_ports()){               
            my $service = $host->udp_service($udp);
            
            my $insert = $dbh->prepare('INSERT INTO ports VALUES 
                (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');    
            my $success = $insert->execute(
                $hid,
                $service->port(),
                'udp',
                $host->udp_port_state($udp),
                $service->name(),
                $service->product(),
                $service->version(),
                $service->extrainfo(),
                $service->confidence(),
                $service->owner(),
                $service->method(),
                $service->proto(),
                $service->tunnel(),
                $service->rpcnum(),
                $service->fingerprint()
            );                  
        }
        $hid++;
    }
}

sub db_output {
    my $dbfile = shift;
    my $sqlcmd = 'select case when hostname != "" then ip4 || " (" || hostname || ")" else ip4 end as iph, port || "/" || type as pt, case when tunnel != "" then name || " (" || tunnel || ")" else name end as nt, product || " " || version || " " || extra from hosts, ports using (hid) where state="open" order by ip4num, port';
    my $sth;
    
    $sth = $dbfile->prepare($sqlcmd) or die "Can not prepare SQL statement '$sqlcmd': ". $DBI::errstr;  
    $sth->execute or die "Can not execute SQL statement '$sqlcmd': " . $DBI::errstr;

    print "# Outputting Database with: '$sqlcmd'.\n";
    my $a;
    my @row;
    while (@row = $sth->fetchrow_array()) {
      print join("\t",@row) ."\n";
    }
}

