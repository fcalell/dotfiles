local sbarpath = "/Users/" .. os.getenv("USER") .. "/.config/sketchybar-lua/"

package.cpath = package.cpath .. ";" .. sbarpath .. "?.so"

os.execute("(cd bridge && make)")
