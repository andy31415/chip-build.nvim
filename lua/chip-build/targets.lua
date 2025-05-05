M = {}

CHIP_BUILD_TARGETS = [[
ameba-amebad-{all-clusters,all-clusters-minimal,light,light-switch,pigweed}
asr-{asr550x,asr582x,asr595x}-{all-clusters,all-clusters-minimal,bridge,dishwasher,light-switch,lighting,lock,ota-requestor,refrigerator,temperature-measurement,thermostat}[-factory][-no_logging][-ota][-rio][-rotating_id][-shell]
android-{androidstudio-arm,androidstudio-arm64,androidstudio-x64,androidstudio-x86,arm,arm64,x64,x86}-{chip-test,chip-tool,java-matter-controller,kotlin-matter-controller,tv-casting-app,tv-server,virtual-device-app}[-no-debug]
bouffalolab-{bl602-iot-matter-v1,bl602-night-light,bl602dk,bl616dk,bl704ldk,bl706-night-light,bl706dk,xt-zb6-devkit}-{contact-sensor,light}-{ethernet,thread,thread-ftd,thread-mtd,wifi}-{easyflash,littlefs}[-cdc][-coredump][-memmonitor][-mfd][-mot][-rotating_device_id][-rpc][-shell]
cc32xx-{air-purifier,lock}
ti-cc13x4_26x4-{lighting,lock,pump,pump-controller}[-ftd][-mtd]
cyw30739-{cyw30739b2_p5_evk_01,cyw30739b2_p5_evk_02,cyw30739b2_p5_evk_03,cyw930739m2evb_01,cyw930739m2evb_02}-{light,light-switch,lock,thermostat}
efr32-{brd2601b,brd2605a,brd2703a,brd2704b,brd4186a,brd4186c,brd4187a,brd4187c,brd4316a,brd4317a,brd4318a,brd4319a,brd4338a,brd4342a,brd4343a}-{air-quality-sensor-app,closure,light,lock,pump,switch,thermostat,unit-test,window-covering}[-additional-data-advertising][-heap-monitoring][-icd][-ipv4][-low-power][-no-logging][-no-openthread-cli][-no-version][-openthread-mtd][-rpc][-rs9116][-shell][-show-qr-code][-siwx917][-skip-rps-generation][-use-ot-coap-lib][-use-ot-lib][-wf200][-wifi][-with-ota-requestor]
esp32-{c3devkit,devkitc,m5stack,qemu}-{all-clusters,all-clusters-minimal,bridge,energy-gateway,energy-management,light,lock,ota-provider,ota-requestor,ota-requestor,shell,temperature-measurement,tests}[-ipv6only][-rpc][-tracing]
genio-lighting-app
linux-fake-tests[-asan][-boringssl][-clang][-coverage][-dmalloc][-libfuzzer][-mbedtls][-ossfuzz][-pw-fuzztest][-tsan][-ubsan]
linux-{arm64,x64}-{address-resolve-tool,air-purifier,air-quality-sensor,all-clusters,all-clusters-minimal,bridge,camera,camera-controller,chip-cert,chip-tool,contact-sensor,dishwasher,energy-gateway,energy-management,fabric-admin,fabric-bridge,fabric-sync,java-matter-controller,kotlin-matter-controller,light,light-data-model-no-unique-id,lit-icd,lock,microwave-oven,minmdns,network-manager,ota-provider,ota-requestor,python-bindings,refrigerator,rpc-console,rvc,shell,simulated-app1,simulated-app2,terms-and-conditions,tests,thermostat,tv-app,tv-casting-app,water-leak-detector}[-asan][-boringssl][-chip-casting-simplified][-clang][-coverage][-disable-dnssd-tests][-dmalloc][-enable-dnssd-tests][-evse-test-event][-googletest][-ipv6only][-libfuzzer][-libnl][-mbedtls][-minmdns-verbose][-nlfaultinject][-no-ble][-no-interactive][-no-shell][-no-thread][-no-wifi][-nodeps][-ossfuzz][-platform-mdns][-pw-fuzztest][-rpc][-same-event-loop][-terms-and-conditions][-test][-tsan][-ubsan][-with-ui]
linux-x64-efr32-test-runner[-clang]
imx-{all-clusters-app,all-clusters-minimal-app,chip-tool,lighting-app,ota-provider-app,thermostat}[-release]
infineon-psoc6-{all-clusters,all-clusters-minimal,light,lock}[-ota][-trustm][-updateimage]
nxp-{k32w0,k32w1,mcxw71,rt1060,rt1170,rw61x,rw61x_eth}-{freertos,zephyr}-{all-clusters,contact-sensor,laundry-washer,lighting,lock-app,thermostat}[-cmake][-dac-conversion][-ethernet][-evkc][-factory][-factory-build][-frdm][-fro32k][-iw416][-iwx12][-lit][-log-all][-log-error][-log-none][-log-progress][-low-power][-matter-shell][-ota][-rotating-id][-smu2][-sw-v2][-thread][-w8801][-wifi]
mbed-cy8cproto_062_4343w-{all-clusters,all-clusters-minimal,light,lock,ota-requestor,pigweed,shell}[-debug][-develop][-release]
mw320-all-clusters-app
nrf-{nrf52840dk,nrf52840dongle,nrf5340dk}-{all-clusters,all-clusters-minimal,light,light-switch,lock,pump,pump-controller,shell,window-covering}[-rpc]
nrf-native-sim-tests
nuttx-x64-light
qpg-qpg6105-{light,light-switch,lock,persistent-storage,shell,thermostat}[-updateimage]
realtek-rtl8777g-{all-clusters,light-switch,lighting,lock,ota-requestor,thermostat,window}
stm32-stm32wb5mm-dk-light
tizen-{arm,arm64}-{all-clusters,chip-tool,light,tests}[-asan][-coverage][-no-ble][-no-thread][-no-wifi][-ubsan][-with-ui]
telink-{tl3218x,tl3218x_retention,tl7218x,tl7218x_retention,tlsr9118bdk40d,tlsr9518adk80d,tlsr9528a,tlsr9528a_retention}-{air-quality-sensor,all-clusters,all-clusters-minimal,bridge,contact-sensor,light,light-switch,lock,ota-requestor,pump,pump-controller,shell,smoke-co-alarm,temperature-measurement,thermostat,window-covering}[-4mb][-compress-lzma][-dfu][-factory-data][-mars][-ota][-precompiled-ot][-rpc][-shell][-thread-analyzer][-usb]
openiotsdk-{lock,shell}[-mbedtls][-psa]
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

local all_targets = {}
for _, target in ipairs(M.split_lines(CHIP_BUILD_TARGETS)) do
	table.insert(all_targets, M.split_target_string(target))
end

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
