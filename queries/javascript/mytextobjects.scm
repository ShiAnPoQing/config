; extends
(function_declaration
 name: (identifier) @function_name)

(function_declaration
 parameters: (formal_parameters) @function.params
)

; extends
(variable_declarator
 name: (identifier) @variable_name)

; extends
(variable_declarator
  name: (identifier)
  (_) @variable_value)


(import_statement
  source: (string
    (string_fragment) @import_source))

(import_statement
  (import_clause) @import_clause)


(import_statement) @import

(arrow_function
  parameters: (formal_parameters) @arrow_function.parameters
  body: (statement_block) @arrow_function.body
) @arrow_function
