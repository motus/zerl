
ERL        := erl
ERLC       := erlc
ERLC_FLAGS := -Wall 

SRC   := $(wildcard src/*.erl)
BEAMS := $(SRC:src/%.erl=ebin/%.beam) 

.SUFFIXES: .erl .beam
.PHONY: all compile clean

ebin/%.beam : src/%.erl
	$(ERLC) $(ERLC_FLAGS) -o $(dir $@) $<

all: $(BEAMS)

clean:
	@rm -f ebin/*.beam

