#!/bin/bash

# FIXME:
SPREEZIO_DIR=/home/motus/devel/spreezio

WEBSITE3_PATH=$SPREEZIO_DIR/website3

export ZML_ZSS_LIBS=$SPREEZIO_DIR/zml/lib

EBIN_PATH="$SPREEZIO_DIR/misultin/ebin $SPREEZIO_DIR/zml/code/ebin $SPREEZIO_DIR/epgsql/ebin $SPREEZIO_DIR/epgsql_pool/ebin $SPREEZIO_DIR/zml-srv/ebin"

erl -pa $EBIN_PATH -noshell \
    -run zml_srv start "$WEBSITE3_PATH" 8080 -run erlang halt

