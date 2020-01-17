What
====

This application is used for deep packet inspection research project. It collects network packets and sorts packets by TCP connection and TCP sequence number.

It requires TCP packet sorting feature from [my forked PcapPlusPlus repository](https://github.com/rickyzhang82/PcapPlusPlus). The app can run on both FreeBSD and Linux. Resource leaking like memory leak and file handler leak have been checked intensively. In my research project, I ran PacketSorter in pfSense router over a month to collect packet data.

How
===

First, build dependency library PcapPlusPlus from my forked repository.

```
git clone -b my-master https://github.com/rickyzhang82/PcapPlusPlus
```

In FreeBSD

```
./configure-freebsd.sh
gmake all
sudo gmake install
```

In Linux

```
./configure-linux.sh
make all
sudo make install
```

Secondly, build PacketSorter application.

```
git clone https://github.com/rickyzhang82/PacketSorter
./clean-build.sh
```

Thirdly, run PacketSorter

```
./PacketSorter -h

Usage:
------
PacketSorter [-hvlcms] [-r input_file] [-i interface] [-o output_dir] [-e bpf_filter] [-f max_files]

Options:

    -r input_file : Input pcap/pcapng file to analyze. Required argument for reading from file
    -i interface  : Use the specified interface. Can be interface name (e.g eth0) or interface IPv4 address. Required argument for capturing from live interface
    -o output_dir : Specify output directory (default is '.')
    -e bpf_filter : Apply a BPF filter to capture file or live interface, meaning TCP sorter will only work on filtered packets
    -f max_files  : Maximum number of file descriptors to use (default: 500)
    -p max_packet : Maximum number of captured packets from both sides in each TCP connection (default: 0 = unlimited)
    -t time_out   : Maximum idle timeout in seconds for inactive TCP connection (default: 180. The value 0 = unlimited)
    -n max_scan   : Maximum number of inactive TCP connection scan in each batch (default: 100. The value 0 = scan all)
    -d clean_prd  : Time period in seconds to trigger clean up inactive TCP connection (default: 60)
    -g max_slt    : Maximum sgement lifetime. In TIME_WAIT state, TCP state machine wait for twice the MSS until transist to closed state. (default: 60)
    -x            : Exclude empty TCP packet (default: false)
    -s            : Write each side of each connection to a separate file (default is writing both sides of each connection to the same file)
    -l            : Print the list of interfaces and exit
    -v            : Displays the current version and exists
    -h            : Display this help message and exit
```

For example, in my research project I need to capture first 16th non-empty TCP payload packets from TCP connection. I use the following options:


```
/root/bin/PacketSorter -i re0 -o /root/tcpsorter -x -p 16 > /root/tcpsorter/run.log 2>&1
```
