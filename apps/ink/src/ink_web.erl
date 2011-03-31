-module(ink_web).

-export([start/0, stop/0,
         loop/1, simple_app/1]).

start() ->
    mochiweb_http:start([{name, ink},
                         {loop, fun ?MODULE:loop/1},
                         {ip, "127.0.0.1"}, {port, 8889}]).

stop() ->
    mochiweb_http:stop(ink).

loop(Req) ->
    ewgi_mochiweb:run(fun dispatcher/1, Req).

dispatcher(Ctx) ->
    add_server_header(dispatch(ewgi_api:path_info(Ctx), Ctx)).

dispatch("/", Ctx) ->
    simple_app(Ctx);
dispatch(_, {ewgi_context, Request, _Response}) ->
    ResponseHeaders = [{"Content-type", "text/plain"}],
    Response = {ewgi_response, {404, "Not Found"}, ResponseHeaders,
                [<<"Not found!">>], undefined},
    {ewgi_context, Request, Response}.

simple_app({ewgi_context, Request, _Response}) ->
    ResponseHeaders = [{"Content-type", "text/plain"}],
    Response = {ewgi_response, {200, "OK"}, ResponseHeaders,
                [<<"Hello world!">>], undefined},
    {ewgi_context, Request, Response}.

add_server_header(Ctx) ->
    Headers = ewgi_api:response_headers(Ctx),
    ewgi_api:response_headers(Headers ++ [{"Server", "Ink"}], Ctx).
