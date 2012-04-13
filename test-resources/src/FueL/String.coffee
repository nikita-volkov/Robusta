export * but length
export String

repeated = (times, string) ->
  r = ""
  r += string for i in [0...times]
  r

remainder = (beginning, string) ->
  if startsWith beginning, string
    dropping (length beginning), string

length = (x) -> x.length

