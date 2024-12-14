function(AssureOutOfSourceBuilds)
  # Resolve the real path of the source and binary directories
  get_filename_component(srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
  get_filename_component(bindir "${CMAKE_BINARY_DIR}" REALPATH)

  # Disallow in-source builds
  if("${srcdir}" STREQUAL "${bindir}")
    message(FATAL_ERROR "
      ######################################################
      Warning: In-source builds are disabled.
      Please create a separate build directory and run CMake from there.
      ######################################################
    ")
  endif()
endfunction()

# Call the function to enforce out-of-source builds
AssureOutOfSourceBuilds()
