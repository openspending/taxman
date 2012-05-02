dotaccess = require 'dotaccess'

documentation =
  'calculation.indirects': "These are estimated values of indirect tax payments based on Office of National Statistics figures."

exports.documentation = documentation

exports.add_documentation = (object) ->
  for own k, v of documentation
    if dotaccess.get(object, k)?
      dotaccess.set(object, k + '.message', v)

  return object
