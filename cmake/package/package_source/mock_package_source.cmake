## 
##
## package source to be used for testing purposes 
## allows easy definition of packages and dependency relationsships
## to define a package write "<package id>[@<verion>][ <package descriptor obj>]"
## e.g. "A" "A@3.2.1" "A@3.4.1 {cmakepp:{hooks:{on_ready:'[]()message(ready)'}}}"
## to define a relationship write "<package id> => <package id>"
function(mock_package_source name)
  metadata_package_source("${name}")
  ans(package_source)
  map_new()
  ans(graph)
  foreach(arg ${ARGN})
    if("${arg}" MATCHES "(.+)=>(.+)")
      set(id "${CMAKE_MATCH_1}")
      set(dep "${CMAKE_MATCH_2}")
      map_tryget(${graph} "${id}")
      ans(pd)
      if(NOT pd)
        message(FATAL_ERROR "no package found called ${id}")
      endif()

      map_new()
      ans(ph)
      map_set("${ph}" package_descriptor "${pd}") 
      package_handle_update_dependencies("${ph}" "${dep}")
    else()
      if("${arg}" MATCHES "([^ ]+) (.+)")
        set(id "${CMAKE_MATCH_1}")
        set(config "${CMAKE_MATCH_2}")
      else()
        set(id "${arg}")
        set(config "")
      endif()
      set(unique_id "${id}")
      if("${id}" MATCHES "(.+)@(.+)")
        set(id "${CMAKE_MATCH_1}")
        set(version "${CMAKE_MATCH_2}")
      else()
        set(version "0.0.0")
      endif()

      map_capture_new(id version)
      ans(pd)
      if(config)
        map_copy_shallow(${pd} ${config})
      endif()
      map_set(${graph} "${unique_id}" "${pd}")
    endif()


  endforeach()
  map_values(${graph})
  ans(pds)
  foreach(pd ${pds})
    assign(success = package_source.add_package_descriptor("${pd}"))
  endforeach()
  return_ref(package_source)
endfunction()