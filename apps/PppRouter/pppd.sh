#!/bin/sh
sudo pppd debug passive noauth nodetach 115200 /dev/ttyACM0 nocrtscts nocdtrcts lcp-echo-interval 0 noccp noip ipv6 ::23,::24
