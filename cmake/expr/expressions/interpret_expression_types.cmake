
function(interpret_expression_types tokens types)
  foreach(type ${types})
    eval("${type}(\"${tokens}\")")    
    ans(ast)
    if(ast)
      return(${ast})  
    endif()
  endforeach()
  throw("no expression could be interpreted" --function interpret_expression_types)
endfunction()