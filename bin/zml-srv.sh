#!/bin/sh

erl -pa ./ebin ../zml/code/ebin ../epgsql/ebin ../epgsql_pool/ebin \
    -noshell -run zml_srv start ../website3 8080 -run erlang halt

