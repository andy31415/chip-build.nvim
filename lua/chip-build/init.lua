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

  vim.api.nvim_create_user_command("ChipBuild", function(opts)
    local cb = require('chip-build')
    local cmd = opts.args
    if cmd == "test" then
      cb.test()
    elseif cmd == "devel_reset" then
      cb.devel_reset()
    else
      print(string.format("Unknown chip-build command: %s", cmd))
    end
  end, {
    nargs = 1
  })


  vim.api.nvim_set_keymap('n', '<Space>tt', "<CMD>ChipBuild test<CR>", { noremap = true })
  if options.development or false then
    vim.api.nvim_set_keymap('n', '<Space>tr', "<CMD>ChipBuild devel_reset<CR>", { noremap = true })
  end
end

return M
