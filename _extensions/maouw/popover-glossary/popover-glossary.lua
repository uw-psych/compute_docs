-- popover-glossary.lua
-- Author: Lisa DeBruine (original glossary.lua)
-- Author: Altan Orhon (additions for popover-glossary.lua)
-- Global glossary def
globalGlossaryDefList = {}

-- Helper Functions
local function addHTMLDeps()
  -- add the HTML requirements for the popover glossary
  quarto.doc.add_html_dependency({
    name = "popover-glossary",
    stylesheets = { "popover-glossary.css" },
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

---Merge user provided options with defaults
---@param userOptions table
local function mergeOptions(userOptions, meta)
  local defaultOptions = {
    path = "glossary.yml",
    add_to_deflist = true,
  }

  -- override with meta values first
  if meta.popover_glossary ~= nil then
    for k, v in pairs(meta.popover_glossary) do
      local value = pandoc.utils.stringify(v)
      if value == "true" then
        defaultOptions[k] = true
      elseif value == "false" then
        defaultOptions[k] = false
      else
        defaultOptions[k] = value
      end
    end
  end

  -- then override with function keyword values
  if userOptions ~= nil then
    for k, v in pairs(userOptions) do
      local value = pandoc.utils.stringify(v)
      if value == "true" then
        defaultOptions[k] = true
      elseif value == "false" then
        defaultOptions[k] = false
      else
        defaultOptions[k] = value
      end
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

      return pandoc.RawInline("html", gdl)
    end

    -- or set up in-text term
    local options = mergeOptions(kwargs, meta)
    local term = string.lower(string.gsub(pandoc.utils.stringify(args[1]), "[|].*", ""))
    local display = string.gsub(pandoc.utils.stringify(args[1]), ".*[|]", "")

    -- get definition
    local def = ""
    if kwExists(kwargs, "def") then
      def = pandoc.write(pandoc.Pandoc(kwargs.def), "html")
    else
      local metafile = io.open(options.path, "r")
      if metafile == nil then
        quarto.log.warning("Glossary file not found: " .. options.path)
        return pandoc.Null()
      end
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
    local def_div = "<div class='glossary-def' data-glossary-term='"
      .. term
      .. "' role='tooltip'>"
      .. pandoc.RawBlock("html", def).text
      .. "</div>"
    local def_div_base64 = quarto.base64.encode(def_div)
    --    glossText = "<span class='glossary-ref'><span class='glossary-def' role='tooltip'>" ..
    --        pandoc.RawBlock("html", def).text ..
    --       "</span><a class='glossary-link' href='javascript:void(0);'>" .. display .. "</a></span>"
    glossText = "<a class='glossary-ref' data-glossary-term='"
      .. term
      .. "' data-glossary-def-base64='"
      .. def_div_base64
      .. "' href='javascript:void(0);'>"
      .. display
      .. "</a>"
    return pandoc.RawInline("html", glossText)
  end,
}
