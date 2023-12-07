-- popover-glossary.lua
-- Author: Lisa DeBruine
-- Author: Altan Orhon

-- Global glossary deflist
globalGlossaryDefList = {}

-- Helper Functions

local function addHTMLDeps()
  -- add the HTML requirements for the library used
  quarto.doc.add_html_dependency({
    name = 'popover-glossary',
    stylesheets = { 'popover-glossary.css' }
  })

  quarto.doc.include_file("after-body", "popover-glossary.html")
end

local function kwExists(kwargs, keyword)
  for key, value in pairs(kwargs) do
    if key == keyword then
      return true
    end
  end
  return false
end

local function read_metadata_file(fname)
  local metafile = io.open(fname, 'r')
  local content = metafile:read("*a")
  metafile:close()
  local metadata = pandoc.read(content, "markdown").meta
  return metadata
end

local function readGlossary(path)
  local f = io.open(path, "r")
  if not f then
    io.stderr:write("Cannot open file " .. path)
  else
    local lines = f:read("*all")
    f:close()
    return (lines)
  end
end

---Merge user provided options with defaults
---@param userOptions table
local function mergeOptions(userOptions, meta)
  local defaultOptions = {
    path = "glossary.yml",
    add_to_deflist = true
  }

  -- override with meta values first
  if meta.popover_glossary ~= nil then
    for k, v in pairs(meta.popover_glossary) do
      local value = pandoc.utils.stringify(v)
      if value == 'true' then value = true end
      if value == 'false' then value = false end
      defaultOptions[k] = value
    end
  end

  -- then override with function keyword values
  if userOptions ~= nil then
    for k, v in pairs(userOptions) do
      local value = pandoc.utils.stringify(v)
      if value == 'true' then value = true end
      if value == 'false' then value = false end
      defaultOptions[k] = value
    end
  end

  return defaultOptions
end


-- Main Glossary Function Shortcode

return {

  ["term"] = function(args, kwargs, meta)
    -- this will only run for HTML documents
    if not quarto.doc.isFormat("html:js") then
      return pandoc.Null()
    end

    addHTMLDeps()

    -- create glossary deflist
    if kwExists(kwargs, "deflist") then
      local gdl = "<dl class='glossary_dl'>\n"
      local sortedKeys = {}

      -- Extract keys from the table and store them in the 'sortedKeys' array
      for key, _ in pairs(globalGlossaryDefList) do
        table.insert(sortedKeys, key)
      end

      -- Sort the keys alphabetically
      table.sort(sortedKeys)

      for _, key in ipairs(sortedKeys) do
        gdl = gdl .. "<dt>" .. key .. "</dt>\n"
        gdl = gdl .. "<dd>" .. globalGlossaryDefList[key] .. "</dd>\n"
      end
      gdl = gdl .. "</dl>"

      return pandoc.RawInline('html', gdl)
    end

    -- or set up in-text term
    local options = mergeOptions(kwargs, meta)

    local display = pandoc.utils.stringify(args[1])
    local term = string.lower(display)

    if kwExists(kwargs, "display") then
      display = pandoc.utils.stringify(kwargs.display)
    end

    -- get definition
    local def = ""
    if kwExists(kwargs, "def") then
      def = pandoc.write(pandoc.Pandoc(kwargs.def), "html")
    else
      local metafile = io.open(options.path, 'r')
      local content = "---\n" .. metafile:read("*a") .. "\n---\n"
      metafile:close()
      local glossary = pandoc.read(content, "markdown").meta
      for key, value in pairs(glossary) do
        glossary[string.lower(key)] = value
      end
      -- quarto.log.output()
      if kwExists(glossary, term) then
        def = pandoc.write(pandoc.Pandoc(glossary[term]), "html")
      end
    end

    -- add to global table
    if options.add_to_deflist then
      globalGlossaryDefList[term] = def
    end


    glossText = "<button class='glossary-ref'><div class='glossary-def' role='tooltip'>" ..
        pandoc.RawInline("html", def).text ..
        "</div><a class='glossary-link' href='javascript:void(0);'>" .. display .. "</a></button>"
    return pandoc.RawInline("html", glossText)
  end

}
