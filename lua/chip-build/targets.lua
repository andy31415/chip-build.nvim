M = {}

CHIP_BUILD_TARGETS = [[
ameba-amebad-{all-clusters,all-clusters-minimal,light,light-switch,pigweed}
asr-{asr582x,asr595x,asr550x}-{all-clusters,all-clusters-minimal,lighting,light-switch,lock,bridge,temperature-measurement,thermostat,ota-requestor,dishwasher,refrigerator}[-ota][-shell][-no_logging][-factory][-rotating_id][-rio]
android-{arm,arm64,x86,x64,androidstudio-arm,androidstudio-arm64,androidstudio-x86,androidstudio-x64}-{chip-tool,chip-test,tv-server,tv-casting-app,java-matter-controller,kotlin-matter-controller,virtual-device-app}[-no-debug]
bouffalolab-{bl602dk,bl616dk,bl704ldk,bl706dk,bl602-night-light,bl706-night-light,bl602-iot-matter-v1,xt-zb6-devkit}-{light,contact-sensor}-{ethernet,wifi,thread,thread-ftd,thread-mtd}-{easyflash,littlefs}[-shell][-mfd][-rotating_device_id][-rpc][-cdc][-mot][-memmonitor][-coredump]
cc32xx-{lock,air-purifier}
ti-cc13x4_26x4-{lighting,lock,pump,pump-controller}[-mtd][-ftd]
cyw30739-{cyw30739b2_p5_evk_01,cyw30739b2_p5_evk_02,cyw30739b2_p5_evk_03,cyw930739m2evb_01,cyw930739m2evb_02}-{light,light-switch,lock,thermostat}
efr32-{brd2704b,brd4316a,brd4317a,brd4318a,brd4319a,brd4186a,brd4187a,brd2601b,brd4187c,brd4186c,brd2703a,brd4338a,brd2605a,brd4343a,brd4342a}-{window-covering,switch,unit-test,light,lock,thermostat,pump,air-quality-sensor-app}[-rpc][-with-ota-requestor][-icd][-low-power][-shell][-no-logging][-openthread-mtd][-heap-monitoring][-no-openthread-cli][-show-qr-code][-wifi][-rs9116][-wf200][-siwx917][-ipv4][-additional-data-advertising][-use-ot-lib][-use-ot-coap-lib][-no-version][-skip-rps-generation]
esp32-{m5stack,c3devkit,devkitc,qemu}-{all-clusters,all-clusters-minimal,energy-management,ota-provider,ota-requestor,shell,light,lock,bridge,temperature-measurement,ota-requestor,tests}[-rpc][-ipv6only][-tracing]
genio-lighting-app
linux-fake-tests[-mbedtls][-boringssl][-asan][-tsan][-ubsan][-libfuzzer][-ossfuzz][-pw-fuzztest][-coverage][-dmalloc][-clang]
linux-{x64,arm64}-{rpc-console,all-clusters,all-clusters-minimal,chip-tool,thermostat,java-matter-controller,kotlin-matter-controller,minmdns,light,light-data-model-no-unique-id,lock,shell,ota-provider,ota-requestor,simulated-app1,simulated-app2,python-bindings,tv-app,tv-casting-app,bridge,fabric-admin,fabric-bridge,fabric-sync,tests,chip-cert,address-resolve-tool,contact-sensor,dishwasher,microwave-oven,refrigerator,rvc,air-purifier,lit-icd,air-quality-sensor,network-manager,energy-management,water-leak-detector,terms-and-conditions}[-nodeps][-nlfaultinject][-platform-mdns][-minmdns-verbose][-libnl][-same-event-loop][-no-interactive][-ipv6only][-no-ble][-no-wifi][-no-thread][-no-shell][-mbedtls][-boringssl][-asan][-tsan][-ubsan][-libfuzzer][-ossfuzz][-pw-fuzztest][-coverage][-dmalloc][-clang][-test][-rpc][-with-ui][-evse-test-event][-enable-dnssd-tests][-disable-dnssd-tests][-chip-casting-simplified][-googletest][-terms-and-conditions]
linux-x64-efr32-test-runner[-clang]
imx-{chip-tool,lighting-app,thermostat,all-clusters-app,all-clusters-minimal-app,ota-provider-app}[-release]
infineon-psoc6-{lock,light,all-clusters,all-clusters-minimal}[-ota][-updateimage][-trustm]
nxp-{k32w0,k32w1,rt1060,rt1170,rw61x,rw61x_eth,mcxw71}-{zephyr,freertos}-{lighting,contact-sensor,lock-app,all-clusters,laundry-washer,thermostat}[-factory][-low-power][-lit][-fro32k][-smu2][-dac-conversion][-rotating-id][-sw-v2][-ota][-wifi][-ethernet][-thread][-matter-shell][-factory-build][-frdm][-cmake][-evkc][-iw416][-w8801][-iwx12][-log-all][-log-progress][-log-error][-log-none]
mbed-cy8cproto_062_4343w-{lock,light,all-clusters,all-clusters-minimal,pigweed,ota-requestor,shell}[-release][-develop][-debug]
mw320-all-clusters-app
nrf-{nrf5340dk,nrf52840dk,nrf52840dongle}-{all-clusters,all-clusters-minimal,lock,light,light-switch,shell,pump,pump-controller,window-covering}[-rpc]
nrf-native-posix-64-tests
nuttx-x64-light
qpg-qpg6105-{lock,light,shell,persistent-storage,light-switch,thermostat}[-updateimage]
stm32-stm32wb5mm-dk-light
tizen-arm-{all-clusters,chip-tool,light,tests}[-no-ble][-no-thread][-no-wifi][-asan][-ubsan][-coverage][-with-ui]
telink-{tlsr9118bdk40d,tlsr9518adk80d,tlsr9528a,tlsr9528a_retention,tl3218x,tl7218x,tl7218x_retention}-{air-quality-sensor,all-clusters,all-clusters-minimal,bridge,contact-sensor,light,light-switch,lock,ota-requestor,pump,pump-controller,shell,smoke-co-alarm,temperature-measurement,thermostat,window-covering}[-ota][-dfu][-shell][-rpc][-factory-data][-4mb][-mars][-usb][-compress-lzma][-thread-analyzer]
openiotsdk-{shell,lock}[-mbedtls][-psa]
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
