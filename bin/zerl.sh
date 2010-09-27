#!/bin/bash

if [ "$SPREEZIO_ROOT" == "" ]
then
  if which spreezio-root.sh > /dev/null
  then
    SPREEZIO_ROOT=`spreezio-root.sh`
  else
    echo "SPREEZIO_ROOT is not set" >&2
    exit 2
  fi
fi

export ZML_ZSS_LIBS=$SPREEZIO_ROOT/zml/lib

EBIN_PATH=`echo $SPREEZIO_ROOT/{zml,zerl,contrib/{misultin,epgsql{,_pool}}}/ebin`

rebar compile
mkdir -p $SPREEZIO_ROOT/logs

RUN="erl -pa $EBIN_PATH -boot start_sasl -config zerl -run zerl_tests start" # -noshell -run erlang halt"

echo $RUN
$RUN

