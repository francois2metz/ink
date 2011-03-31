
all: compile

deps:
	./rebar get-deps

compile:
	./rebar compile

rel: deps compile
	./rebar generate

clean:
	./rebar clean
