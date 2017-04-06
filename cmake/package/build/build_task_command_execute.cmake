## executes a single command in a separate process
function(build_task_command_execute command)
    regex_cmake()
    set(handle)
    set(type shell)
    if("${command}" MATCHES "^(${regex_cmake_identifier})\\>(.*)$")
        set(type "${CMAKE_MATCH_1}")
        set(command "${CMAKE_MATCH_2}")
    endif()
    
   # message("executing '${type}' -- ${command}")

    if("${type}" STREQUAL "inline")
        eval_ref(command)
    else()
        if("${type}" STREQUAL "shell")
            shell("${command}" --process-handle)
            ans(handle)
        elseif("${type}" STREQUAL "cmake")
            execute_script("${command}" --process-handle --passthru)
            ans(handle)
        else()
            message(WARNING "invalid build command type: '${type}'")
            return(false)
        endif()

        map_tryget(${handle} exit_code)
        ans(error)

        if(error)
            message("failed to execute '${command}'")
            message(FORMAT "{handle.stderr}")
            return(false)
        endif()
    endif()
    
    return(true)
endfunction()
