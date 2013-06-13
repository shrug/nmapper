nmapper
=======

This is intended to be a quick and dirty solution to display the results of nmap scans. It currently has bare bones
functionality, based on an immediate short term need. I plan to extend and generalize it later. 

### Requires: Sinatra, Datamapper

+ Run an nmap scan using the XML output format - 'nmap -oX ...'
+ Import the results in a sqlite database with the included import.rb script: '# ruby import.rb my_scan.xml'
+ Drop the database file in db/nmap_devel.db
+ run 'ruby app.rb'

##TODO:
+ Come up with a better name
+ tests tests tests
+ Better error handling
+ better db handling - migrations, rake tasks,etc
+ add supportfor other RDBMS (mysql, postrgesql, etc?)
+ handle multiple runs - right now only works with a single scan against each host. Would like to store multiples for historical data - what has changed, etc
+ Sorting options
+ Limit queries by subnet/subdomain/port
+ Add functionality to import nmap xml files directly from the web ui?
+ Execute nmap scans from the app (possibly?)
+ better data visualizations, graphing options,etc

##License
+ Licensed under the WTFPL v2 - http://www.wtfpl.net/about/
+ jQuery licensed under the BSD license - https://github.com/jquery/jquery/blob/master/MIT-LICENSE.txt
+ DataTables is dual licensed under the GPL v2 license or a BSD (3-point) license - http://www.datatables.net/faqs
