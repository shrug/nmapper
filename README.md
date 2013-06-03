nmapper
=======

This is intended to be a quick and dirty solution to display the results of nmap scans. It currently has bare bones
functionality (as in, it will currently only display a lit of hosts with the number of open ports for each). This is using the database schema from http://www.redspin.com/blog/2009/10/27/nmap-database-output-xml-to-sql/

### Requires: Sinatra, Datamapper

+ Run an nmap scan using the XML output format - 'nmap -oX ...'
+ Import the results in a sqlite database with the included 'nmap_xml2sql.pl' script (From Paul Haas:
http://www.redspin.com/blog/2009/10/27/nmap-database-output-xml-to-sql/
+ Drop the database file in db/nmap.db
+ run 'ruby app.rb'

##TODO:
+ better db handling - migrations, rake tasks,etc
+ add supportfor other RDBMS (mysql, postrgesql, etc?)
+ handle multiple runs - right now only works with a single scan against each host. Would like to store multiples for
historical data - what has changed, etc
+ Sorting options
+ Drill down to host and port information
+ Limit queries by subnet/subdomain/port
+ Add functionality to import nmap xml files directly
+ Execute nmap scans from the app (possibly?)
+ better data visualizations, graphing options,etc

##License
+ Licensed under the WTFPL v2 - http://www.wtfpl.net/about/ with the exception of nmap_xml2sql.pl which is licensed under
GNU GPL v2 - http://www.gnu.org/licenses/gpl-2.0.html
