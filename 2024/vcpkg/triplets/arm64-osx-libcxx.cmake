set(VCPKG_TARGET_ARCHITECTURE arm64)
set(VCPKG_CMAKE_SYSTEM_NAME Darwin)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CRT_LINKAGE static)

set(VCPKG_CXX_FLAGS "-stdlib=libc++")
set(VCPKG_C_FLAGS "")

set(VCPKG_CXX_FLAGS_RELEASE "-O3 -stdlib=libc++")
set(VCPKG_C_FLAGS_RELEASE "-O3")

set(VCPKG_CXX_FLAGS_DEBUG "-g -stdlib=libc++")
set(VCPKG_C_FLAGS_DEBUG "-g")
