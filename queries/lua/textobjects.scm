; extends
(function_declaration 
  name: (identifier) @function.name)

(function_definition) @function.outer
(function_definition body: (_) @function.inner)
