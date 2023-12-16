help(myModuleName())
local base = pathJoin(
	"/sw/contrib",
	string.gsub(myModuleName(), "/.*$", "-src"),
	string.gsub(myModuleName(), "^.*/", ""),
	myModuleVersion()
)
whatis("Name: " .. string.gsub(myModuleName(), "^.*/", ""))
whatis("Version: " .. myModuleVersion())