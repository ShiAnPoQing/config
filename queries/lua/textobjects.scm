; extends
(function_declaration 
  name: (identifier) @function.name)

(function_definition body: (_) @function.inner)

(function_declaration
  name: (identifier)
  parameters: (parameters)
  body: (_) @function.inner) 

[
 (function_definition)
 (function_declaration
   name: (identifier)
   parameters: (parameters)
   body: (_))
 ] @function.outer 

(function_call) @function.call 

(function_declaration 
    body: (block 
      (return_statement) @function.return)) 

(return_statement) @return 

(if_statement
  condition: (_) @condition)

[
 (if_statement) 
 (while_statement) 
 (for_statement) 
 ] @statement.outer 

(expression_list) @expression_list

(field
  name: (_)
  value: (_) @equal.right) 

(assignment_statement
  (variable_list
    name: (_))
  (expression_list 
    value: (_)) @equal.right)
