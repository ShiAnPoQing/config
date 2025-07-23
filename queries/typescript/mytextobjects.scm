  ; extends
  (function_declaration
   name: (identifier) @function_name)

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

