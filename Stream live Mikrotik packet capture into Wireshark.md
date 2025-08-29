# Stream live Mikrotik packet capture into Wireshark

## Wireshark

Make note of your IP (e.g. 192.168.0.X)

1) Create capture filter

    Name:              Mikrotik sniffer
    Filter expression: udp port 37008

2) Start capture on relevant interface  with this filter applied


## Mikrotik

Make note of WAN interface (e.g. ether16) & host traffic you want to capture (e.g. 192.168.0.Y)

1) Configure sniffer

    /tool/sniffer set filter-interface=ether16 filter-ip-address=192.168.0.Y/32 streaming-enabled=yes streaming-server=192.168.0.X

2) Start streaming packets

    /tool/sniffer start

3) Stop session

    /tool/sniffer stop


