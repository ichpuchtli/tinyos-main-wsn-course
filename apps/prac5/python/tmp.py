#!/usr/bin/python

import socket
import ReportMsg
import re
import sys
import numpy as np



def YeqMXplusC(m, x, c):
  return m*x + c

if __name__ == '__main__':
    port = 7011

    # distance -> std
    y_std_std = np.array([1.5, 1.9, 3.2, 3.6, 4.7])
    x_std_distance = np.array([10, 20, 30, 40, 50])
    A_std = np.vstack([x_std_distance, np.ones(len(x_std_distance))]).T
    m_std, c_std = np.linalg.lstsq(A_std,y_std_std)[0]

    # rssi -> distance
    y_std_std = np.array([1.5, 1.9, 3.2, 3.6, 4.7])
    x_std_distance = np.array([10, 20, 30, 40, 50])
    A_std = np.vstack([x_std_distance, np.ones(len(x_std_distance))]).T
    m_std, c_std = np.linalg.lstsq(A_std,y_std_std)[0]


    s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)

    s.bind(('', port))

    print "Listening"

    while True:
        data, addr = s.recvfrom(1024)
        if (len(data) > 0):

            rpt = ReportMsg.ReportMsg(data=data, data_length=len(data))

            print rpt.get_id(), rpt.get_rssi()

            signal = rpt.get_rssi()[0]

            lindistance = YeqMXplusC(m, abs(signal), c)

            expdistance = YeqAEtotheBX(0.0381, 0.0865, abs(signal))

            print "Linear Approx Distance: ",  lindistance

            print "Exp Approx Distance: ",  expdistance
