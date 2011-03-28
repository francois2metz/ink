-module(ink_web).

-export([start/0, stop/0,
         loop/1, simple_app/1]).

start() ->
    mochiweb_http:start([{loop, fun ?MODULE:loop/1},
                         {ip, "127.0.0.1"}, {port, 8889}]).

stop() ->
    mochiweb_http:stop(ink).

loop(Req) ->
    ewgi_mochiweb:run(fun ?MODULE:simple_app/1, Req).

simple_app({ewgi_context, Request, _Response}) ->
    ResponseHeaders = [{"Content-type", "text/plain"}],
    Response = {ewgi_response, {200, "OK"}, ResponseHeaders,
                [<<"Hello world!">>], undefined},
    {ewgi_context, Request, Response}.
