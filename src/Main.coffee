{Action, Actions, Array, Arrays, Environment, Function, FunctionByLengthMap, FunctionByTypesPairs, FunctionTemplate, Keys, Map, Maps, Number, Numbers, Object, Optional, Optionals, Pair, Pairs, RegExp, Set, SortedArray, String, Strings, Text} = require "Fuell"
Robusta = require "./Robusta"


settings = do ->
  args = Array.dropping 2, process.argv

  target:
    if args[0] && String.doesMatch /^[^-]/, args[0] then args[0]
    else "lib"
  source:
    if args[1] && String.doesMatch /^[^-]/, args[1] then args[1]
    else "src"
  help:
    Array.containsAnyOf ["--help", "-h"], args
  coffee:
    Array.containsAnyOf ["--coffee", "-c"], args


if settings.help
  console.log """
    Compiles CoffeeScript with support for packages and imports.

    Usage:
      robusta [targetDir] [sourceDir] [params...]
      * targetDir defaults to `lib`
      * sourceDir defaults to `src`

    Parameters:
      --coffee, -c - Compile to CoffeeScript, it's JavaScript otherwise
  """
else
  if settings.coffee
    Robusta.compileToCoffee settings.target, settings.source, ->
  else
    Robusta.compileToJS settings.target, settings.source, ->