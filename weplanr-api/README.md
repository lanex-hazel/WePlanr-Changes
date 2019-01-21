# WePlanr - API

Run the project:
rail s --port=<port number>
  
Use these commands if you want to kill a running port:
lsof -ti:<port> | xargs kill  -> one liner command for search and kill port,
			example: lsof -ti:3000 | xargs kill
lsof -ti:<port>  -> view only the running pid,
			example: lsof -ti:3000
lsof -i:<port>  -> view detailed info of running pid,
			example: lsof -i:3000
kill -9 <pid>  -> kill the running pid, 
			example: kill -9 2751
  
If error like this occurs, 
"A server is already running. Check /Users/lanex-hazel/Documents/projects/WePlanr/weplanr-api/tmp/pids/server.pid.
Exiting.", use this command:
rm -rf <weplanr-api project path>/tmp/pids/server.pid 
