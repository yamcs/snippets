create table if not exists invalid_tm(rectime timestamp, seqNum long, packet binary, primary key(rectime, seqNum))
insert into invalid_tm select * from invalid_tm_stream


-- create the good and bad frame streams and tables. The definition has to match the one from org.yamcs.tctm.ccsds.FrameStreamHelper

create stream good_frame_stream(rectime timestamp, seq int, ertime hres_timestamp, scid int, vcid int, data binary)
create table if not exists good_frames(rectime timestamp, seq int, ertime hres_timestamp, scid int, vcid int, data binary, primary key(rectime, seq))
insert into good_frames select * from good_frame_stream

create stream bad_frame_stream(rectime timestamp, seq int, ertime hres_timestamp, data binary)
create table if not exists bad_frames(rectime timestamp, seq int, ertime hres_timestamp, data binary, primary key(rectime, seq))
insert into bad_frames select * from bad_frame_stream


create stream cfdp_in as select substring(packet, 6) as pdu from tm_realtime where extract_short(packet, 0) = 6141
create stream cfdp_out (gentime TIMESTAMP, entityId long, seqNum int, pdu  binary)
insert into tc_cfdp select gentime, 'cfdp-service' as origin, seqNum, '/yamcs/cfdp/upload' as cmdName, unhex('17FDC0000000') + pdu as binary from cfdp_out
