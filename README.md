# Bitcoin Monitoring

What us it?
I wrote these scripts to monitor the progress of my bitcoin mining using NiceHash. 

What are the requirements? 
 - Something mining using Nicehash, and your miner address
 - Graphite/Carbon, with Graphite web set up (Great walkthrough here - https://www.digitalocean.com/community/tutorials/how-to-install-and-use-graphite-on-an-ubuntu-14-04-server)
 - Grafana - http://docs.grafana.org/installation/debian/
 - A windows machine to run powershell/schedule the script to run
 
 What does each script do?
 
 BTCBalance.ps1
 - Pulls balance from nicehash for each crypto, and adds it together for your total BTC Balance
 - Pulls current BTC index price
 - Calculates your balance in USD based on the above two metrics
 
 Outputs:
 bitcoin.totalbalance (Your BTC Balance)
 bitcoin.currentbtcprice (Current BTC Index price in USD)
 bitcoin.balanceprice (Your BTC Balance in USD)
 
 WorkerMetrics.ps1
 - Pulls current hash rate from Nicehash
 
 Outputs:
 bitcoin.workers.$workername (Will send metrics for as many workers as you have)
 
 Issues: 
 - Nicehash doesnt standardize format for hash rate, so 1 Gh/s comes through as 1, so another rig doing 700H/s will look like its faster on the graph
