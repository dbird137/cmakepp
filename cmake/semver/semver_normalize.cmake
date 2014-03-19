
function(semver_normalize result version)
  foreach(i RANGE 3)
    semver_parse("${version}" IS_VALID isvalid)
    if(isvalid)
      return_value("${version}")
    endif()
    set(version "${version}.0")
  endforeach()
    return_value()
endfunction()