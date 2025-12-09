# Random Yamcs related things that don't fit anywhere else

## yamcs serial front-end

[Script for routing Yamcs TC/TM over a serial line.](https://github.com/yamcs/snippets/tree/main/yamcs_serial_frontend)

## json2ccsds

Hosted at https://codeberg.org/lars_uffmann/json2ccsds. [![Please don't upload to GitHub](https://nogithub.codeberg.page/badge.svg)](https://nogithub.codeberg.page)

Software package to generate CCSDS telemetry from CSV-like text files, using a JSON telemetry definition, from which a yamcs compatible TM definition is generated.

Applications include:

### json2ccsds
The actual TM streaming application, featuring:
* monitoring of inotify filesystem events for the CSV files (source data) to track, to detect appended lines, or moves & file creation
* conversion of a record in the source data into CCSDS (including checksum) as per the JSON definition provided
* validation of the source data against the JSON definition is performed
* streaming of resulting CCSDS TM to configurable UDP or TCP destinations
* separate destinations for "AOS" (online link) and "LOS" (offline link), allowing use of existing services for transmission of offline data
* regular link status detection via ```ping``` to AOS and LOS hosts
* configurable TM buffer (up to 60 seconds) for seamless switchover (no packet loss) when an LOS is detected

**NOTE**: when last checked (Win10), inotify file system events were not implemented correctly on WSL, and therefore this application only works properly on true Linux systems.

### json2mdb
An application that generates a telemetry definition in an XLSX spreadsheet (two, actually, separating the ccsds generic definition from the TM specific definition), compatible with the ```yamcs``` spreadsheet loader. **NOTE**: This requires opening the resulting XLSX in an office application and saving it as .XLS - at least until ```yamcs``` supports XLSX.
Features:
* lightweight JSON definition for easy description of CSV-like source data
* regular expressions (top level) to parse a record (allows parsing syslog-like files that can not be parsed like CSV)
* built-in ISO date type
* recursive field extraction (allows to separate e.g. 2025-01-28T12:00:00.123456 into separate date, time and microsecond fields if desired)
* lookup tables for encoding discrete values in numeric parameters (e.g. OFF -> 0, ON -> 1)
* validation of the provided JSON definition
* automatically derives required data type precision from given JSON parameter ranges
* generated TM definitions for different projects can be used (loaded by ```yamcs```) in parallel (due to separation of CCSDS header definitions)

### slowRead
A trivial application to read from existing CSV files and play back a line at a time to the console - can be used to simulate a TM stream for ```json2ccsds``` (by redirecting output to the monitored source data files).

### tcp-server-bridge
As the TCP link of ```json2ccsds``` acts as a TCP client, and ```yamcs``` TCP TM link does the same, this application acts as a bridge between the two, but is so generic in function, that it can provide the same service to any two TCP clients.
Features:
* provides two TCP servers, listening on configurable ports, accepting 1 connection each
* forwards data from connected clients to each other

When a stream of CCSDS telemetry is available from a TCP client only, this client and ```yamcs``` can both connect to the ```tcp-server-bridge``` and ```yamcs``` will be able to receive this data.

### ccsds-frames-cfdp
This is the same as the ccsds-frames example from yamcs but with the addition of the CFDP service. The CFDP shares the same virtual channel with the regular TCs but has lower priority.
