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

    -- all the subdirectories of src/lib (unix only)
    for dir in io.popen("find src/lib/ -maxdepth 1 -type d | tail -1"):lines()
    do
      -- create src/lib/f/fcommon.c from f
      table.insert(libfiles, path.join(dir, path.getbasename(dir) .. "common.c"))
    end

    -- src/lib/*/*common.c is what we care about
    files(libfiles)

    -- libraries upon which this relies
    links { "m", "pthread", "fnv" }

    -- where these files will go
    targetdir "bin/%{cfg.buildcfg}/lib"

  -- make the tests
  project "test"
    kind "consoleapp"

    files { "src/test/*.c" }

    links { "criterion", "fnv" }

    targetdir  "bin/%{cfg.buildcfg}/test"
    -- test_hello
    targetname "test_%{wks.name}"

  project "fnv"
    kind "staticlib"
    files { "deps/fnv-hash/hash_*.c" }

    links { "m" }

    targetdir "bin/%{cfg.buildcfg}/lib"

  project "clobber"
    kind "makefile"

    -- on windows, clean like this
    filter "system:not windows"
      cleancommands {
        "({RMDIR} bin obj *.make Makefile *.o -r 2>/dev/null; echo)"
      }

    -- otherwise, clean like this
    filter "system:windows"
      cleancommands {
        "{DELETE} *.make Makefile *.o",
        "{RMDIR} bin obj"
      }
