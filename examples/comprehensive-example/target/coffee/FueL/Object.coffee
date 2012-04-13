# Robusta: generated require statements

# Robusta: extracted code
HOFU = require "../HOFU"

exports.Object = Object

###
HIGHER ORDER
###

exports.result = 
result = HOFU.composable (f, o) -> f o if o? 


###
GENERAL
###

exports.union = 
union = (y, x) ->
  r = {}
  r[k] = v for k, v of x
  r[k] = v for k, v of y
  r

exports.keys = 
keys = (x) -> 
  k for k of x



# Robusta: generated export statements
