# Stream live Mikrotik packet capture into Wireshark

## Wireshark

Make note of your IP (e.g. 192.168.0.X)

Create capture filter

    Name:              Mikrotik sniffer
    Filter expression: udp port 37008

Start capture on relevant interface  with this filter applied


## Mikrotik

Make note of WAN interface (e.g. ether16) & host traffic you want to capture (e.g. 192.168.0.Y)

Configure sniffer

    /tool/sniffer set streaming-enabled=yes filter-interface=ether16 \
     streaming-server=192.168.0.X filter-ip-address=192.168.0.Y/32

Start streaming packets

    /tool/sniffer start

Stop session

    /tool/sniffer stop


