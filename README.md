# Robusta

A CoffeeScript extension that introduces a packaging system and support for convenient import statements

This utility removes a decent portion of boilerplate from CoffeeScript modules management by addressing several problems of the classic `require`-`exports` approach:

1. Importing members locally:

    Standard CoffeeScript code:
        
        {print, puts, debug, error, inspect, p, log, exec, pump, inherits} = require "util"

    Robusta code:
        
        import * from util

2. Managing `exports`. The headache of managing exports is a well known issue. Robusta addresses it:

    Generated CoffeeScript code:

        a = ->
        b = 0
        c = 0

        exports.a = a
        exports.b = b
        exports.c = c
        
    Robusta code:

        export *

        a = ->
        b = 0
        c = 0

3. The absolute/relative paths confusion. In Robusta all import paths are absolute - no matter whether it's a `node_modules` dependency or a local module. Please see this [example](https://github.com/nikita-volkov/Robusta/tree/master/examples/local-imports).

You will find out a lot of other niceties about Robusta. Please check out the sample code [here](https://github.com/nikita-volkov/Robusta/tree/master/examples/).

Robusta transcompiles the code into either the standard CoffeeScript or directly into JavaScript. Following is its command line usage info:

    Usage:
      robusta [targetDir] [sourceDir] [params...]
      * targetDir defaults to `lib`
      * sourceDir defaults to `src`

    Parameters:
      --coffee, -c - Compile to CoffeeScript, it's JavaScript otherwise
