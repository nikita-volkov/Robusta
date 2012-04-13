# Robusta: generated require statements
Object = require "./Object"
HOFU = require "HOFU"

# Robusta: extracted code
reversed = (xs) ->
  ###
  TESTS: 
    import * from FueLTest
    
    equals [3,2,1], reversed [1,2,3]
    equals [], reversed []
    fails -> reversed null
  ###
  xs[i] for i in [xs.length-1..0]


### 
HIGHER ORDER 
###

spread = (f, xs) ->
  ###
  import even from FueL.Number
  {even} = require "FueL/Number"

      even = (x) -> x % 2 == 0

      spread even, [1,2,3,4,5]
      # [[2, 4], [1, 3, 5]]
      spread even, null
      # []
      spread even, []
      # []
  ###
  r1 = []
  r2 = []
  for x in xs
    if f x then r1.push x
    else r2.push x
  [r1, r2]




###
ASYNC ACTIONS
###

collect = HOFU.async (action, xs, cb) ->
  zs = []
  for x in xs
    action x, (z) ->
      zs.push z
      cb zs if zs.length == xs.length
      return
  cb zs unless xs.length > 0
  return

collectResults = (action, xs, cb) ->
  ###
  TESTS:
    action = (x, cb) -> setTimeout (-> cb x + 1), 1)
    collectResults1 = (cb) -> collectResults action, [1,2,3], cb
    callsBackIn 10, collectResults1
    collectResults1 (xs) -> includes [2,3,4], xs
  ###
  collect action, xs, (zs) ->
    zs1 = []
    zs1.push z for z in zs when z?
    cb zs1
    return
  return

# exports.each = 
# each = HOFU.async (action, xs, cb) ->
#   action x, cb for x in xs
#   return



# Robusta: generated export statements
exports.Array = Array
exports.collect = collect
exports.collectResults = collectResults
exports.reversed = reversed
exports.spread = spread
