# Update xcconfig
MODES="debug release"
XCCONFIG_PATH=Pods/Target\ Support\ Files/MoproKit
CONFIGS="
LIBRARY_SEARCH_PATHS=\${SRCROOT}/../../MoproKit/Libs
OTHER_LDFLAGS=-lmopro_ffi
USER_HEADER_SEARCH_PATHS=\${SRCROOT}/../../MoproKit/include
"
for mode in $MODES; do
    FILE_NAME="${XCCONFIG_PATH}/MoproKit.${mode}.xcconfig"
    for config in $CONFIGS; do
        if ! grep -q "${config}" "${FILE_NAME}"; then
            echo "${config}" >> "${FILE_NAME}"
        fi
    done
done
