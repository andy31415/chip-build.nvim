M = {}

CHIP_BUILD_TARGETS = [[
ameba-amebad-{all-clusters,all-clusters-minimal,light,light-switch}
asr-{asr550x,asr582x,asr595x}-{all-clusters,all-clusters-minimal,bridge,dishwasher,light-switch,lighting,lock,ota-requestor,refrigerator,temperature-measurement,thermostat}[-factory][-no_logging][-ota][-rio][-rotating_id][-shell]
android-{androidstudio-arm,androidstudio-arm64,androidstudio-x64,androidstudio-x86,arm,arm64,x64,x86}-{chip-test,chip-tool,tv-casting-app,tv-server,virtual-device-app}[-size-optimized]
bouffalolab-{bl602-night-light,bl602dk,bl616cldk,bl616dk,bl704ldk,bl706-night-light,bl706dk}-{contact-sensor,light}-{ethernet,thread,thread-ftd,thread-mtd,wifi}-{easyflash,littlefs}[-cdc][-coredump][-memmonitor][-mfd][-rotating_device_id][-rpc][-shell]
cc32xx-{air-purifier,lock}
ti-cc13x4_26x4-{lighting,lock,pump,pump-controller}[-ftd][-mtd]
cyw30739-{cyw30739b2_p5_evk_01,cyw30739b2_p5_evk_02,cyw30739b2_p5_evk_03,cyw930739m2evb_01,cyw930739m2evb_02}-{light,light-switch,lock,thermostat}
efr32-{brd2605a,brd2703a,brd2704b,brd2708a,brd2911a,brd4186c,brd4187c,brd4316a,brd4317a,brd4318a,brd4319a,brd4338a,brd4342a,brd4343a}-{air-quality-sensor-app,all-devices,all-devices-aggregator,all-devices-air-purifier,all-devices-ambient-context-sensor,all-devices-bridged-node,all-devices-chime,all-devices-color-temperature-light,all-devices-contact-sensor,all-devices-cooktop,all-devices-device-energy-management,all-devices-dimmable-light,all-devices-dimmable-plug-in-unit,all-devices-dishwasher,all-devices-electrical-sensor,all-devices-extended-color-light,all-devices-extractor-hood,all-devices-fan,all-devices-flow-sensor,all-devices-generic-switch,all-devices-humidity-conditioner,all-devices-humidity-sensor,all-devices-laundry-dryer,all-devices-laundry-washer,all-devices-light-sensor,all-devices-microwave-oven,all-devices-mode-select,all-devices-mounted-dimmable-load-control,all-devices-mounted-on-off-control,all-devices-occupancy-sensor,all-devices-on-off-light,all-devices-on-off-light-switch,all-devices-on-off-plug-in-unit,all-devices-oven,all-devices-power-source,all-devices-pressure-sensor,all-devices-proximity-ranger,all-devices-rain-sensor,all-devices-refrigerator,all-devices-robotic-vacuum-cleaner,all-devices-room-air-conditioner,all-devices-soil-sensor,all-devices-speaker,all-devices-temperature-sensor,all-devices-thread-border-router,all-devices-water-freeze-detector,all-devices-water-leak-detector,all-devices-water-valve,closure,evse,light,lock,pump,smoke-co-alarm,switch,thermostat,unit-test,water-heater,window-covering}[-additional-data-advertising][-heap-monitoring][-icd][-ipv4][-low-power][-no-logging][-no-openthread-cli][-openthread-mtd][-rpc][-shell][-show-qr-code][-siwx917][-skip-rps-generation][-uart-log][-use-ot-coap-lib][-use-ot-lib][-wifi][-with-ota-requestor]
esp32-{c3devkit,devkitc,m5stack,m5stack-cores3,p4functionev,qemu}-{all-clusters,all-clusters-minimal,all-devices,all-devices-aggregator,all-devices-air-purifier,all-devices-ambient-context-sensor,all-devices-bridged-node,all-devices-chime,all-devices-color-temperature-light,all-devices-contact-sensor,all-devices-cooktop,all-devices-device-energy-management,all-devices-dimmable-light,all-devices-dimmable-plug-in-unit,all-devices-dishwasher,all-devices-electrical-sensor,all-devices-extended-color-light,all-devices-extractor-hood,all-devices-fan,all-devices-flow-sensor,all-devices-generic-switch,all-devices-humidity-conditioner,all-devices-humidity-sensor,all-devices-laundry-dryer,all-devices-laundry-washer,all-devices-light-sensor,all-devices-microwave-oven,all-devices-mode-select,all-devices-mounted-dimmable-load-control,all-devices-mounted-on-off-control,all-devices-occupancy-sensor,all-devices-on-off-light,all-devices-on-off-light-switch,all-devices-on-off-plug-in-unit,all-devices-oven,all-devices-power-source,all-devices-pressure-sensor,all-devices-proximity-ranger,all-devices-rain-sensor,all-devices-refrigerator,all-devices-robotic-vacuum-cleaner,all-devices-room-air-conditioner,all-devices-soil-sensor,all-devices-speaker,all-devices-temperature-sensor,all-devices-thread-border-router,all-devices-water-freeze-detector,all-devices-water-leak-detector,all-devices-water-valve,bridge,energy-gateway,evse,light,lock,ota-provider,ota-requestor,shell,temperature-measurement,tests,water-heater}[-ipv6only][-rpc][-tracing]
genio-lighting-app
linux-fake-tests[-asan][-boringssl][-clang][-coverage][-dmalloc][-libfuzzer][-mbedtls][-ossfuzz][-psa][-pw-fuzztest][-tsan][-ubsan]
linux-{arm,arm64,x64}-{address-resolve-tool,air-purifier,air-quality-sensor,all-clusters,all-clusters-minimal,all-devices,all-devices-aggregator,all-devices-air-purifier,all-devices-ambient-context-sensor,all-devices-bridged-node,all-devices-chime,all-devices-color-temperature-light,all-devices-contact-sensor,all-devices-cooktop,all-devices-device-energy-management,all-devices-dimmable-light,all-devices-dimmable-plug-in-unit,all-devices-dishwasher,all-devices-electrical-sensor,all-devices-extended-color-light,all-devices-extractor-hood,all-devices-fan,all-devices-flow-sensor,all-devices-generic-switch,all-devices-humidity-conditioner,all-devices-humidity-sensor,all-devices-laundry-dryer,all-devices-laundry-washer,all-devices-light-sensor,all-devices-microwave-oven,all-devices-mode-select,all-devices-mounted-dimmable-load-control,all-devices-mounted-on-off-control,all-devices-occupancy-sensor,all-devices-on-off-light,all-devices-on-off-light-switch,all-devices-on-off-plug-in-unit,all-devices-oven,all-devices-power-source,all-devices-pressure-sensor,all-devices-proximity-ranger,all-devices-rain-sensor,all-devices-refrigerator,all-devices-robotic-vacuum-cleaner,all-devices-room-air-conditioner,all-devices-soil-sensor,all-devices-speaker,all-devices-temperature-sensor,all-devices-thread-border-router,all-devices-water-freeze-detector,all-devices-water-leak-detector,all-devices-water-valve,bridge,camera,camera-controller,chip-cert,chip-tool,closure,contact-sensor,dishwasher,electrical-protection,energy-gateway,evse,fabric-admin,fabric-bridge,fabric-sync,java-matter-controller,jf-admin-app,jf-control-app,kotlin-matter-controller,light,light-data-model-no-unique-id,lit-icd,lock,microwave-oven,minmdns,network-manager,ota-provider,ota-requestor,python-bindings,refrigerator,rpc-console,rvc,shell,simulated-app1,simulated-app2,terms-and-conditions,tests,thermostat,tv-app,tv-casting-app,water-heater,water-leak-detector}[-asan][-boringssl][-chip-casting-simplified][-clang][-coverage][-disable-dnssd-tests][-dmalloc][-enable-dnssd-tests][-endpoint-unique-id][-evse-test-event][-googletest][-ipv6only][-libfuzzer][-libnl][-mbedtls][-minmdns-verbose][-msan][-nfc-commission][-nlfaultinject][-no-ble][-no-groupcast][-no-interactive][-no-shell][-no-thread][-no-wifi][-no-wifipaf][-nodeps][-openthread-endpoint][-ossfuzz][-platform-mdns][-psa][-pw-fuzztest][-rpc][-same-event-loop][-terms-and-conditions][-test][-tsan][-ubsan][-unified][-webrtc][-with-ui]
linux-x64-efr32-test-runner[-clang]
imx-{all-clusters-app,all-clusters-minimal-app,chip-tool,lighting-app,ota-provider-app,thermostat}[-ele][-release][-trusty]
infineon-psoc6-{all-clusters,all-clusters-minimal,light,lock}[-ota][-trustm][-updateimage]
nxp-{mcxw72,rt1060,rt1170,rw61x}-{freertos,zephyr}-{all-clusters,contact-sensor,laundry-washer,lighting,lock-app,thermostat,unit-test}[-dac-conversion][-ethernet][-evkc][-factory][-factory-build][-frdm][-gn][-iw416][-iw610][-iwx12][-lit][-log-all][-log-error][-log-none][-log-progress][-low-power][-matter-shell][-mtd][-no-ble][-ota][-rotating-id][-se05x][-sw-v2][-thread][-w8801][-wifi]
nrf-{nrf52840dk,nrf52840dongle,nrf5340dk}-{all-clusters,all-clusters-minimal,light,light-switch,lock,pump,pump-controller,shell,window-covering}[-rpc]
nrf-native-sim-tests
nuttx-x64-light
qpg-qpg6200-{light,light-switch,lock,persistent-storage,shell,thermostat}[-updateimage]
realtek-{rtl8777g,rtl87x2g}-{all-clusters,light-switch,lighting,lock,ota-requestor,thermostat,window}
stm32-{stm32wb5mm-dk,stm32wba65i-dk1}-light
tizen-{arm,arm64}-{all-clusters,chip-tool,light,tests}[-asan][-coverage][-no-ble][-no-thread][-no-wifi][-ubsan][-with-ui]
telink-{tl3228x,tl3228x_retention,tl3238x,tl3238x_retention,tl5218x,tl5218x_retention,tl7218x,tl7218x_ml7g,tl7218x_ml7m,tl7218x_retention,tlsr9118bdk40d,tlsr9518adk80d,tlsr9528a,tlsr9528a_retention}-{air-quality-sensor,all-clusters,all-clusters-minimal,all-devices,all-devices-aggregator,all-devices-air-purifier,all-devices-ambient-context-sensor,all-devices-bridged-node,all-devices-chime,all-devices-color-temperature-light,all-devices-contact-sensor,all-devices-cooktop,all-devices-device-energy-management,all-devices-dimmable-light,all-devices-dimmable-plug-in-unit,all-devices-dishwasher,all-devices-electrical-sensor,all-devices-extended-color-light,all-devices-extractor-hood,all-devices-fan,all-devices-flow-sensor,all-devices-generic-switch,all-devices-humidity-conditioner,all-devices-humidity-sensor,all-devices-laundry-dryer,all-devices-laundry-washer,all-devices-light-sensor,all-devices-microwave-oven,all-devices-mode-select,all-devices-mounted-dimmable-load-control,all-devices-mounted-on-off-control,all-devices-occupancy-sensor,all-devices-on-off-light,all-devices-on-off-light-switch,all-devices-on-off-plug-in-unit,all-devices-oven,all-devices-power-source,all-devices-pressure-sensor,all-devices-proximity-ranger,all-devices-rain-sensor,all-devices-refrigerator,all-devices-robotic-vacuum-cleaner,all-devices-room-air-conditioner,all-devices-soil-sensor,all-devices-speaker,all-devices-temperature-sensor,all-devices-thread-border-router,all-devices-water-freeze-detector,all-devices-water-leak-detector,all-devices-water-valve,bridge,contact-sensor,light,light-switch,lock,ota-requestor,pump,pump-controller,shell,smoke-co-alarm,temperature-measurement,thermostat,window-covering}[-4mb][-compress-lzma][-concurrent-connection][-dfu-smp][-factory-data][-log-all][-log-error][-log-none][-log-progress][-mars][-nfc-payload][-ota][-precompiled-ot][-rpc][-shell][-tflm][-thread-analyzer][-usb]
]]

-- Returns the split of {prefixes, suffixes}
-- of a given string, like the output of `build_examples.py targets`
-- in the CHIP SDK
M.split_target_string = function(s)
	local part_name = function(part)
		if part == nil then
			return nil
		end
		local result, _ = part:gsub("-$", "")
		return result
	end

	local result = {
		prefixes = {},
		suffixes = {},
	}

	-- General syntax of things:
	--   (<entry>)*(<suffix>)*
	--   where:
	--     - entry is `single-value` OR `{value1,value2,value3}`
	--     - suffix is ALWAYS `[value]`

	-- remove prefixes
	while s:len() > 0 and s:sub(1, 1) ~= "[" do
		while s:sub(1, 1) == "-" do
			s = s:sub(2)
		end

		if s:sub(1, 1) == "{" then
			s = s:sub(2)
			local group_end = s:find("}")
			local group = s:sub(1, group_end - 1)
			s = s:sub(group_end + 1)

			table.insert(result.prefixes, {})
			-- group is comma-separated:
			local comma_pos = group:find(",")
			while comma_pos ~= nil do
				table.insert(result.prefixes[#result.prefixes], group:sub(1, comma_pos - 1))

				group = group:sub(comma_pos + 1)
				comma_pos = group:find(",")
			end
			table.insert(result.prefixes[#result.prefixes], group)
		else
			local group_end = s:find("{")
			if group_end == nil then
				group_end = s:find("%[")
			end
			if group_end == nil then
				group_end = s:len() + 1
			end
			local group = s:sub(1, group_end - 1)
			table.insert(result.prefixes, part_name(group))
			s = s:sub(group_end)
		end
	end

	--finally only "[-a][-b]" remain
	while s:sub(1, 2) == "[-" do
		local item_end = s:find("]")
		table.insert(result.suffixes, s:sub(3, item_end - 1))
		s = s:sub(item_end + 1)
	end

	if s ~= "" then
		print(string.format("UNEXPECTED CHIP BUILD PARSE SUFFIX: '%s'", s))
	end

	return result
end

M.split_lines = function(txt)
	local result = {}
	for l in txt:gmatch("([^\n]*)\n?") do
		l = l:gsub("^%s+", ""):gsub("%s+$", "")
		if l ~= "" then
			table.insert(result, l)
		end
	end
	return result
end

local get_cache_path = function()
	if vim and vim.fn and vim.fn.stdpath then
		return vim.fn.stdpath("cache") .. "/chip-build-targets.txt"
	end
	return nil
end

local load_cached_targets_string = function()
	local cache_path = get_cache_path()
	if not cache_path then
		return nil
	end
	local f = io.open(cache_path, "r")
	if f == nil then
		return nil
	end
	local content = f:read("*a")
	f:close()
	return content
end

M.get_targets_string = function()
	local cached = load_cached_targets_string()
	if cached and cached ~= "" then
		return cached
	end
	return CHIP_BUILD_TARGETS
end

local all_targets = {}

M.reload_targets = function()
	all_targets = {}
	for _, target in ipairs(M.split_lines(M.get_targets_string())) do
		table.insert(all_targets, M.split_target_string(target))
	end
end

M.update_targets_cache = function(content)
	local cache_path = get_cache_path()
	if not cache_path then
		return false, "No cache path available"
	end
	local f = io.open(cache_path, "w")
	if f == nil then
		return false, string.format("Failed to write to %s", cache_path)
	end
	f:write(content)
	f:close()
	M.reload_targets()
	return true
end

M.reload_targets()

M.next_component_choices = function(components, opts)
	opts = opts or {}
	local targets = opts.targets or all_targets
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

	if #expansion.prefixes > #components then
		-- we can return an expansion from components
		local final = (#components + 1 == #expansion.prefixes)
		if type(expansion.prefixes[#components + 1]) == "table" then
			return expansion.prefixes[#components + 1], final
		else
			return { expansion.prefixes[#components + 1] }, final
		end
	end

	local existing = {}
	for i = #expansion.prefixes, #components, 1 do
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

return M
