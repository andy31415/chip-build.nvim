-- what this module provides
local M = {}

local run_build = function(target)
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
      {
        "on_output_quickfix",
        open_height = 16,
        open = true,
        -- TODO: dir must exist AND path is off
        --       probably want a custom matcher here
        -- relative_file_root = string.format("/home/andrei/devel/connectedhomeip/out/%s", target)
        -- items_only = true,
      },
      "default",
    }
  })
  task:start()

  -- Can show ovs ... not sure if we want, however seems ok
  ovs.open({ direction = "right", enter = false })
end

-- TODO: I need a reasonable parser for this ...
local targets = {
  {
    prefixes = {
      'ameba-amebad',
      { 'all-clusters', 'all-clusters-minimal', 'light', 'light-switch', 'pigweed' }
    },
    suffixes = {}
  },
  {
    prefixes = {
      'asr',
      { 'asr582x',      'asr595x',              'asr550x' },
      { 'all-clusters', 'all-clusters-minimal', 'lighting', 'light-switch', 'lock', 'bridge', 'temperature-measurement', 'thermostat', 'ota-requestor', 'dishwasher', 'refrigerator' }
    },
    suffixes = { 'ota', 'shell', 'no_logging', 'factory', 'rotating_id', 'rio' }
  },
  {
    prefixes = {
      'android',
      { 'arm',       'arm64',     'x86',       'x64',            'androidstudio-arm',      'androidstudio-arm64',      'androidstudio-x86', 'androidstudio-x64' },
      { 'chip-tool', 'chip-test', 'tv-server', 'tv-casting-app', 'java-matter-controller', 'kotlin-matter-controller', 'virtual-device-app' }
    },
    suffixes = { 'no-debug' }
  },
  {
    prefixes = {
      'bouffalolab',
      { 'bl602-iot-matter-v1', 'bl602-night-light', 'xt-zb6-devkit', 'bl706-night-light', 'bl706dk-bl704ldk-light' }
    },
    suffixes = { 'shell', '115200', 'rpc', 'cdc', 'resetcnt', 'rotating_device_id', 'mfd', 'mfdtest', 'ethernet', 'wifi', 'thread', 'fp', 'memmonitor', 'mot' }
  },
  {
    prefixes = { 'cc32xx', { 'lock', 'air-purifier' } },
    suffixes = {}
  },
  {
    prefixes = {
      'efr32',
      { 'brd4161a',        'brd4187c', 'brd4186c',  'brd4163a', 'brd4164a', 'brd4166a',   'brd4170a', 'brd4186a', 'brd4187a', 'brd4304a', 'brd4338a' },
      { 'window-covering', 'switch',   'unit-test', 'light',    'lock',     'thermostat', 'pump' }
    },
    suffixes = { 'rpc', 'with-ota-requestor', 'icd', 'low-power', 'shell', 'no_logging', 'openthread_mtd', 'enable_heap_monitoring', 'no_openthread_cli', 'show_qr_code', 'wifi', 'rs911x', 'wf200', 'wifi_ipv4', '917_soc', 'additional_data_advertising', 'use_ot_lib', 'use_ot_coap_lib', 'no-version', 'skip_rps_generation' },
  },
  {
    prefixes = { 'esp32', { 'm5stack', 'c3devkit', 'devkitc', 'qemu' }, { 'all-clusters', 'all-clusters-minimal', 'energy-management', 'ota-provider', 'ota-requestor', 'shell', 'light', 'lock', 'bridge', 'temperature-measurement', 'ota-requestor', 'tests' } },
    suffixes = { 'rpc', 'ipv6only', 'tracing' }
  },
  {
    prefixes = { 'linux-fake-tests' },
    suffixes = { 'mbedtls', 'boringssl', 'asan', 'tsan', 'ubsan', 'libfuzzer', 'ossfuzz', 'coverage', 'dmalloc', 'clang' },
  },
  {
    prefixes = {
      'linux',
      { 'x64',         'arm64' },
      { 'rpc-console', 'all-clusters', 'all-clusters-minimal', 'chip-tool', 'thermostat', 'java-matter-controller', 'kotlin-matter-controller', 'minmdns', 'light', 'lock', 'shell', 'ota-provider', 'ota-requestor', 'simulated-app1', 'simulated-app2', 'python-bindings', 'tv-app', 'tv-casting-app', 'bridge', 'tests', 'chip-cert', 'address-resolve-tool', 'contact-sensor', 'dishwasher', 'microwave-oven', 'refrigerator', 'rvc', 'air-purifier', 'lit-icd', 'air-quality-sensor', 'network-manager', 'energy-management' }
    },
    suffixes = { 'nodeps', 'nlfaultinject', 'platform-mdns', 'minmdns-verbose', 'libnl', 'same-event-loop', 'no-interactive', 'ipv6only', 'no-ble', 'no-wifi', 'no-thread', 'mbedtls', 'boringssl', 'asan', 'tsan', 'ubsan', 'libfuzzer', 'ossfuzz', 'coverage', 'dmalloc', 'clang', 'test', 'rpc', 'with-ui', 'evse-test-event' }
  },
  {
    prefixes = {
      'nrf',
      { 'nrf5340dk',    'nrf52840dk',           'nrf52840dongle' },
      { 'all-clusters', 'all-clusters-minimal', 'lock',          'light', 'light-switch', 'shell', 'pump', 'pump-controller', 'window-covering' }
    },
    suffixes = { 'rpc' },
  },
}

local next_component_choices = function(components)
  -- Returns the "NEXT" expansion for a given list of components
  -- E.g. top level {} results in all prefixes
  -- and then something like `{'linux', 'x64'}` returns the next expansion from
  -- the path `linux-x64`
  --
  -- RETURNS:  next_components, can_be_final
  if #components == 0 then
    -- Top-level components
    local result = {}
    for i = 1, #targets, 1 do
      table.insert(result, targets[i].prefixes[1])
    end
    return result, false
  end

  -- not a top level table, find the right sub-table based on the first component
  local expansion = nil
  for i = 1, #targets, 1 do
    if targets[i].prefixes[1] == components[1] then
      expansion = targets[i]
      break
    end
  end

  if expansion == nil then
    -- illegal
    return nil
  end

  if #(expansion.prefixes) > #components then
    -- we can return an expansion from components
    local final = (#components + 1 == #(expansion.prefixes))
    if type(expansion.prefixes[#components + 1]) == 'table' then
      return expansion.prefixes[#components + 1], final
    else
      return { expansion.prefixes[#components + 1] }, final
    end
  end

  local existing = {}
  for i = #(expansion.prefixes), #components, 1 do
    existing[components[i]] = true
  end

  local result = {}
  if expansion.suffixes then
    for _, v in ipairs(expansion.suffixes) do
      if not existing[v] then
        table.insert(result, v)
      end
    end
    table.sort(result)
  end
  return result, true
end

M.build = function()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  function ChipBuildSelectTarget(components, opts)
    opts = opts or {}
    local next_choices, final = next_component_choices(components)

    local ui_choices = {}
    if opts.final or false then
      table.insert(ui_choices, 'DONE')
    end

    if next_choices then
      for _, v in ipairs(next_choices) do
        table.insert(ui_choices, v)
      end
    end

    pickers.new(opts, {
      prompt_title = "Pick component",
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selected = action_state.get_selected_entry()
          if not selected then
            print("Selection cancelled")
            return
          end

          local choice = selected[1]
          if choice == 'DONE' then
            local target_name = components[1]
            for i = 2, #components, 1 do
              target_name = target_name .. "-" .. components[i]
            end
            run_build(target_name)
            return
          end
          table.insert(components, choice)
          ChipBuildSelectTarget(components, {
            final = final,
          })
          -- run_build(action_state.get_selected_entry()[1])
        end)
        return true
      end,
      finder = finders.new_table {
        results = ui_choices
      },
      sorter = conf.generic_sorter(opts),
    }):find()
  end

  ChipBuildSelectTarget({})
end

--
M.devel_reset = function()
  if package.loaded["chip-build"] then
    print("Mark unloaded")
    package.loaded["chip-build"] = nil
  end
  require('chip-build').setup({ development = true })
  print("Reloaded with development enabled")
end

M.setup = function(options)
  options = options or {}

  vim.api.nvim_create_user_command("ChipBuild", function(opts)
    local cb = require('chip-build')
    local cmd = opts.args
    if cmd == "build" then
      cb.build()
    elseif cmd == "devel_reset" then
      cb.devel_reset()
    else
      print(string.format("Unknown chip-build command: %s", cmd))
    end
  end, {
    nargs = 1
  })


  vim.api.nvim_set_keymap('n', '<leader>obb', "<CMD>ChipBuild build<CR>", { noremap = true })
  if options.development or false then
    vim.api.nvim_set_keymap('n', '<leader>obr', "<CMD>ChipBuild devel_reset<CR>", { noremap = true })
    -- run for testing of development
    vim.api.nvim_set_keymap('n', '<leader>obt', "<CMD>source lua/chip-build/init.lua<CR>", { noremap = true })
  end
end

return M
