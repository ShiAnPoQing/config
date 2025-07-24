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

(type_alias_declaration
  name: (type_identifier) @type_name)

(type_alias_declaration
  value: (object_type) @type_value)

(interface_declaration
  name: (type_identifier) @interface_name)

(interface_declaration
  (interface_body) @interface_body)

