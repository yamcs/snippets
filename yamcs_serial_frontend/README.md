# Yamcs serial frontend

This is a Python script for routing Yamcs TC/TM over a serial line.  The script connects to Yamcs through the regular UDP interface, and uses the pySerialTransfer library to robustly transfer the TC/TM packets over a serial interface.

At the other end of the serial line, another pySerialTransfer Python client can be used, or a microcontroller using the [Arduino SerialTransfer](https://docs.arduino.cc/libraries/serialtransfer/) library.

## Installation

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install socket, threading, time, and pySerialTransfer.

```bash
pip install socket
pip install threading
pip install time
pip install pySerialTransfer
```

Copy the yamcs_serial_frontend.py script from this repository to the desired directory. 

Configure the script by setting:
- COM_PORT: name of the COM port.  It needs to be exclusively available to this script.
- BAUD_RATE: communications speed over the COM port.
- UDP_IP: IP address for interfacing to Yamcs.  127.0.0.1 is fine when Yamcs is running on the localhost.
- UDP_PORT_TM: Yamcs datalink UDP port for tm_realtime
- UDP_PORT_TC: Yamcs datalink UDP port for tc_realtime

## Usage

Start the TC/TM routing script:

```bash
$ python yamcs_serial_frontend.py
```
Stop the script with CTRL-C.