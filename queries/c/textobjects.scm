(function_definition) @function.outer 

(function_definition 
    body: (_) @function.inner) 

(function_definition
    declarator: (function_declarator
      declarator: (identifier) @function.name 
      parameters: (parameter_list))) 

(preproc_include
    path: (_) @include.path) @include

(function_definition
    body: (compound_statement 
      (return_statement) @function.return)) 

(return_statement) @return 

[
 (if_statement) 
 (while_statement) 
 (for_statement) 
 ] @statement.outer 

(if_statement 
  condition: (_) @condition)
