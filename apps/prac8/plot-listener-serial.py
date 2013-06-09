#!/usr/bin/python

import serial
import threading
import time
import matplotlib.pyplot as plt

sample_buffer = bytearray(3)
draw_enabled = 1

mic_samples = []
plt.ion()		#Set figure for continuous drawing.
plt.show()

# read loop for serial port
def read_loop():
  print "Listening"
  output = ''
  mic_value = 0	
  while read_data:
    try:
      data = s.read();
      if len(data) > 0:
        output += data
        if (data[-1]=='\n'):
		xs = output.strip()
		if xs[0:1] in '+-' or xs.isdigit():
			mic_value = int(xs)	
		if (draw_enabled == 0):		
			print mic_value 	
		output = ''
	
		if (draw_enabled == 1):
			#Append mic value to samples array. Remove oldest sample.
			mic_samples.append(mic_value)
			if len(mic_samples) > 50:
				mic_samples.pop(0)
	
			#Clear and plot the figure.
			plt.clf()
			plt.ylim([0, 1023])
			plt.xlim([0, 50])
			plt.grid()
			plt.plot(mic_samples)
			plt.ylabel('Value')
			plt.xlabel('Sample Count')
			plt.draw()	
    except Exception, e:
      print "Exception:", e

  # close serial port
  print "close serial port"
  s.close()



# ============= main application starts here ==================

# init serial port
s = serial.Serial(port = '/dev/ttyUSB0', baudrate = 115200) # Zigduino
#s = serial.Serial(port = '/dev/ttyACM0', baudrate = 115200) # UCBase
s.open()


# start read_loop in a separate thread
read_data = True
t1 = threading.Thread(target=read_loop, args=())
t1.start()

# send loop for serial port
while True:
  try:
    for command in ['0' , '1', '2', 'a', 'i', 't']:
      s.write(command)
      time.sleep(1)
  except KeyboardInterrupt:
    print "Shutdown"
    break

read_data = False


