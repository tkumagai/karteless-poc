#!/bin/bash

mypath=$(dirname "${0}")
logname=$(date +"sqlplus_helloworld_sql_%Y%m%d_%H%M%S_$$.log")
logfile="/karte-efs/dealer01/${logname}"

df -h >> "${logfile}"
###sqlplus /nolog << EOF >> "${logfile}" 2>&1 && ret=0 || ret=$?
###WHENEVER SQLERROR EXIT FAILURE ROLLBACK
###WHENEVER OSERROR EXIT FAILURE ROLLBACK
###CONNECT admin/sIDGifqijB0RjBKlkhMf@atu-yokoyama-oracle.c3xdr8gr7zkv.ap-northeast-1.rds.amazonaws.com/ORCL
###@/karte-efs/dealer01/check-table.sql
###EXIT SUCCESS;
###select * from emp;
###EOF
cat ${logfile}
###dotnet /opt/app-root/app/app.dll &
nginx -g "daemon off;"
