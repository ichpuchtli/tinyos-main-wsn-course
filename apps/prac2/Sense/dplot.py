"""
This demo demonstrates how to draw a dynamic matplotlib 
plot in a wxPython application.

This code is based on Eli Bendersky's code found here:
http://eli.thegreenplace.net/files/prog_code/wx_mpl_dynamic_graph.py.txt

"""

import os
import random
import wx
import serial
import threading
import json
import time

import matplotlib
matplotlib.use('WXAgg')
from matplotlib.figure import Figure
from matplotlib.backends.backend_wxagg import FigureCanvasWxAgg
import numpy as np
import pylab
import math

class SerialJSONConn():

    
    conn = None
    dev = None
    baud = None

    def __init__(self,device='/dev/ttyUSB0', baudrate=115200):
        self.dev = device
        self.baud = baudrate

    def connect(self):
        self.conn = serial.Serial(self.dev,self.baud) # Zigduino
        self.conn.close()
        self.conn.open()

    def close(self):
        self.conn.close()
        self.conn = None

    def readTuple(self, key1, key2):
        tmp = {}
        line = self.conn.readline()
        
        try:
            tmp = json.loads(line)
        except:
            return 0

        print tmp
        print line

        return tmp[key1],tmp[key2]


    def read(self,key=None): 
        tmp = {}
        line = self.conn.readline()
        
        try:
            tmp = json.loads(line)
        except:
            return 0

        print tmp
        print line

        return tmp[key] 


    def isOpen(self):
        return (self.conn != None)


    

class DataSource(object):

    read_data = True
    serial = None
    

    def __init__(self, graph):
        self.graph = graph

        # start separate thread to generate dummy data
        t1 = threading.Thread(target=self.read_loop)
        t1.start()

        # Initiate Serial Connection
        self.serial = SerialJSONConn('/dev/ttyUSB0', 115200)
        self.serial.connect()


    def close(self):
      self.read_data = False

      if self.serial.isOpen():
          self.serial.close()

    # read loop for dummy data
    def read_loop(self):

        t = 0

        while self.read_data:

            temperature,light = 0,0

            time.sleep(0.1)

            temperature, light = self.serial.readTuple(u'temp',u'light')

            temperature += 12000

            t += 0.2
            
            # update plot
            if isinstance(self.graph, wx.Frame):
                self.graph.update_data(temperature,light) 
                wx.CallAfter(self.graph.draw_plot)



class GraphFrame(wx.Frame):
    """ The main frame of the application
    """
    title = 'Demo'
    
    def __init__(self):
        wx.Frame.__init__(self, None, -1, self.title)
        
    # handle window close event    
        self.Bind(wx.EVT_CLOSE, self.on_exit)

        # set data source
        self.source = DataSource(self)
        
        self.data_temp = []
        self.data_light = []
        
        self.create_main_panel()
        

    def create_main_panel(self):

        self.panel = wx.Panel(self)

        self.init_plot()
        self.canvas = FigureCanvasWxAgg(self.panel, -1, self.fig)

        self.vbox = wx.BoxSizer(wx.VERTICAL)
        self.vbox.Add(self.canvas, 1, flag=wx.LEFT | wx.TOP | wx.GROW)        
        
        self.panel.SetSizer(self.vbox)
        self.vbox.Fit(self)
   

    def init_plot(self):
        self.fig = Figure((6.0, 3.0), dpi=100)

        self.axes = self.fig.add_subplot(111)
        self.axes.set_axis_bgcolor('black')
        self.axes.set_title('AtmegaTemperatureC+12000/LightC Sensor Values', size=12)
        
        pylab.setp(self.axes.get_xticklabels(), fontsize=8)
        pylab.setp(self.axes.get_yticklabels(), fontsize=8)

        # plot the data as a line series, and save the reference 
        # to the plotted line series
        self.plot_data_temp = self.axes.plot(self.data_temp, linewidth=1, color=(1, 1, 0))[0]
        self.plot_data_light = self.axes.plot(self.data_light, linewidth=1, color=(0, 1, 0))[0]


    def update_data(self, temp, light):
    
       self.data_light.append(light)
       self.data_temp.append(temp)


    def draw_plot(self):
        """ Redraws the plot
        """

        xmax = len(self.data_light) if len(self.data_light) > 50 else 50
        xmin = xmax - 50

        ymin = -1000 
        ymax = 1000
       
        self.axes.set_xbound(lower=xmin, upper=xmax)
        self.axes.set_ybound(lower=ymin, upper=ymax)
        
        self.axes.grid(True, color='gray')
        pylab.setp(self.axes.get_xticklabels(), visible=True)
       
        self.plot_data_temp.set_xdata(np.arange(len(self.data_temp)))
        self.plot_data_temp.set_ydata(np.array(self.data_temp))
        
        self.plot_data_light.set_xdata(np.arange(len(self.data_light)))
        self.plot_data_light.set_ydata(np.array(self.data_light))

        self.canvas.draw()

    
    def on_exit(self, event):
        self.source.close()
        self.Destroy()
    
    

if __name__ == '__main__':
    app = wx.PySimpleApp()
    app.frame = GraphFrame()
    app.frame.Show()
    app.MainLoop()

