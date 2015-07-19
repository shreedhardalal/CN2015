#131052 - Shreedhar Dalal
#Computer Networks Lab submission 1

#Create a simulator object
set ns [new Simulator]

#Open the NAM trace file
set nf [open assign.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} \
{
        global ns nf
        $ns flush-trace
        #Close the NAM trace file
        close $nf
        #Execute NAM on the trace file
        exec nam assign.nam &
        exit 0
}

$ns color 1 Blue
$ns color 2 red
$ns color 3 green
#Create 11 nodes
set n0 [$ns node]
$n0 color "green"
$n0 shape box

set n1 [$ns node]
$n1 color "red"
$n1 shape square

set n2 [$ns node]
$n2 color "blue"
$n2 shape square
set n3 [$ns node]

set n4 [$ns node]
set n5 [$ns node]

set n6 [$ns node]
set n7 [$ns node]
$n7 color "blue"
$n7 shape box

set n8 [$ns node]
$n8 color "green"
$n8 shape square
set n9 [$ns node]

set n10 [$ns node]
$n10 color "red"
$n10 shape  box

# 0 <--> 1
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
# 1 <--> 2
$ns simplex-link $n1 $n2 2Mb 10ms DropTail
# 2 <--> 3
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
# 2 <--> 4
#$ns duplex-link $n2 $n4 2Mb 10ms DropTail
# 2 <--> 9
#$ns duplex-link $n2 $n9 2Mb 10ms DropTail
# 0 <--> 3
$ns duplex-link $n0 $n3 2Mb 10ms DropTail
# 4 <--> 5
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
# 4 <--> 6
$ns simplex-link $n4 $n6 2Mb 10ms DropTail
# 5 <--> 6
$ns duplex-link $n5 $n6 2Mb 10ms DropTail
# 6 <--> 7
$ns duplex-link $n6 $n7 2Mb 10ms DropTail
# 6 <--> 8
$ns duplex-link $n6 $n8 2Mb 10ms DropTail
# 9 <--> 10
$ns duplex-link $n9 $n10 2Mb 10ms DropTail

set lan [$ns newLan "$n2 $n4 $n9" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]
#orientation

# 0 <--> 1
$ns duplex-link-op $n0 $n1 orient down
# 0 <--> 3
$ns duplex-link-op $n0 $n3 orient right
# 1 <--> 2
$ns simplex-link-op $n1 $n2 orient right
# 2 <--> 3
$ns duplex-link-op $n2 $n3 orient up
# 2 <--> 4
#$ns duplex-link-op $n2 $n4 orient right-up
# 2 <--> 9
#$ns duplex-link-op $n2 $n9 orient down
# 9 <--> 10
$ns duplex-link-op $n9 $n10 orient right
# 4 <--> 5
$ns duplex-link-op $n4 $n5 orient right
# 4 <--> 6
$ns simplex-link-op $n4 $n6 orient right-down
# 5 <--> 6
$ns duplex-link-op $n5 $n6 orient down
# 6 <--> 7
$ns duplex-link-op $n6 $n7 orient right-down
# 6 <--> 8
$ns duplex-link-op $n6 $n8 orient left-down


#Setup a TCP connection
set tcp [new Agent/TCP]
$tcp set class_ 2
$ns attach-agent $n2 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n7 $sink
$ns connect $tcp $sink
$tcp set fid_ 1


#Setup a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP



#Setup a UDP connection
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null [new Agent/Null]
$ns attach-agent $n10 $null
$ns connect $udp1 $null
$udp1 set fid_ 2


#Setup a CBR over UDP connection
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 1mb
$cbr1 set random_ false

#Setup a UDP connection
set udp2 [new Agent/UDP]
$ns attach-agent $n8 $udp2
set null [new Agent/Null]
$ns attach-agent $n0 $null
$ns connect $udp2 $null
$udp2 set fid_ 3


#Setup a CBR over UDP connection
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1mb
$cbr2 set random_ false



$ns at 0.1 "$cbr1 start"
$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr2 start"
$ns at 3.5 "$cbr2 stop"
$ns at 4.0 "$ftp stop"
$ns at 4.5 "$cbr1 stop"



#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"


#Run the simulation
$ns run
