local M = {}

local get_project_root = function()
  return vim.fn.getcwd()
end

local get_clangd_file_path = function()
  return get_project_root() .. '/.clangd'
end

local get_out_dir_path = function()
  return get_project_root() .. '/out'
end

M.find_compilation_databases = function()
  local out_dir = get_out_dir_path()
  local files = vim.fn.globpath(out_dir, 'linux-x64-*/compile_commands.json', true, true)
  local results = {}
  for _, file in ipairs(files) do
    local dir = vim.fn.fnamemodify(file, ':h')
    -- Extract relative path from out_dir for clean display
    local rel_dir = dir:sub(#out_dir + 2)
    table.insert(results, {
      display = rel_dir,
      absolute_path = dir,
    })
  end
  return results
end

M.get_current_compilation_database = function()
  local clangd_path = get_clangd_file_path()
  local f = io.open(clangd_path, 'r')
  if not f then
    return nil
  end

  for line in f:lines() do
    local match = line:match("^%s*CompilationDatabase:%s*(.*)$")
    if match then
      f:close()
      -- Remove trailing inline comments if any
      match = match:gsub("%s*#.*$", "")
      -- Remove trailing slashes
      match = match:gsub("/+$", "")
      return match
    end
  end
  f:close()
  return nil
end

M.active_compilation_database_name = function()
  local current = M.get_current_compilation_database()
  if not current then
    return "None"
  end

  local out_dir = get_out_dir_path()
  -- Check if current path starts with out_dir
  if current:sub(1, #out_dir) == out_dir then
    local rel = current:sub(#out_dir + 2)
    if rel ~= "" then
      return rel
    end
  end

  -- Fallback to basename
  return vim.fn.fnamemodify(current, ':t')
end

M.set_compilation_database = function(new_path)
  local clangd_path = get_clangd_file_path()
  local f = io.open(clangd_path, 'r')
  local lines = {}
  local found_compile_flags = false
  local found_compilation_db = false

  if f then
    for line in f:lines() do
      table.insert(lines, line)
    end
    f:close()
  end

  local new_lines = {}
  for _, line in ipairs(lines) do
    if line:match("^CompileFlags:") then
      found_compile_flags = true
      table.insert(new_lines, line)
    elseif line:match("^%s*CompilationDatabase:") then
      found_compilation_db = true
      local indent = line:match("^%s*") or "  "
      table.insert(new_lines, indent .. "CompilationDatabase: " .. new_path)
    else
      table.insert(new_lines, line)
    end
  end

  if not found_compilation_db then
    if found_compile_flags then
      local insert_pos = 1
      for i, line in ipairs(new_lines) do
        if line:match("^CompileFlags:") then
          insert_pos = i + 1
          break
        end
      end
      table.insert(new_lines, insert_pos, "  CompilationDatabase: " .. new_path)
    else
      table.insert(new_lines, "CompileFlags:")
      table.insert(new_lines, "  CompilationDatabase: " .. new_path)
    end
  end

  local fw = io.open(clangd_path, 'w')
  if not fw then
    print("Failed to open " .. clangd_path .. " for writing")
    return
  end
  for _, line in ipairs(new_lines) do
    fw:write(line .. "\n")
  end
  fw:close()
  print("Updated .clangd CompilationDatabase to: " .. new_path)
end

M.select_compilation_database = function()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local dbs = M.find_compilation_databases()
  if #dbs == 0 then
    print("No compilation databases found in out/")
    return
  end

  pickers.new({}, {
    prompt_title = "Select Compilation Database",
    finder = finders.new_table {
      results = dbs,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.display,
          ordinal = entry.display,
        }
      end
    },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          M.set_compilation_database(selection.value.absolute_path)
        end
      end)
      return true
    end,
  }):find()
end

return M
