-- what this module provides
local M = {}

local run_build = function(target)
  -- TODO: run a async build using podman....
  local ovs = require('overseer')

  local task = ovs.new_task({
    cmd = { 'podman' },
    args = {
      'exec',
      '-w',
      '/workspace',
      'bld_vscode',
      '/bin/bash',
      '-c',
      string.format(
        "source ./scripts/activate.sh >/dev/null && ./scripts/build/build_examples.py --log-level info --target '%s' build",
        target)
    },
    components = {
      -- {
      --   "on_output_quickfix",
      --   errorformat = vim.o.grepformat,
      --   open = not params.bang,
      --   open_height = 8,
      --   items_only = true,
      -- },
      -- {"on_complete_dispose", timeout=30}
      "default",
    }

  })
  task:start()

  ovs.open()
end

M.test = function()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local select_target = function(opts)
    opts = opts or {}
    pickers.new(opts, {
      prompt_title = "What to build",
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          run_build(action_state.get_selected_entry()[1])
        end)
        return true
      end,
      finder = finders.new_table {
        results = {
          "ameba-amebad-all-clusters",
          "android-arm64-chip-tool",
          "android-arm64-tv-casting-app",
          "android-arm-chip-tool",
          "android-x64-java-matter-controller",
          "bouffalolab-bl602-iot-matter-v1-light-115200-rpc",
          "efr32-brd4161a-light",
          "efr32-brd4161a-light-no-version",
          "efr32-brd4161a-light-rpc",
          "efr32-brd4161a-light-rpc-no-version",
          "efr32-brd4161a-lock-no-version",
          "efr32-brd4161a-lock-rpc",
          "efr32-brd4161a-lock-rpc-no-version",
          "efr32-brd4161a-lock-rpc-shell-enable_heap_monitoring",
          "efr32-brd4161a-unit-test",
          "efr32-brd4161a-window-covering",
          "efr32-brd4161a-unit-test",
          "esp32-devkitc-all-clusters",
          "esp32-devkitc-all-clusters-tracing",
          "esp32-m5stack-all-clusters",
          "esp32-m5stack-all-clusters-tracing",
          "esp32-m5stack-all-clusters-minimal",
          "esp32-m5stack-all-clusters-rpc-ipv6only",
          "esp32-devkitc-light-rpc",
          "esp32-m5stack-light",
          "esp32-m5stack-light-ipv6only",
          "esp32-m5stack-light-tracing",
          "imx-lighting-app",
          "infineon-psoc6-lock",
          "infineon-psoc6-light",
          "infineon-psoc6-all-clusters",
          "k32w-k32w0-lock-crypto-platform-low-power-nologs",
          "linux-arm64-chip-tool-clang",
          "linux-arm64-minmdns-clang",
          "linux-arm64-thermostat-clang",
          "linux-fake-tests",
          "linux-x64-address-resolve-tool",
          "linux-x64-address-resolve-tool-minmdns-verbose",
          "linux-x64-address-resolve-tool-platform-mdns-asan",
          "linux-x64-address-resolve-tool-platform-mdns-ipv6only",
          "linux-x64-all-clusters",
          "linux-x64-all-clusters-ipv6only-no-ble-no-wifi-tsan-clang-test",
          "linux-x64-all-clusters-no-ble-asan-libfuzzer-clang",
          "linux-x64-all-clusters-no-ble-ipv6only",
          "linux-x64-bridge",
          "linux-x64-bridge-ipv6only",
          "linux-x64-chip-cert",
          "linux-x64-chip-tool",
          "linux-x64-chip-tool-ipv6only",
          "linux-x64-contact-sensor",
          "linux-x64-dynamic-bridge-ipv6only",
          "linux-x64-efr32-test-runner",
          "linux-x64-java-matter-controller",
          "linux-x64-kotlin-matter-controller",
          "linux-x64-light-no-ble-with-ui",
          "linux-x64-light-no-ble-with-ui-pwtrace",
          "linux-x64-lock",
          "linux-x64-lock",
          "linux-x64-minmdns",
          "linux-x64-minmdns-asan",
          "linux-x64-minmdns-minmdns-verbose",
          "linux-x64-ota-provider",
          "linux-x64-ota-provider-no-ble-no-wifi",
          "linux-x64-python-bindings",
          "linux-x64-rpc-console",
          "linux-x64-tests",
          "linux-x64-tests-clang",
          "linux-x64-tests-clang-asan",
          "linux-x64-tests-clang-asan-libfuzzer",
          "linux-x64-tv-app-no-ble-tsan-clang",
          "mbed-cy8cproto_062_4343w-lock",
          "mbed-cy8cproto_062_4343w-light",
          "mbed-cy8cproto_062_4343w-all-clusters",
          "mw320-all-clusters-app",
          "nrf-nrf5340dk-all-clusters",
          "nrf-nrf5340dk-all-light",
          "nrf-nrf5340dk-all-lock",
          "nrf-nrf5340dk-all-pump",
          "nrf-nrf5340dk-all-pump-controller",
          "nrf-nrf5340dk-all-window-covering",
          "nrf-nrf5340dk-light",
          "nrf-nrf5340dk-light-rpc",
          "nrf-nrf5340dk-lock",
          "nrf-nrf5340dk-pump",
          "nrf-nrf5340dk-pump-controller",
          "nrf-nrf5340dk-window-covering",
          "nrf-native-posix-64-tests",
          "qpg-qpg6105-light",
          "qpg-qpg6105-lock",
          "qpg-qpg6105-thermostat",
          "stm32-stm32wb5mm-dk-light",
          "telink-tlsr9518adk80d-all-clusters",
          "telink-tlsr9518adk80d-light",
          "telink-tlsr9518adk80d-light-factory-data",
          "telink-tlsr9518adk80d-light-rpc",
          "telink-tlsr9518adk80d-lock-rpc",
          "telink-tlsr9518adk80d-resource-monitoring",
          "telink-tlsr9518adk80d-light-ota-rpc-4mb",
          "tizen-arm-chip-tool-ubsan",
          "tizen-arm-light",
          "tizen-arm-all-clusters",
          "ti-cc13x2x7_26x2x7-lighting",
          "ti-cc13x4_26x4-lock-mtd",
          "tizen-arm-chip-tool-ubsan",
          "tizen-arm-light",
        }
      },
      sorter = conf.generic_sorter(opts),
    }):find()
  end
  select_target()
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
  options = options or {}

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
