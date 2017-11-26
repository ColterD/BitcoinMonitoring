$carbonServer = "192.168.1.95"
$carbonServerPort = 2003
$workerAddress = "" #You can find this by clicking "View stats online" in nicehash miner

$workerJson = iwr -uri "https://api.nicehash.com/api?method=stats.provider.workers&addr=$($workerAddress)"

$workerdata = ConvertFrom-Json $workerJson

$socket = New-Object System.Net.Sockets.TCPClient
$socket.connect($carbonServer, $carbonServerPort)
$stream = $socket.GetStream()
$writer = new-object System.IO.StreamWriter($stream)

    foreach ($a in $workerdata.result)
     {
        foreach ($b in $a.workers)
        {
            $workerepochtime = [int][double]::Parse((get-date (get-date).ToUniversalTime() -uformat %s))
            $workername = $b[0]
            $gWorkerPath = "bitcoin.workers.$workername"
            $gWorkerVal = $b.a

            $gWorkerMetrics = "$gWorkerPath $gWorkerVal $workerepochtime"  
            
            $writer.WriteLine($gWorkerMetrics)
        }
     }

$writer.Flush() 
$writer.Close()
$stream.Close()