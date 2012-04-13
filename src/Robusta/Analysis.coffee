{Action, Actions, Array, Arrays, Environment, Function, FunctionByLengthMap, FunctionByTypesPairs, FunctionTemplate, Keys, Map, Maps, Number, Numbers, Object, Optional, Optionals, Pair, Pairs, RegExp, Set, SortedArray, String, Strings, Text} = require "Fuell"
{Path} = require "FuellSys"


exports.analysisByModuleMap =
analysisByModuleMap = (parsingByModuleMap) ->
  exportsByModuleMap = Map.mappingValues exportedMembers, parsingByModuleMap

  analysisByModulePair = (module, parsing) ->
    [
      module
      {
        exports: 
          exportsByModuleMap[module]
        requireInstructions: 
          requireInstructions exportsByModuleMap, parsing.statements, module
        code:
          parsing.remainder
      }
    ]
  Map.mapping analysisByModulePair, parsingByModuleMap
  # Pairs.map Array.results analysisByModulePair, Map.pairs exportsByModuleMap

requireInstructions = (exportsByModuleMap, statements, module) ->
  absPath = (module) -> String.replacing ".", "/", module

  requirePath = (module1) ->
    if Map.hasKey module1, exportsByModuleMap
      "./" + Path.relativeTo (absPath module), (absPath module1)
    else absPath module1

  moduleExports = (module) ->
    (exportsByModuleMap[module]) ||
    (Object.keys require String.replacing ".", "/", module)
    # do ->
    #   require.paths.push # blablabla

  instruction = (stmt) ->
    switch stmt.type
      when "importAs"
        path: requirePath stmt.module
        alias: stmt.alias
      when "importFrom"
        path: requirePath stmt.module
        members: stmt.list
      when "importAllButFrom"
        path: requirePath stmt.module
        members: Array.difference stmt.list, moduleExports stmt.module

  Array.results instruction, statements


exportedMembers = (parsing) ->
  {statements, topLevelMembers} = parsing
  statementsOfType = (type) -> Array.matches ((x) -> x.type == type), statements
  exportStatements = statementsOfType "export"
  exportAllStatements = statementsOfType "exportAllBut"
  
  # if not Array.allMatch Array.empty, [exportStatements, exportAllStatements]
  #   SortedArray.unique Array.sorted Array.union(
  #     Arrays.union Array.results [Map.value, "list"], exportStatements
  #     if not Array.empty exportAllStatements 
  #       Array.difference(
  #         Arrays.union Array.results [Map.value, "list"], exportAllStatements
  #         topLevelMembers
  #       )
  #     else []
  #   )
  # else topLevelMembers
  
  SortedArray.unique Array.sorted Array.union(
    Arrays.union Array.results [Map.value, "list"], exportStatements
    if not Array.empty exportAllStatements 
      Array.difference(
        Arrays.union Array.results [Map.value, "list"], exportAllStatements
        topLevelMembers
      )
    else []
  )

