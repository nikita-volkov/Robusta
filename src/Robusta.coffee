{Action, Actions, Array, Arrays, Environment, Function, FunctionByLengthMap, FunctionByTypesPairs, FunctionTemplate, Keys, Map, Maps, Number, Numbers, Object, Optional, Optionals, Pair, Pairs, RegExp, Set, SortedArray, String, Strings, Text} = require "Fuell"
{Path, Paths, Environment} = require "FuellSys"
FS = require "fs"
CoffeeScript = require "coffee-script"
Analysis = require "./Robusta/Analysis"
Parsing = require "./Robusta/Parsing"
Rendering = require "./Robusta/Rendering"



exports.compileToCoffee = 
compileToCoffee = (targetDir, srcDir, cb = ->) ->
  Function.callAsync ->
    srcDir = Path.correct srcDir
    targetDir = Path.correct targetDir
    coffeeFiles = Paths.byExtension "coffee", Path.deepPaths srcDir

    targetFile = (module) ->
      String.prepending targetDir + "/",
      String.appending ".coffee",
      String.replacing ".", "/", module

    save = ([module, code], cb) ->
      Path.saveFile code, (targetFile module), cb

    Path.cleanDir targetDir, -> 
      Array.collect save, (Map.pairs codeByModuleMap srcDir), cb

exports.compileToJS = 
compileToJS = (targetDir, srcDir, cb = ->) ->
  Function.callAsync ->
    srcDir = Path.correct srcDir
    targetDir = Path.correct targetDir
    coffeeFiles = Paths.byExtension "coffee", Path.deepPaths srcDir

    targetFile = (module) ->
      String.prepending targetDir + "/",
      String.appending ".js",
      String.replacing ".", "/", module

    save = ([module, code], cb) ->
      file = targetFile module
      code = CoffeeScript.compile code, {filename: file}
      Path.saveFile code, file, cb

    Path.cleanDir targetDir, -> 
      Array.collect save, (Map.pairs codeByModuleMap srcDir), cb



codeByModuleMap = (srcDir) ->
  coffeeFiles = Paths.byExtension "coffee", Path.deepPaths srcDir

  moduleNameFromFile = (file) ->
    String.replacing "/", ".", 
    String.remainder srcDir + "/",
    Path.withoutExtension file

  moduleParsingPair = (file) ->
    [
      moduleNameFromFile file
      Parsing.parsing Path.fileContents file
    ]


  Map.mappingValues Rendering.render, 
  Analysis.analysisByModuleMap Pairs.map Array.results moduleParsingPair, 
  coffeeFiles
