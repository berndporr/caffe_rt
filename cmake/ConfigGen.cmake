
################################################################################################
# Helper function to get all list items that begin with given prefix
# Usage:
#   caffe_get_items_with_prefix(<prefix> <list_variable> <output_variable>)
function(caffe_get_items_with_prefix prefix list_variable output_variable)
  set(__result "")
  foreach(__e ${${list_variable}})
    if(__e MATCHES "^${prefix}.*")
      list(APPEND __result ${__e})
    endif()
  endforeach()
  set(${output_variable} ${__result} PARENT_SCOPE)
endfunction()

################################################################################################
# Function for generation Caffe build- and install- tree export config files
# Usage:
#  caffe_generate_export_configs()
function(caffe_generate_export_configs)
  set(install_cmake_suffix "share/Caffe")

  set(HDF5_IMPORTED OFF)
  foreach(_lib ${HDF5_LIBRARIES} ${HDF5_HL_LIBRARIES})
    if(TARGET ${_lib})
      set(HDF5_IMPORTED ON)
    endif()
  endforeach()

  # This code is taken from https://github.com/sh1r0/caffe-android-lib
  if(USE_HDF5)
    list(APPEND Caffe_DEFINITIONS -DUSE_HDF5)
  endif()

  # ---[ Configure build-tree CaffeConfig.cmake file ]---

  configure_file("cmake/Templates/CaffeConfig.cmake.in" "${PROJECT_BINARY_DIR}/CaffeConfig.cmake" @ONLY)

  # Add targets to the build-tree export set
  export(TARGETS caffe caffeproto FILE "${PROJECT_BINARY_DIR}/CaffeTargets.cmake")
  export(PACKAGE Caffe)

  # ---[ Configure install-tree CaffeConfig.cmake file ]---

  configure_file("cmake/Templates/CaffeConfig.cmake.in" "${PROJECT_BINARY_DIR}/cmake/CaffeConfig.cmake" @ONLY)

  # Install the CaffeConfig.cmake and export set to use with install-tree
  install(FILES "${PROJECT_BINARY_DIR}/cmake/CaffeConfig.cmake" DESTINATION ${install_cmake_suffix})
  install(EXPORT CaffeTargets DESTINATION ${install_cmake_suffix})

  # ---[ Configure and install version file ]---

  # TODO: Lines below are commented because Caffe doesn't declare its version in headers.
  # When the declarations are added, modify `caffe_extract_caffe_version()` macro and uncomment

  # configure_file(cmake/Templates/CaffeConfigVersion.cmake.in "${PROJECT_BINARY_DIR}/CaffeConfigVersion.cmake" @ONLY)
  # install(FILES "${PROJECT_BINARY_DIR}/CaffeConfigVersion.cmake" DESTINATION ${install_cmake_suffix})
endfunction()


