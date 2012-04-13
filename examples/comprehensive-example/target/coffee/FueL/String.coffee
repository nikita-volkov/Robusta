# Robusta: generated require statements

# Robusta: extracted code
repeated = (times, string) ->
  r = ""
  r += string for i in [0...times]
  r

remainder = (beginning, string) ->
  if startsWith beginning, string
    dropping (length beginning), string

length = (x) -> x.length



# Robusta: generated export statements
exports.String = String
exports.remainder = remainder
exports.repeated = repeated
