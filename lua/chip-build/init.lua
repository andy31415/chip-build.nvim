-- what this module provides
local M = {}

local targets = require("chip-build.targets")
local clangd_config = require("chip-build.clangd_config")

local run_build = function(target, is_host)
	local ovs = require("overseer")

	local command = string.format(
		"source ./scripts/activate.sh >/dev/null && ./scripts/build/build_examples.py --log-level info --target '%s' build",
		target
	)

	local task_args
	local task_cmd
	if is_host then
		task_cmd = "/bin/bash"
		task_args = { "-c", command }
	else
		task_cmd = "podman"
		task_args = {
			"exec",
			"-w",
			"/workspace",
			"bld_vscode",
			"/bin/bash",
			"-c",
			command,
		}
	end

	local task = ovs.new_task({
		cmd = { task_cmd },
		args = task_args,
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
		},
	})
	task:start()

	-- Can show ovs ... not sure if we want, however seems ok
	ovs.open({ direction = "right", enter = false })
end

local load_history = function()
	local save_path = vim.fn.stdpath("cache") .. "/chip-build-history.json"
	local f = io.open(save_path, "r")
	if f == nil then
		return {}
	end

	local data = vim.json.decode(f:read("*a"))
	f:close()

	if type(data) ~= "table" then
		data = {}
	end

	return data
end

local save_target_to_history = function(target, is_host)
	local save_path = vim.fn.stdpath("cache") .. "/chip-build-history.json"
	-- Will NOT print as the messages can get annoying
	vim.notify(string.format("Saving history to: %s", save_path), vim.log.levels.DEBUG)

	local old_history = load_history()
	local history = {}
	local existing_history = {}

	table.insert(history, 1, { target = target, is_host = is_host })
	existing_history[target .. "/" .. tostring(is_host)] = true

	for _, v in ipairs(old_history) do
		local key = v.target .. "/" .. tostring(v.is_host)
		if not existing_history[key] then
			existing_history[key] = true
			table.insert(history, v)
		end
	end

	local f = io.open(save_path, "w")
	if f == nil then
		print(string.format("Failed to write to %s", save_path))
		return
	end

	f:write(vim.json.encode(history))
	f:close()
end

M.build = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	function ChipBuildSelectTarget(components, opts)
		opts = opts or {}
		local next_choices, final
		if #components > 0 and components[1] == "HOST: " then
			local tail = {}
			for i = 2, #components, 1 do
				table.insert(tail, components[i])
			end
			next_choices, final = targets.next_component_choices(tail)
		else
			next_choices, final = targets.next_component_choices(components)
		end

		local ui_choices = {}
		if opts.final or false then
			table.insert(ui_choices, "DONE")
		end

		local history = {}
		if #components == 0 then
			-- this is the first expectation ... add UI shoices for  history
			history = load_history()
			for _, v in ipairs(history) do
				-- new format update to not require deletion of old items
				if v["target"] then
					if v["is_host"] then
						table.insert(ui_choices, "TARGET: HOST: " .. v["target"])
					else
						table.insert(ui_choices, "TARGET: " .. v["target"])
					end
				else
					table.insert(ui_choices, "TARGET: " .. v)
				end
			end

			table.insert(ui_choices, "HOST: ")
		end

		if next_choices then
			for _, v in ipairs(next_choices) do
				table.insert(ui_choices, v)
			end
		end

		pickers
			.new(opts, {
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
						if choice == "DONE" then
							local is_host = components[1] == "HOST: "
							local target_start
							if is_host then
								target_start = 2
							else
								target_start = 1
							end

							local target_name = components[target_start]

							for i = target_start + 1, #components, 1 do
								target_name = target_name .. "-" .. components[i]
							end
							save_target_to_history(target_name, is_host)
							run_build(target_name, is_host)
							return
						end
						if choice:sub(1, 8) == "TARGET: " then
							local target_name = choice:sub(9)

							local is_host = target_name:sub(1, 6) == "HOST: "
							if is_host then
								target_name = target_name:sub(7)
							end
							save_target_to_history(target_name, is_host)
							run_build(target_name, is_host)
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
				finder = finders.new_table({
					results = ui_choices,
				}),
				sorter = conf.generic_sorter(opts),
			})
			:find()
	end

	ChipBuildSelectTarget({})
end

M.clangd_select = function()
	clangd_config.select_compilation_database()
end

M.active_compilation_database_name = function()
	return clangd_config.active_compilation_database_name()
end

--

local is_refreshing = false

M.refresh_targets = function()
	if is_refreshing then
		vim.notify("Targets refresh already in progress...", vim.log.levels.WARN)
		return
	end

	if vim.fn.filereadable("./scripts/build/build_examples.py") == 0 then
		vim.notify("./scripts/build/build_examples.py not found. Are you in connectedhomeip root?", vim.log.levels.ERROR)
		return
	end

	is_refreshing = true
	vim.notify("Refreshing targets...", vim.log.levels.INFO)
	local cmd = "bash -c 'source scripts/activate.sh >/dev/null && ./scripts/build/build_examples.py --quiet targets'"

	local output = {}
	local err_output = {}
	vim.fn.jobstart(cmd, {
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, data, _)
			output = data
		end,
		on_stderr = function(_, data, _)
			err_output = data
		end,
		on_exit = function(_, code, _)
			is_refreshing = false
			if code == 0 then
				local content = table.concat(output, "\n")
				local success, err = targets.update_targets_cache(content)
				if success then
					vim.notify("Targets refreshed successfully", vim.log.levels.INFO)
				else
					vim.notify("Failed to update targets cache: " .. tostring(err), vim.log.levels.ERROR)
				end
			else
				local err_msg = table.concat(err_output, "\n")
				if err_msg == "" then
					err_msg = "Unknown error (exit code " .. code .. ")"
				end
				vim.notify("Failed to refresh targets:\n" .. err_msg, vim.log.levels.ERROR)
			end
		end,
	})
end

M.devel_reset = function()
	if package.loaded["chip-build"] then
		print("Mark unloaded")
		package.loaded["chip-build"] = nil
	end
	require("chip-build").setup({ development = true })
	print("Reloaded with development enabled")
end

M.setup = function(options)
	options = options or {}

	vim.api.nvim_create_user_command("ChipBuild", function(opts)
		local cb = require("chip-build")
		local cmd = opts.args
		if cmd == "build" then
			cb.build()
		elseif cmd == "clangd_select" then
			cb.clangd_select()
		elseif cmd == "refresh_targets" then
			cb.refresh_targets()
		elseif cmd == "devel_reset" then
			cb.devel_reset()
		else
			print(string.format("Unknown chip-build command: %s", cmd))
		end
	end, {
		nargs = 1,
	})

	vim.api.nvim_set_keymap("n", "<leader>obb", "<CMD>ChipBuild build<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<leader>obc", "<CMD>ChipBuild clangd_select<CR>", { noremap = true })
	vim.api.nvim_set_keymap("n", "<leader>obr", "<CMD>ChipBuild refresh_targets<CR>", { noremap = true })
	if options.development or false then
		vim.api.nvim_set_keymap("n", "<leader>obd", "<CMD>ChipBuild devel_reset<CR>", { noremap = true })
		-- run for testing of development
		vim.api.nvim_set_keymap("n", "<leader>obt", "<CMD>source lua/chip-build/init.lua<CR>", { noremap = true })
	end
end

return M
