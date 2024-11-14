# Set one of the variables:
# OS_AURORA_4 - Target OS is old Aurora 4 (<4.0.2.174)
# OS_AURORA_5 - Target OS is Aurora 4 (>=4.0.2.174) or Aurora 5
# OS_SAILFISH - Target OS is Sailfish

# Set ARCHITECTURE variable string with is an architecture of the build targer

# Set TARGET variable string with is a full version of the target
# like "AuroraOS-5.1.0.100-base-aarch64" or "SailfishOS-4.5.0.18-i486"

execute_process(COMMAND cat /etc/os-release
                OUTPUT_VARIABLE output
                RESULT_VARIABLE result)

if(${result} STREQUAL "0")
    string(REGEX MATCH "ID=[A-Za-z]+" os_id "${output}")
    string(SUBSTRING ${os_id} 3 -1 os_id)

    string(REGEX MATCH "VERSION_ID=[A-Za-z0-9.]+" os_version "${output}")
    string(SUBSTRING ${os_version} 11 -1 os_version)
else()
    message(FATAL_ERROR "**** Can not get os id and version")
endif()

execute_process(COMMAND g++ -dumpmachine
                OUTPUT_STRIP_TRAILING_WHITESPACE
                OUTPUT_VARIABLE output
                RESULT_VARIABLE result)

if(${result} STREQUAL "0")
    set(ARCHITECTURE ${output})
else()
    message(FATAL_ERROR "**** Can not get compiler architecture")
endif()


if(${os_id} STREQUAL "auroraos")
    if(os_version VERSION_GREATER_EQUAL 4.0.2.175)
        set(OS_AURORA_5 ON)
    else()
        set(OS_AURORA_4 ON)
    endif()
elseif(${os_id} STREQUAL "sailfishos")
    set(OS_SAILFISH ON)
else()
    message(FATAL_ERROR "**** Can not set os id")
endif()

if(${ARCHITECTURE} STREQUAL "aarch64-meego-linux-gnu")
    set(arch "aarch64")
elseif(${ARCHITECTURE} STREQUAL "armv7hl-meego-linux-gnueabi")
    set(arch "armv7hl")
elseif(${ARCHITECTURE} STREQUAL "x86_64-meego-linux-gnu")
    set(arch "x86_64")
elseif(${ARCHITECTURE} STREQUAL "i486-meego-linux-gnu")
    set(arch "i486")
else()
    message(FATAL_ERROR "**** Can not get short name of the architecture")
endif()

if(${os_id} STREQUAL "auroraos")
    set(TARGET "AuroraOS-${os_version}-base-${arch}")
elseif(${os_id} STREQUAL "sailfishos")
    set(TARGET "SailfishOS-${os_version}-${arch}")
else()
    message(FATAL_ERROR "**** Can not form target name")
endif()
