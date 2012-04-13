{Action, Actions, Array, Arrays, Environment, Function, FunctionByLengthMap, FunctionByTypesPairs, FunctionTemplate, Keys, Map, Maps, Number, Numbers, Object, Optional, Optionals, Pair, Pairs, RegExp, Set, SortedArray, String, Strings, Text} = require "Fuell"



exports.render = 
render = ({exports, requireInstructions, code}) ->
  # console.log requireInstructions
  
  Strings.union [
    "# Robusta: generated require statements\n"
    Strings.union Array.results requireRender, requireInstructions
    "\n# Robusta: extracted code\n"
    code
    "\n\n# Robusta: generated export statements\n"
    Strings.union Array.results exportRender, exports
  ]

exportRender = (name) ->
  "exports.#{name} = #{name}\n"

requireRender = ({path, alias, members}) ->
  if members
    """{#{Strings.interlayedUnion ", ", members}} = require "#{path}"\n"""
  else if alias
    """#{alias} = require "#{path}"\n"""
  else
    """#{Array.last String.splitBy "/", path} = require "#{path}"\n"""
