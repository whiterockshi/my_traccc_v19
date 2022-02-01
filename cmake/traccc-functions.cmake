# TRACCC library, part of the ACTS project (R&D line)
#
# (c) 2021-2022 CERN for the benefit of the ACTS project
#
# Mozilla Public License Version 2.0

# Guard against multiple includes.
include_guard( GLOBAL )

# CMake include(s).
include( CMakeParseArguments )

# Function for declaring the libraries of the project
#
# Usage: traccc_add_library( traccc_core core
#                            [TYPE SHARED/INTERFACE/STATIC]
#                            include/source1.hpp source2.cpp )
#
function( traccc_add_library fullname basename )

   # Parse the function's options.
   cmake_parse_arguments( ARG "" "TYPE" "" ${ARGN} )

   # Group the source files.
   vecmem_group_source_files( ${ARG_UNPARSED_ARGUMENTS} )

   # Create the library.
   add_library( ${fullname} ${ARG_TYPE} ${ARG_UNPARSED_ARGUMENTS} )

   # Set up how clients should find its headers.
   set( _depType PUBLIC )
   if( "${ARG_TYPE}" STREQUAL "INTERFACE" )
      set( _depType INTERFACE )
   endif()
   target_include_directories( ${fullname} ${_depType}
      $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
      $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}> )
   unset( _depType )

   # Make sure that the library is available as "traccc::${basename}" in every
   # situation.
   set_target_properties( ${fullname} PROPERTIES EXPORT_NAME ${basename} )
   add_library( traccc::${basename} ALIAS ${fullname} )

   # Specify the (SO)VERSION of the library.
   if( NOT "${ARG_TYPE}" STREQUAL "INTERFACE" )
      set_target_properties( ${fullname} PROPERTIES
         VERSION ${PROJECT_VERSION}
         SOVERSION ${PROJECT_VERSION_MAJOR} )
   endif()

   # Set up the installation of the library and its headers.
   install( TARGETS ${fullname}
      EXPORT traccc-exports
      LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
      ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
      RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}" )
   install( DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/"
      DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}" )

endfunction( traccc_add_library )

# Helper function for adding individual flags to "flag variables".
#
# Usage: traccc_add_flag( CMAKE_CXX_FLAGS "-Wall" )
#
function( traccc_add_flag name value )

   # Escape special characters in the value:
   set( matchedValue "${value}" )
   foreach( c "*" "." "^" "$" "+" "?" )
      string( REPLACE "${c}" "\\${c}" matchedValue "${matchedValue}" )
   endforeach()

   # Check if the variable already has this value in it:
   if( "${${name}}" MATCHES "${matchedValue}" )
      return()
   endif()

   # If not, then let's add it now:
   set( ${name} "${${name}} ${value}" PARENT_SCOPE )

endfunction( traccc_add_flag )
