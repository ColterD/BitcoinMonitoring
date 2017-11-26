#Set up carbon info
$carbonServer = "192.168.1.95"
$carbonServerPort = 2003
$workerAddress = "" #You can find this by clicking "View stats online" in nicehash miner
#vars for data
$json = iwr -uri "https://api.nicehash.com/api?method=stats.provider&addr=$($workerAddress)"
$jsonBitcoinPrice = iwr -uri "https://api.coindesk.com/v1/bpi/currentprice.json"

#Convert it, yo!
$data = ConvertFrom-Json $json
$dataBitcoinPrice = ConvertFrom-Json $jsonBitcoinPrice

#Base Var's
$totalbalance = 0
$balanceprice = 0
$bitcoinindexprice = 0

#Loop through the json to get current bitcoin index price.
foreach ($a in $dataBitcoinPrice.bpi)
     {
        foreach ($price in $a.USD)
        {
           $bitcoinindexprice = $price.rate_float
        }
     }

#Loop through the json from nicehash to get mined BTC balance
     foreach ($i in $data.result)
     {
        foreach ($t in $i.stats)
        {
           $totalbalance += $t.balance
        }
     }

#Assign carbon pathing
$gPath = "bitcoin.totalbalance"
$gIndexPricePath = "bitcoin.currentbtcprice"
$gBalancePricePath = "bitcoin.balanceprice"

#Assign carbon values
$gVal = $totalbalance
$gbalancepriceVal =  $bitcoinindexprice * $totalbalance

#Current epoch time
$epochtime = [int][double]::Parse((get-date (get-date).ToUniversalTime() -uformat %s))

#Make the carbot metric string in the proper format
$gmetrics += "$gPath $gVal $epochtime"
$gbitcoinindexmetrics += "$gIndexPricePath $bitcoinindexprice $epochtime"
$gbalancepricemetrics += "$gBalancePricePath $gbalancepriceVal $epochtime"

#Connect to the carbon server
$socket = New-Object System.Net.Sockets.TCPClient
$socket.connect($carbonServer, $carbonServerPort)
$stream = $socket.GetStream()
$writer = new-object System.IO.StreamWriter($stream)

#Write the metrics over raw tcp streams
$writer.WriteLine($gmetrics)
$writer.WriteLine($gbitcoinindexmetrics)
$writer.WriteLine($gbalancepricemetrics)

#Kill.Die
$writer.Flush() 
$writer.Close()
$stream.Close()