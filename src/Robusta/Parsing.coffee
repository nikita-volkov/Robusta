{Action, Actions, Array, Arrays, Environment, Function, FunctionByLengthMap, FunctionByTypesPairs, FunctionTemplate, Keys, Map, Maps, Number, Numbers, Object, Optional, Optionals, Pair, Pairs, RegExp, Set, SortedArray, String, Strings, Text} = require "Fuell"


membersListR = "(?:\\w+\\s*,\\s*)*\\w+"
lineEndR = "\\r\\n|\\n|\\r"
statementEndR = "(?=\\s|\\n|\\r|#|$)[ \\t]*(?:#{lineEndR})?"
moduleR = "(?:[\\w-]+\\.)*[\\w-]+"
remainderR = "[\\s\\S]*$"
allButR = "\\*(?:\\s+but\\s+(#{membersListR}))?"

statementRegexesAndHandlers =
  [
    [      
      "export\\s+(#{membersListR})#{statementEndR}"
      ([list]) ->
        type: "export"
        list: Optional.result membersListParsing, list
    ]
    [
      "export\\s+#{allButR}#{statementEndR}"
      ([list]) ->
        type: "exportAllBut"
        list: Optional.result membersListParsing, list
    ]
    [
      "import\\s+(#{moduleR})(?:\\s+as\\s+(#{moduleR}))?#{statementEndR}"
      ([module, alias]) ->
        type: "importAs"
        module: module
        alias: alias
    ]
    [
      "import\\s+(#{membersListR})\\s+from\\s+(#{moduleR})#{statementEndR}"
      ([list, module]) -> 
        type: "importFrom"
        list: Optional.result membersListParsing, list
        module: module
    ]
    [
      "import\\s+#{allButR}\\s+from\\s+(#{moduleR})#{statementEndR}"
      ([list, module]) ->
        type: "importAllButFrom"
        list: Optional.result membersListParsing, list
        module: module
    ]
    [
      "[ \\t]*#\\s*([^\\r\\n]*)#{statementEndR}"
      ([text]) -> 
        type: "comment"
        text: text
    ]
    [
      "[ \\t]*###(\\s*[\\s\\S]*)####{statementEndR}"
      ([text]) -> 
        type: "multilineComment"
        text: text
    ]
    [
      "([\\s]*)(?:#{lineEndR})"
      # "([\\s]+)#{statementEndR}"
      ([text]) -> 
        type: "gap"
        text: text
    ]
  ]

membersListParsing = (code) ->
  Array.results String.trimmed, String.splitBy ",", code

topLevelMembers = (code) ->
  Array.results [String.replacing, /^class\s+/, ""], 
  String.matches ///^ class\s+(\w+) | ^ (\w+)(?=\s*=(?:[^=])) ///gm, 
  code

fetchRegex = (regex) -> RegExp.RegExp "^#{regex}([\\s\\S]*)$"
fetchHandler = (handler) -> 
  (args) ->
    [extracts..., code] = args
    [(handler extracts), code]
  # ([extracts..., code]) -> [(handler extracts), code]
fetchAttempt = (code, [regex, handler]) ->
  Optional.result (fetchHandler handler), 
  String.extracts (fetchRegex regex), 
  code
fetch = (code) ->
  Array.firstResult [fetchAttempt, code], statementRegexesAndHandlers

exports.parsing = 
parsing = (code) ->
  statements = []
  while fetch1 = fetch code
    statements.push fetch1[0]
    code = fetch1[1]

  {
    statements: statements
    topLevelMembers: topLevelMembers code
    remainder: code
  }

