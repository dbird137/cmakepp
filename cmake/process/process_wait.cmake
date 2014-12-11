
  ## blocks until given process has terminated
  ## returns nothing if the process does not exist - is deleted etc
  ## updates and returns the process_handle
  ## if a timeout greater 0 the function will return nothing if the timeout is reached
  ## process_wait(<process handle> <?--timeout:<seconds>>)
  function(process_wait handle)
    process_handle("${handle}")
    ans(handle)

    set(args ${ARGN})
    list_extract_labelled_value(args --timeout)
    ans(timeout)

    if("${timeout}_" STREQUAL "_")
      set(timeout -1)
    endif()

    if("${timeout}" LESS 0)
      while(true)
        process_refresh_handle(${handle})
        ans(isrunning)
        if(NOT isrunning)
          return(${handle})
        endif()
      endwhile()
    elseif("${timeout}" EQUAL 0)
      process_refresh_handle(${handle})
      ans(isrunning)
      if(isrunning)
        return()
      else()
        return("${handle}")
      endif()
    else()
      process_timeout(${timeout})
      ans(timeout_handle)
      while(true)
        process_refresh_handle(${handle})
        ans(isrunning)
        if(NOT isrunning)
          return(${handle})
        endif()
        process_refresh_handle(${timeout_handle})
        ans(isrunning)
        if(NOT isrunning)
          return()
        endif()
      endwhile()
    endif()
endfunction()