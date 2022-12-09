retroerl
=====

A single OTP application, showing graphics via wxWidgets.

Aim is to output graphics context in wxwidget, after a pass through the erlang VM.
This would be used as a debugging environment when using libretro from the BEAM.

Build
-----

    $ rebar3 compile

Test
----

    $ rebar3 shell