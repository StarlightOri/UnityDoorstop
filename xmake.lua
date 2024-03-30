includes("info.lua")
local info = build_info(info_lua)

add_rules("mode.debug", "mode.release")

option("include_logging")
    set_showmenu(true)
    set_description("Include verbose logging on run")
    add_defines("VERBOSE")


target("doorstop")
    set_kind("shared")
    set_optimize("smallest")
    add_options("include_logging")
    set_filename("winhttp.dll")

    local load_events = {}

    if is_os("windows") then
        includes("src/windows/build_tools/proxygen.lua")
        add_proxydef(load_events)

        includes("src/windows/build_tools/rcgen.lua")
        add_rc(load_events, info)

        add_files("src/windows/*.c")
        add_defines("UNICODE")
        add_links("shell32", "kernel32", "user32")
    end

    if is_plat("windows") then
        add_cxflags("-GS-", "-Ob2", "-MT", "-GL-", "-FS")
        add_shflags("-nodefaultlib",
                    "-entry:DllEntry",
                    "-dynamicbase:no",
                    {force=true})
    end

    add_files("src/*.c")
    add_files("src/config/*.c")
    add_files("src/util/*.c")
    add_files("src/runtimes/*.c")

    on_load(function(target)
        for i, event in ipairs(load_events) do
            event(target, import, io)
        end
    end)
