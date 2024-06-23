# Set one of the variables:
# OS_AURORA_4 - Target OS is old Aurora 4 (<4.0.2.174)
# OS_AURORA_5 - Target OS is Aurora 4 (>=4.0.2.174) or Aurora 5
# OS_SAILFISH - Target OS is Sailfish

execute_process(COMMAND cat /etc/os-release
                OUTPUT_VARIABLE output
                RESULT_VARIABLE result)

if(${result} STREQUAL "0")
    string(REGEX MATCH "ID=[A-Za-z]+" os_id "${output}")
    string(SUBSTRING ${os_id} 3 -1 os_id)

    string(REGEX MATCH "VERSION_ID=[A-Za-z0-9\.]+" os_version "${output}")
    string(SUBSTRING ${os_version} 11 -1 os_version)
else()
    message(FATAL_ERROR "**** Can not get os id and version")
endif()

if(${os_id} STREQUAL "auroraos")
    if(os_version VERSION_GREATER_EQUAL 4.0.2.174)
        set(OS_AURORA_5 ON)
    else()
        set(OS_AURORA_4 ON)
    endif()
elseif(${os_id} STREQUAL "sailfishos")
    set(OS_SAILFISH ON)
else()
    message(FATAL_ERROR "**** Can not set os id")
endif()
