#!/bin/bash

# FIXME:
SPREEZIO_DIR=/home/motus/devel/spreezio

WEBSITE3_PATH=$SPREEZIO_DIR/website3

export ZML_ZSS_LIBS=$SPREEZIO_DIR/zml/lib

EBIN_PATH="$SPREEZIO_DIR/misultin/ebin $SPREEZIO_DIR/zml/code/ebin $SPREEZIO_DIR/epgsql/ebin $SPREEZIO_DIR/epgsql_pool/ebin $SPREEZIO_DIR/zml-srv/ebin"

pushd $WEBSITE3_PATH > /dev/null

erl -pa $EBIN_PATH -noshell \
    -run zml_srv start . 8080 -run erlang halt

popd > /dev/null

