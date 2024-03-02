-- what this module provides
local M = {}

M.test = function()
  print("Test that it works")
end

--
M.devel_reset = function()
  if package.loaded["chip-build"] then
    print("Mark unloaded")
    package.loaded["chip-build"] = nil
  end
  require('chip-build').setup({ development = true })
  print("Reloaded")
end


M.setup = function(options)
  if not options then
    options = {}
  end
  vim.api.nvim_set_keymap('n', '<Space>tt', "<CMD>lua require('chip-build').test()<CR>", { noremap = true })
  if options.development or false then
    vim.api.nvim_set_keymap('n', '<Space>tr',  "<CMD>lua require('chip-build').devel_reset()<CR>", { noremap = true })
  end
end

return M
