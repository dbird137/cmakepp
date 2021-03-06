function(sequence_to_list map sublist_separator list_separator)

  map_keys(${map})
  ans(keys)
  set(result)
  set(first true)
  foreach(key ${keys})
    map_tryget(${map} "${key}")
    ans(current)
    string(REPLACE ";" "${sublist_separator}" current "${current}")
    if(first)
      set(result "${current}")
      set(first false)
    else()

      set(result "${result}${list_separator}${current}")
    endif()
  endforeach()
  return_ref(result)
endfunction()