-- name of the entire codebase
workspace "hello"
  -- what ways this project can be built (dbg is the default because it is first)
  configurations { "dbg", "dist" }
  -- written in C (this only matters in VS)
  language "C"

  -- lua variable
  SOURCEDIR = "src"

  -- make an executable named prog
  project "prog"
    kind "consoleapp"

    files { "src/%{wks.name}.*" }

    links { "m", "pthread", "fnv" }

    targetdir "bin/%{cfg.buildcfg}"

  -- make a lib named 'libhello.a'
  project "hello"
    kind "staticlib"

    libfiles = {}

    for dir in io.popen("find src/lib/ -maxdepth 1 -type d | tail -1"):lines()
    do
      table.insert(libfiles, path.join(dir, path.getbasename(dir) .. "common.c"))
    end

    files(libfiles)

    links { "m", "pthread", "fnv" }

    targetdir "bin/%{cfg.buildcfg}/lib"

  -- make the tests
  project "test"
    kind "consoleapp"

    files { "src/test/*.c" }

    links { "criterion", "fnv" }

    targetdir  "bin/%{cfg.buildcfg}/test"
    targetname "test_%{wks.name}"

  project "fnv"
    kind "staticlib"
    files { "deps/fnv-hash/hash_*.c" }

    links { "m" }

    targetdir "bin/%{cfg.buildcfg}/lib"

  project "clobber"
    kind "makefile"

    filter "system:not windows"
      cleancommands {
        "({RMDIR} bin obj *.make Makefile *.o -r 2>/dev/null; echo)"
      }

    filter "system:windows"
      cleancommands {
        "{DELETE} *.make Makefile *.o",
        "{RMDIR} bin obj"
      }
