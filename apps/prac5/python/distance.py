#!/usr/bin/python

import socket
import ReportMsg
import re
import sys
import numpy as np


if __name__ == '__main__':
    port = 7011

    # distance -> std
    y_std = np.array([1.5, 1.9, 3.2, 3.6, 4.7])
    x_std_distance = np.array([10, 20, 30, 40, 50])
    A_std = np.vstack([x_std_distance, np.ones(len(x_std_distance))]).T
    m_std, c_std = np.linalg.lstsq(A_std,y_std)[0]

    # rssi -> distance
    y_dist = np.array([3, 6, 12, 24, 48, 96])
    x_dist_rssi = np.array([54, 57, 66, 72, 81, 93])

    A_dist = np.vstack([x_dist_rssi, np.ones(len(x_dist_rssi))]).T
    m_dist, c_dist = np.linalg.lstsq(A_dist,y_dist)[0]

    def dist2std(x):
      return m_std*x + c_std

    def rssi2dist(x):
      return m_dist*x + c_dist

    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)

    s.bind(('', port))

    print "Listening"

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = ReportMsg.ReportMsg(data=data, data_length=len(data))

            print rpt.get_id(), rpt.get_rssi()

            signal = abs(rpt.get_rssi()[3])

            distance = rssi2dist(signal)

            std = dist2std(distance)

            print "Distance: ",  distance

            print "Std: ",  std

            print "Min/Max:" , (rssi2dist(signal-std), rssi2dist(signal+std))

            print

