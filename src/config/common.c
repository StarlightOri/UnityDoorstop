#include "../crt.h"
#include "config.h"

Config config;

void cleanup_config() {
#define FREE_NON_NULL(val)                                                     \
    if (val != NULL) {                                                         \
        free(val);                                                             \
        val = NULL;                                                            \
    }

    FREE_NON_NULL(config.target_assembly);
    FREE_NON_NULL(config.mono_dll_search_path_override);
    FREE_NON_NULL(config.mono_debug_address);

#undef FREE_NON_NULL
}

void init_config_defaults() {
    config.enabled = FALSE;
    config.redirect_output_log = FALSE;
    config.mono_debug_enabled = FALSE;
    config.mono_debug_suspend = FALSE;
    config.mono_debug_address = NULL;
    config.target_assembly = TEXT("OML\\core\\OML.dll");
    config.mono_dll_search_path_override = NULL;
}