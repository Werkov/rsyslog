#!/bin/bash
# test many concurrent tcp connections
# addd 2016-03-02 by RGerhards, released under ASL 2.0
# the key point of this test is that we do not abort and
# instead provide the defined return value (0)
# requires faketime
echo \[timegenerated-uxtimestamp-invld\]: check invalid dates with uxtimestamp format
export TZ=UTC+00:00
faketime -f '2216-03-01 12:00:00' date
if [ $? -ne 0 ]; then
    echo "faketime command missing, skipping test"
    exit 77
fi
. $srcdir/diag.sh init
. $srcdir/diag.sh generate-conf
. $srcdir/diag.sh add-conf '
$ModLoad ../plugins/imtcp/.libs/imtcp
$InputTCPServerRun 13514

template(name="outfmt" type="string"
	 string="%timegenerated:::date-unixtimestamp%\n")
:msg, contains, "msgnum:" action(type="omfile" template="outfmt"
			         file="rsyslog.out.log")
'


echo "***SUBTEST: check 1800-01-01"
rm -f rsyslog.out.log	# do cleanup of previous subtest
faketime -f '1800-01-01 00:00:00' $srcdir/diag.sh startup
. $srcdir/diag.sh tcpflood -m1
. $srcdir/diag.sh shutdown-when-empty
. $srcdir/diag.sh wait-shutdown
echo "0" | cmp rsyslog.out.log
if [ ! $? -eq 0 ]; then
  echo "invalid timestamps generated, rsyslog.out.log is:"
  cat rsyslog.out.log
  date -d @`cat rsyslog.out.log`
  exit 1
fi;


echo "***SUBTEST: check 1960-01-01"
rm -f rsyslog.out.log	# do cleanup of previous subtest
faketime -f '1960-01-01 00:00:00' $srcdir/diag.sh startup
. $srcdir/diag.sh tcpflood -m1
. $srcdir/diag.sh shutdown-when-empty
. $srcdir/diag.sh wait-shutdown
echo "0" | cmp rsyslog.out.log
if [ ! $? -eq 0 ]; then
  echo "invalid timestamps generated, rsyslog.out.log is:"
  cat rsyslog.out.log
  date -d @`cat rsyslog.out.log`
  exit 1
fi;


echo "***SUBTEST: check 2101-01-01"
rm -f rsyslog.out.log	# do cleanup of previous subtest
faketime -f '2101-01-01 00:00:00' $srcdir/diag.sh startup
. $srcdir/diag.sh tcpflood -m1
. $srcdir/diag.sh shutdown-when-empty
. $srcdir/diag.sh wait-shutdown
echo "0" | cmp rsyslog.out.log
if [ ! $? -eq 0 ]; then
  echo "invalid timestamps generated, rsyslog.out.log is:"
  cat rsyslog.out.log
  date -d @`cat rsyslog.out.log`
  exit 1
fi;


echo "***SUBTEST: check 2500-01-01"
rm -f rsyslog.out.log	# do cleanup of previous subtest
faketime -f '2500-01-01 00:00:00' $srcdir/diag.sh startup
. $srcdir/diag.sh tcpflood -m1
. $srcdir/diag.sh shutdown-when-empty
. $srcdir/diag.sh wait-shutdown
echo "0" | cmp rsyslog.out.log
if [ ! $? -eq 0 ]; then
  echo "invalid timestamps generated, rsyslog.out.log is:"
  cat rsyslog.out.log
  date -d @`cat rsyslog.out.log`
  exit 1
fi;


. $srcdir/diag.sh exit
