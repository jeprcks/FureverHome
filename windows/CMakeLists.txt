# Project-level configuration.
cmake_minimum_required(VERSION 3.15)

# Prevent CMake deprecation warnings
cmake_policy(SET CMP0135 NEW)

# Set C++ compiler path explicitly
set(CMAKE_CXX_COMPILER "C:/Program Files/Microsoft Visual Studio/2022/BuildTools/VC/Tools/MSVC/14.xx.xxxxx/bin/Hostx64/x64/cl.exe")

project(furever_home_admin LANGUAGES CXX)

# The name of the executable created for the application. Change this to change
# the on-disk name of your application.
set(BINARY_NAME "furever_home_admin")
set(APPLICATION_ID "com.example.furever_home_admin")

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(VERSION 3.14...3.25)
cmake_policy(SET CMP0063 NEW)

# Define build configuration option.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Profile" "Release")
  endif()
endif()
# Define settings for the Profile build mode.
set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")

# Use Unicode for all projects.
add_definitions(-DUNICODE -D_UNICODE)

# Compilation settings that should be applied to most targets.
#
# Be cautious about adding new options here, as plugins use this function by
# default. In most cases, you should add new options to specific targets instead
# of modifying this function.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
  target_compile_options(${TARGET} PRIVATE /EHsc)
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

# Flutter library and tool build rules.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# Application build; see runner/CMakeLists.txt.
add_subdirectory("runner")


# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)

# Set the install RPATH
set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

# Download Firebase C++ SDK manually
set(FIREBASE_SDK_VERSION "11.10.0")
set(FIREBASE_SDK_DIR "${CMAKE_CURRENT_BINARY_DIR}/firebase_cpp_sdk")

if(NOT EXISTS ${FIREBASE_SDK_DIR})
    file(DOWNLOAD
        "https://dl.google.com/firebase/sdk/cpp/firebase_cpp_sdk_windows_${FIREBASE_SDK_VERSION}.zip"
        "${CMAKE_CURRENT_BINARY_DIR}/firebase_cpp_sdk.zip"
        SHOW_PROGRESS
    )
    
    file(ARCHIVE_EXTRACT INPUT "${CMAKE_CURRENT_BINARY_DIR}/firebase_cpp_sdk.zip"
        DESTINATION "${CMAKE_CURRENT_BINARY_DIR}"
    )
endif()

set(FIREBASE_CPP_SDK_DIR ${FIREBASE_SDK_DIR})
add_subdirectory(${FIREBASE_SDK_DIR} binary_dir EXCLUDE_FROM_ALL)

# Fetch and make available the Firebase C++ SDK
include(FetchContent)
FetchContent_Declare(
  firebase_cpp_sdk
  URL https://firebase.google.com/download/cpp
  DOWNLOAD_EXTRACT_TIMESTAMP true
)
FetchContent_MakeAvailable(firebase_cpp_sdk)

# === Installation ===
# Support files are copied into place next to the executable, so that it can
# run in place. This is done instead of making a separate bundle (as on Linux)
# so that building and running from within Visual Studio will work.
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
# Make the "install" step default, as it's required to run.
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

# Copy the native assets provided by the build.dart from all packages.
set(NATIVE_ASSETS_DIR "${PROJECT_BUILD_DIR}native_assets/windows/")
install(DIRECTORY "${NATIVE_ASSETS_DIR}"
   DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
   COMPONENT Runtime)

# Fully re-copy the assets directory on each build to avoid having stale files
# from a previous install.
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
  " COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}"
  DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# Install the AOT library on non-Debug builds only.
install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  CONFIGURATIONS Profile;Release
  COMPONENT Runtime)

# Firebase SDK Configuration
set(FIREBASE_SDK_VERSION "11.10.0")
set(FIREBASE_SDK_DIR "${CMAKE_CURRENT_SOURCE_DIR}/firebase_cpp_sdk")

if(NOT EXISTS ${FIREBASE_SDK_DIR})
    message(STATUS "Downloading Firebase C++ SDK...")
    file(MAKE_DIRECTORY ${FIREBASE_SDK_DIR})
    
    file(DOWNLOAD
        "https://firebase.google.com/download/cpp"
        "${FIREBASE_SDK_DIR}/firebase_cpp_sdk.zip"
        SHOW_PROGRESS
    )
    
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar xzf "${FIREBASE_SDK_DIR}/firebase_cpp_sdk.zip"
        WORKING_DIRECTORY ${FIREBASE_SDK_DIR}
    )
endif()

if(EXISTS ${FIREBASE_SDK_DIR})
    add_subdirectory(${FIREBASE_SDK_DIR} binary_dir EXCLUDE_FROM_ALL)
endif()

# Flutter configuration
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(flutter)
add_subdirectory(runner)

# Firebase dependencies
target_link_libraries(${BINARY_NAME} PRIVATE
    firebase_core
    firebase_auth
    firebase_storage
    firebase_firestore
)

list(APPEND FLUTTER_FFI_PLUGIN_LIST)
