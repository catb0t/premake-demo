workspace "hello"
  configurations { "dbg", "dist" }
  language "C"

  SOURCEDIR = "src"

  -- clean everything up better than premake's normal 'make clean'
  cleancommands {
    "({RMDIR} bin obj *.make Makefile *.o -r 2>/dev/null; echo)"
  }

   -- make an executable
  project "prog"
    kind "ConsoleApp"

    files { "src/%{wks.name}.*" }

    links { "m", "pthread" }

    targetdir "bin/%{cfg.buildcfg}"

  -- make a lib
  project "hello"
    kind "StaticLib"

    libfiles = {}

    for dir in io.popen("find src/lib/ -maxdepth 1 -type d | tail -1"):lines()
    do
      table.insert(libfiles, path.join(dir, path.getbasename(dir) .. "common.c"))
    end

    files(libfiles)

    links { "m", "pthread" }

    targetdir "bin/%{cfg.buildcfg}/lib"

  -- make the tests
  project "test"
    kind "ConsoleApp"

    files { "src/test/*.c" }

    links { "criterion" }

    targetdir  "bin/%{cfg.buildcfg}/test"
    targetname "test_%{wks.name}"

