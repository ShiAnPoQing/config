; extends
(function_declaration
 name: (identifier) @function.name)

(function_declaration) @function.outer

(function_declaration
    body: (_) @function.inner) 

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

(type_alias_declaration
  name: (type_identifier) @type.name)

(type_alias_declaration
  value: (object_type) @type.value)

(interface_declaration
  name: (type_identifier) @interface.name)

(interface_declaration
  (interface_body) @interface.body)

(jsx_element) @jsx_element.outer

(jsx_opening_element
  name: (identifier) @jsx_opening_element.name)

(jsx_element
  (jsx_element) @jsx_element.inner)

