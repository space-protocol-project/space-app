-- Численный профиль Space: inline-замыкания и collection if/for.
local analyzer_root, parser_root, rules_path, listing = unpack(_G.arg)
vim.opt.runtimepath:append(analyzer_root)
vim.opt.runtimepath:append(parser_root)
package.path = analyzer_root .. '/lua/?.lua;' .. analyzer_root .. '/lua/?/init.lua;' .. package.path
require('cyclomatic.config').setup({ nested_functions = 'inline' })
vim.treesitter.query.set('dart', 'cyclomatic', table.concat(vim.fn.readfile(rules_path), '\n'))
local analyzer = require('cyclomatic.analyzer')
local entries, files, errors = {}, {}, {}

local function parse_errors(node, path)
  if node:type() == 'ERROR' or node:missing() then
    local row, column = node:start()
    errors[#errors + 1] = { path = path, line = row + 1, column = column + 1, kind = node:type() }
  end
  for child in node:iter_children() do parse_errors(child, path) end
end

for path in io.lines(listing) do
  local source = table.concat(vim.fn.readfile(path), '\n')
  local tree = vim.treesitter.get_string_parser(source, 'dart'):parse()[1]:root()
  if tree:has_error() then parse_errors(tree, path) end
  local result, problem = analyzer.analyze_string(source, 'dart')
  assert(result, problem)
  files[#files + 1] = { path = path, functions = #result.entries }
  for _, entry in ipairs(result.entries) do
    entries[#entries + 1] = {
      path = path, line = entry.row + 1, name = entry.name,
      cognitive = entry.cognitive, cyclomatic = entry.cyclomatic,
    }
  end
end
io.stdout:write(vim.json.encode({ files = files, entries = entries, errors = errors }))
