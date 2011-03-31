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
    add_server_header(dispatch(ewgi_api:request_method(Ctx), ewgi_api:path_info(Ctx), Ctx)).

dispatch('GET', "/", Ctx) ->
    simple_app(Ctx);
dispatch(_, "/", Ctx) ->
    error_405(Ctx);
dispatch(_, _, Ctx) ->
    error_404(Ctx).

error_404(Ctx) ->
    set_response({404, "Not Found"}, [{"Content-type", "text/plain"}], <<"Not Found">>, Ctx).

error_405(Ctx) ->
    set_response({405, "Method Not Allowed"}, [{"Content-type", "text/plain"}], <<"Method Not Allowed">>, Ctx).

simple_app(Ctx) ->
    set_response({200, "OK"}, [{"Content-type", "text/plain"}], <<"Hello World!">>, Ctx).

set_response(Status, Headers, Content, Ctx) ->
    Ctx1 = ewgi_api:response_status(Status, Ctx),
    Ctx2 = ewgi_api:response_headers(Headers, Ctx1),
    ewgi_api:response_message_body(Content, Ctx2).

add_server_header(Ctx) ->
    Headers = ewgi_api:response_headers(Ctx),
    ewgi_api:response_headers(Headers ++ [{"Server", "Ink"}], Ctx).
