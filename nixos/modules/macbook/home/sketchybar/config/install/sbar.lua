local sbarpath = "/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/"

package.cpath = package.cpath .. ";" .. sbarpath .. "?.so"

os.execute("(cd bridge && make)")
