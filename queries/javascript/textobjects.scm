; extends
(function_declaration
 name: (identifier) @function.name)

(function_declaration) @function.outer

(function_declaration
    body: (_) @function.inner) 

(function_declaration
 parameters: (formal_parameters) @function.params
)

(variable_declarator
 name: (identifier) @variable.name)

(variable_declarator
  name: (identifier)
  (_) @variable.value)


(import_statement
  source: (string
    (string_fragment) @import.source))

(import_statement
  (import_clause) @import.clause)


(import_statement) @import

(arrow_function
  parameters: (formal_parameters) @arrow_function.parameters
  body: (statement_block) @arrow_function.body
) @arrow_function
