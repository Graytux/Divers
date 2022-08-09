#!/bin/bash

################################################################################################
function Pause()
{
   read -p "$*"
}
function TestFich()
{
        CTST=0
        CTST=(`ls $1/Snap.* $1/heapdump.* $1/core.* $1/javacore.* | wc -l`)
        echo ${CTST}
}
function StopOHR()
{

}
function StartOHR()
{

}
function StopWEB()
{

}
function StartWEB()
{

}
################################################################################################

BASE=/home/hprodhra/Exploitation
TMP=${BASE}/tmp

RWEB1=/apps/prod/hra/web/bin
RWEB2=/apps/prod/hra/web2/bin
ROHR1=/apps/prod/hra/openhr/bin
ROHR2=/apps/prod/hra/openhr2/bin
ROHR3=/apps/prod/hra/openhr3/bin

TestFich ${RWEB1}
WEB1=${CTST}
TestFich ${RWEB2}
WEB2=${CTST}
TestFich ${ROHR1}
OHR1=${CTST}
TestFich ${ROHR2}
OHR2=${CTST}
TestFich ${ROHR3}
OHR3=${CTST}

Pause "Test PAUSE"
