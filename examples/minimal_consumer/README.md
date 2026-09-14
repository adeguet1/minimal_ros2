# Minimal Consumer Example

A standalone C++ CMake project demonstrating how to consume the  underlay.

## Features
- Discovers the underlay using .
- Uses , , and .
- Publishes and receives a  using .

## Building

[0/204] Performing update step for 'zlib'
-- Already at requested ref: de0aca6040339aad56d96ab1c29850b00ec36a9b
[1/204] Performing update step for 'BRAINSTools'
-- Already at requested ref: 768345a75b8bf4dcc05846f021053236961097d8
[2/204] Performing update step for 'vtkAddon'
-- Already at requested ref: 3dc6d63a86ed099d1da05dd10aa5ff4c49728959
[3/204] Performing update step for 'MultiVolumeImporter'
-- Already at requested ref: 144b2e466428f6d08689eec78977982cf01d54e0
[4/204] Performing update step for 'CompareVolumes'
-- Already at requested ref: 4bef316767f6ba62868a05db582f2289704458eb
[5/204] Performing update step for 'bzip2'
-- Already at requested ref: 66c46b8c9436613fd81bc5d03f63a61933a4dcc3
[6/204] Performing update step for 'SurfaceToolbox'
-- Already at requested ref: c96cdbe82a1892d695094c02be89a7bfc39d7a7f
[7/204] Performing update step for 'MultiVolumeExplorer'
-- Already at requested ref: 543f5bc46444a83474b185f4aa9c9d2a916ed09b
[8/204] Performing update step for 'LandmarkRegistration'
-- Already at requested ref: 370aeffacc1f24f4b57646d69300b7d26870a9d9
[27/204] No build step for 'vtkAddon'
[28/204] Performing configure step for 'zlib'
loading initial cache file /Users/anton/devel/slicer/build/zlib-prefix/tmp/zlib-cache-Release.cmake
-- Using CMake version 4.3.4
-- ZLIB_HEADER_VERSION: 1.3.1
-- ZLIBNG_HEADER_VERSION: 2.2.4
-- Arch detected: 'arm64'
-- Basearch of 'arm64' has been detected as: 'arm'
-- ARM floating point arch not auto-detected
-- Architecture-specific source files: arch/arm/arm_features.c;arch/arm/crc32_acle.c
-- The following features have been enabled:

 * CMAKE_BUILD_TYPE, Build type: Release (selected)
 * ACLE_CRC, Support ACLE optimized CRC hash generation, using "-march=armv8-a+crc"
 * ZLIB_SYMBOL_PREFIX, Publicly exported symbols have a custom prefix
 * WITH_GZFILEOP, Compile with support for gzFile related functions
 * ZLIB_COMPAT, Compile with zlib compatible API
 * ZLIBNG_ENABLE_TESTS, Test zlib-ng specific API
 * WITH_SANITIZER, Enable sanitizer support
 * WITH_GTEST, Build gtest_zlib
 * WITH_OPTIM, Build with optimisation
 * WITH_NEW_STRATEGIES, Use new strategies
 * WITH_RUNTIME_CPU_DETECTION, Build with runtime CPU detection
 * WITH_ACLE, Build with ACLE

-- The following features have been disabled:

 * ZLIB_ENABLE_TESTS, Build test binaries
 * WITH_FUZZERS, Build test/fuzz
 * WITH_BENCHMARKS, Build test/benchmarks
 * WITH_BENCHMARK_APPS, Build application benchmarks
 * WITH_NATIVE_INSTRUCTIONS, Instruct the compiler to use the full instruction set on this host (gcc/clang -march=native)
 * WITH_MAINTAINER_WARNINGS, Build with project maintainer warnings
 * WITH_CODE_COVERAGE, Enable code coverage reporting
 * WITH_INFLATE_STRICT, Build with strict inflate distance checking
 * WITH_INFLATE_ALLOW_INVALID_DIST, Build with zero fill for inflate invalid distances
 * WITH_NEON, Build with NEON intrinsics
 * WITH_ARMV6, Build with ARMv6 SIMD
 * INSTALL_UTILS, Copy minigzip and minideflate during install

-- Configuring done (0.1s)
-- Generating done (0.0s)
-- Build files have been written to: /Users/anton/devel/slicer/build/zlib-build
[46/204] Completed 'SurfaceToolbox'
[47/204] Performing update step for 'LibFFI'
-- Already at requested ref: 90704ad36f27b65b78573172127e7bea4ccd82bb
[48/204] Performing build step for 'zlib'
ninja: no work to do.
[49/204] No patch step for 'LibFFI'
[50/204] Performing update step for 'LZMA'
-- Already at requested tag: v5.8.2
[51/204] Performing install step for 'zlib'
[0/1] Install the project...
-- Install configuration: "Release"
-- Installing: /Users/anton/devel/slicer/build/zlib-install/lib/libzlib.a
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/include/zlib.h
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/include/zlib_name_mangling.h
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/include/zconf.h
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/lib/pkgconfig/zlib.pc
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/lib/cmake/ZLIB/zlib-config.cmake
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/lib/cmake/ZLIB/zlib-config-version.cmake
[52/204] No patch step for 'LZMA'
[53/204] Performing update step for 'sqlite'
-- Already at requested tag: 3.51.2
[54/204] Completed 'zlib'
[55/204] No configure step for 'OpenSSL'
[56/204] No patch step for 'sqlite'
[57/204] Performing configure step for 'bzip2'
loading initial cache file /Users/anton/devel/slicer/build/bzip2-prefix/tmp/bzip2-cache-Release.cmake
-- Summary of build options:

    Package version: 1.1.0
    Library version: 1:9:0
    Install prefix:  /Users/anton/devel/slicer/build/bzip2-install
    Target system:   Darwin
    Compiler:
        Build type:     Release
        C compiler:     /usr/bin/cc
        CFLAGS:         -O3      
        WARNCFLAGS:      -Wall -Wextra -Wmissing-prototypes -Wstrict-prototypes -Wmissing-declarations -Wpointer-arith -Wdeclaration-after-statement -Wformat-security -Wwrite-strings -Wshadow -Winline -Wnested-externs -Wfloat-equal -Wundef -Wendif-labels -Wempty-body -Wcast-align -Wvla -Wpragmas -Wunreachable-code -Waddress -Wattributes -Wdiv-by-zero -Wshorten-64-to-32 -Wconversion -Wformat-nonliteral -Wlanguage-extension-token -Wmissing-field-initializers -Wmissing-noreturn -Wmissing-variable-declarations -Wsign-conversion -Wunreachable-code-break -Wunused-macros -Wunused-parameter -Wredundant-decls -Wheader-guard -Wno-format-nonliteral
    Test:
        Python:          (, )
    Docs:
        Build docs:     OFF
    Features:
        Applications:   OFF
        Examples:       OFF

[58/204] Performing resolve_e_os2_symlink step for 'OpenSSL'
FAILED: [code=141] bzip2-prefix/src/bzip2-stamp/bzip2-configure /Users/anton/devel/slicer/build/bzip2-prefix/src/bzip2-stamp/bzip2-configure 
cd /Users/anton/devel/slicer/build/bzip2-build && /opt/homebrew/bin/cmake -GNinja -C/Users/anton/devel/slicer/build/bzip2-prefix/tmp/bzip2-cache-Release.cmake -S /Users/anton/devel/slicer/build/bzip2 -B /Users/anton/devel/slicer/build/bzip2-build && /opt/homebrew/bin/cmake -E touch /Users/anton/devel/slicer/build/bzip2-prefix/src/bzip2-stamp/bzip2-configure
ninja: build stopped: subcommand failed.

On Windows (Visual Studio):
[0/204] Performing update step for 'zlib'
-- Already at requested ref: de0aca6040339aad56d96ab1c29850b00ec36a9b
[1/204] Performing update step for 'CompareVolumes'
-- Already at requested ref: 4bef316767f6ba62868a05db582f2289704458eb
[2/204] Performing update step for 'bzip2'
-- Already at requested ref: 66c46b8c9436613fd81bc5d03f63a61933a4dcc3
[3/204] Performing update step for 'LandmarkRegistration'
-- Already at requested ref: 370aeffacc1f24f4b57646d69300b7d26870a9d9
[4/204] Performing update step for 'BRAINSTools'
-- Already at requested ref: 768345a75b8bf4dcc05846f021053236961097d8
[5/204] Performing update step for 'SurfaceToolbox'
-- Already at requested ref: c96cdbe82a1892d695094c02be89a7bfc39d7a7f
[6/204] Performing update step for 'vtkAddon'
-- Already at requested ref: 3dc6d63a86ed099d1da05dd10aa5ff4c49728959
[7/204] Performing update step for 'MultiVolumeExplorer'
-- Already at requested ref: 543f5bc46444a83474b185f4aa9c9d2a916ed09b
[8/204] Performing update step for 'MultiVolumeImporter'
-- Already at requested ref: 144b2e466428f6d08689eec78977982cf01d54e0
[30/204] No build step for 'MultiVolumeImporter'
[31/204] Performing configure step for 'zlib'
loading initial cache file /Users/anton/devel/slicer/build/zlib-prefix/tmp/zlib-cache-Release.cmake
-- Using CMake version 4.3.4
-- ZLIB_HEADER_VERSION: 1.3.1
-- ZLIBNG_HEADER_VERSION: 2.2.4
-- Arch detected: 'arm64'
-- Basearch of 'arm64' has been detected as: 'arm'
-- ARM floating point arch not auto-detected
-- Architecture-specific source files: arch/arm/arm_features.c;arch/arm/crc32_acle.c
-- The following features have been enabled:

 * CMAKE_BUILD_TYPE, Build type: Release (selected)
 * ACLE_CRC, Support ACLE optimized CRC hash generation, using "-march=armv8-a+crc"
 * ZLIB_SYMBOL_PREFIX, Publicly exported symbols have a custom prefix
 * WITH_GZFILEOP, Compile with support for gzFile related functions
 * ZLIB_COMPAT, Compile with zlib compatible API
 * ZLIBNG_ENABLE_TESTS, Test zlib-ng specific API
 * WITH_SANITIZER, Enable sanitizer support
 * WITH_GTEST, Build gtest_zlib
 * WITH_OPTIM, Build with optimisation
 * WITH_NEW_STRATEGIES, Use new strategies
 * WITH_RUNTIME_CPU_DETECTION, Build with runtime CPU detection
 * WITH_ACLE, Build with ACLE

-- The following features have been disabled:

 * ZLIB_ENABLE_TESTS, Build test binaries
 * WITH_FUZZERS, Build test/fuzz
 * WITH_BENCHMARKS, Build test/benchmarks
 * WITH_BENCHMARK_APPS, Build application benchmarks
 * WITH_NATIVE_INSTRUCTIONS, Instruct the compiler to use the full instruction set on this host (gcc/clang -march=native)
 * WITH_MAINTAINER_WARNINGS, Build with project maintainer warnings
 * WITH_CODE_COVERAGE, Enable code coverage reporting
 * WITH_INFLATE_STRICT, Build with strict inflate distance checking
 * WITH_INFLATE_ALLOW_INVALID_DIST, Build with zero fill for inflate invalid distances
 * WITH_NEON, Build with NEON intrinsics
 * WITH_ARMV6, Build with ARMv6 SIMD
 * INSTALL_UTILS, Copy minigzip and minideflate during install

-- Configuring done (0.1s)
-- Generating done (0.0s)
-- Build files have been written to: /Users/anton/devel/slicer/build/zlib-build
[46/204] Completed 'MultiVolumeImporter'
[47/204] Performing update step for 'LibFFI'
-- Already at requested ref: 90704ad36f27b65b78573172127e7bea4ccd82bb
[48/204] Performing build step for 'zlib'
ninja: no work to do.
[49/204] No patch step for 'LibFFI'
[50/204] Performing update step for 'LZMA'
-- Already at requested tag: v5.8.2
[51/204] Performing install step for 'zlib'
[0/1] Install the project...
-- Install configuration: "Release"
-- Installing: /Users/anton/devel/slicer/build/zlib-install/lib/libzlib.a
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/include/zlib.h
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/include/zlib_name_mangling.h
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/include/zconf.h
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/lib/pkgconfig/zlib.pc
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/lib/cmake/ZLIB/zlib-config.cmake
-- Up-to-date: /Users/anton/devel/slicer/build/zlib-install/lib/cmake/ZLIB/zlib-config-version.cmake
[52/204] No patch step for 'LZMA'
[53/204] Performing update step for 'sqlite'
-- Already at requested tag: 3.51.2
[54/204] Completed 'zlib'
[55/204] No configure step for 'OpenSSL'
[56/204] Performing configure step for 'bzip2'
loading initial cache file /Users/anton/devel/slicer/build/bzip2-prefix/tmp/bzip2-cache-Release.cmake
-- Summary of build options:

    Package version: 1.1.0
    Library version: 1:9:0
    Install prefix:  /Users/anton/devel/slicer/build/bzip2-install
    Target system:   Darwin
    Compiler:
        Build type:     Release
        C compiler:     /usr/bin/cc
        CFLAGS:         -O3      
        WARNCFLAGS:      -Wall -Wextra -Wmissing-prototypes -Wstrict-prototypes -Wmissing-declarations -Wpointer-arith -Wdeclaration-after-statement -Wformat-security -Wwrite-strings -Wshadow -Winline -Wnested-externs -Wfloat-equal -Wundef -Wendif-labels -Wempty-body -Wcast-align -Wvla -Wpragmas -Wunreachable-code -Waddress -Wattributes -Wdiv-by-zero -Wshorten-64-to-32 -Wconversion -Wformat-nonliteral -Wlanguage-extension-token -Wmissing-field-initializers -Wmissing-noreturn -Wmissing-variable-declarations -Wsign-conversion -Wunreachable-code-break -Wunused-macros -Wunused-parameter -Wredundant-decls -Wheader-guard -Wno-format-nonliteral
    Test:
        Python:          (, )
    Docs:
        Build docs:     OFF
    Features:
        Applications:   OFF
        Examples:       OFF

[58/204] Performing resolve_e_os2_symlink step for 'OpenSSL'
FAILED: [code=141] bzip2-prefix/src/bzip2-stamp/bzip2-configure /Users/anton/devel/slicer/build/bzip2-prefix/src/bzip2-stamp/bzip2-configure 
cd /Users/anton/devel/slicer/build/bzip2-build && /opt/homebrew/bin/cmake -GNinja -C/Users/anton/devel/slicer/build/bzip2-prefix/tmp/bzip2-cache-Release.cmake -S /Users/anton/devel/slicer/build/bzip2 -B /Users/anton/devel/slicer/build/bzip2-build && /opt/homebrew/bin/cmake -E touch /Users/anton/devel/slicer/build/bzip2-prefix/src/bzip2-stamp/bzip2-configure
ninja: build stopped: subcommand failed.
