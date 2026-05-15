-- This file should be run via `busted -m lua`

local targets = require("chip-build.targets")

describe("Target iteration works", function()
	local test_targets = {
		{
			prefixes = { "foo", { "a", "b", "c" }, { "x", "y" } },
			suffixes = { "bar", "baz" },
		},
		{
			prefixes = { "test", { "1", "2", "2" } },
			suffixes = {},
		},
	}

	local next_choice = function(c)
		local next, _ = targets.next_component_choices(c, { targets = test_targets })
		return next
	end

	it("allows final first element", function()
		assert.are.same(targets.split_target_string("my-test[-foo][-bar]"), {
			prefixes = { "my-test" },
			suffixes = { "foo", "bar" },
		})

		local next, final = targets.next_component_choices(
			{},
			{ targets = { {
				prefixes = { "my-test" },
				suffixes = { "foo", "bar" },
			} } }
		)

		assert.are.same({ "my-test" }, next)
		assert.is_false(final)

		next, final = targets.next_component_choices(
			{ "my-test" },
			{ targets = { {
				prefixes = { "my-test" },
				suffixes = { "foo", "bar" },
			} } }
		)

		assert.are.same({ "bar", "foo" }, next)
		assert.is_true(final)
	end)

	it("shows top level items", function()
		assert.are.same(next_choice({}), { "foo", "test" })
	end)

	it("can get prefixes", function()
		assert.are.same(next_choice({ "foo" }), { "a", "b", "c" })
	end)

	it("can get suffixes", function()
		assert.are.same(next_choice({ "foo", "a", "x" }), { "bar", "baz" })

		-- suffixes are trimmed
		assert.are.same(next_choice({ "foo", "a", "x", "bar" }), { "baz" })
		assert.are.same(next_choice({ "foo", "a", "x", "bar", "baz" }), {})
		assert.are.same(next_choice({ "test", "1" }), {})
	end)
end)

describe("String splitting", function()
	it("splits strings", function()
		assert.are.same(targets.split_lines("test\nbar"), { "test", "bar" })
		assert.are.same(targets.split_lines("\ntest\n\n\nbar\n"), { "test", "bar" })

		assert.are.same(
			targets.split_lines([[
this-is
what-is-used
    ]]),
			{ "this-is", "what-is-used" }
		)
		assert.are.same(
			targets.split_lines([[
       ignores
       begin
       and-end
       whitespace
       embedded whitepace is ok
    ]]),
			{
				"ignores",
				"begin",
				"and-end",
				"whitespace",
				"embedded whitepace is ok",
			}
		)
	end)
end)

describe("target_split", function()
	it("splits the start", function()
		assert.are.same(targets.split_target_string("foo"), {
			prefixes = { "foo" },
			suffixes = {},
		})
		assert.are.same(targets.split_target_string("bar-"), {
			prefixes = { "bar" },
			suffixes = {},
		})
		assert.are.same(targets.split_target_string("bar-baz"), {
			prefixes = { "bar-baz" },
			suffixes = {},
		})
		assert.are.same(targets.split_target_string("bar-baz-"), {
			prefixes = { "bar-baz" },
			suffixes = {},
		})
	end)

	it("splits groups", function()
		assert.are.same(targets.split_target_string("foo-{a,b}"), {
			prefixes = { "foo", { "a", "b" } },
			suffixes = {},
		})
		assert.are.same(targets.split_target_string("foo-{a,b}-{x,yz1,a-test}"), {
			prefixes = { "foo", { "a", "b" }, { "x", "yz1", "a-test" } },
			suffixes = {},
		})
	end)

	it("splits suffixes", function()
		assert.are.same(targets.split_target_string("foo-{a,b}[-foo]"), {
			prefixes = { "foo", { "a", "b" } },
			suffixes = { "foo" },
		})
		assert.are.same(targets.split_target_string("foo-{a,b}[-foo][-bar]"), {
			prefixes = { "foo", { "a", "b" } },
			suffixes = { "foo", "bar" },
		})
		assert.are.same(targets.split_target_string("no-groups[-foo][-bar]"), {
			prefixes = { "no-groups" },
			suffixes = { "foo", "bar" },
		})
	end)

	it("splits with end", function()
		assert.are.same(targets.split_target_string("x-{a,b}-foo[-bar][-foo]"), {
			prefixes = { "x", { "a", "b" }, "foo" },
			suffixes = { "bar", "foo" },
		})
		assert.are.same(targets.split_target_string("x-{a,b}-{foo}[-bar][-foo]"), {
			prefixes = { "x", { "a", "b" }, { "foo" } },
			suffixes = { "bar", "foo" },
		})
	end)
end)

describe("clangd_config", function()
  local clangd_config
  local mock_files
  local orig_io_open = io.open

  before_each(function()
    -- Mock vim globals
    _G.vim = {
      fn = {
        getcwd = function() return "/mock/root" end,
        globpath = function(path, expr, _, _)
          if path == "/mock/root/out" and expr == "linux-x64-*/compile_commands.json" then
            return {
              "/mock/root/out/linux-x64-target1/compile_commands.json",
              "/mock/root/out/linux-x64-target2/compile_commands.json",
              "/mock/root/out/linux-x64-target3/sub/compile_commands.json",
            }
          end
          return {}
        end,
        fnamemodify = function(path, mod)
          if mod == ':h' then
            return path:match("^(.*)/[^/]*$")
          elseif mod == ':t' then
            return path:match("^.*/([^/]*)$")
          end
          return path
        end
      }
    }

    -- Mock io.open
    mock_files = {
      ["/mock/root/.clangd"] = {
        content = {
          "CompileFlags:",
          "  CompilationDatabase: /mock/root/out/linux-x64-target1/",
          "  # CompilationDatabase: /mock/root/out/linux-x64-target2",
        }
      }
    }

    _G.io.open = function(path, mode)
      mode = mode or 'r'
      if path:sub(1, 10) == "/mock/root" then
        if mode == 'r' then
          local f = mock_files[path]
          if not f then return nil end
          local i = 0
          return {
            lines = function()
              return function()
                i = i + 1
                return f.content[i]
              end
            end,
            close = function() end
          }
        elseif mode == 'w' then
          mock_files[path] = { content = {} }
          return {
            write = function(self, str)
              str = str:gsub("\n$", "")
              table.insert(mock_files[path].content, str)
            end,
            close = function() end
          }
        end
      else
        return orig_io_open(path, mode)
      end
    end

    clangd_config = require('chip-build.clangd_config')
  end)

  after_each(function()
    _G.io.open = orig_io_open
  end)

  it("finds compilation databases", function()
    local dbs = clangd_config.find_compilation_databases()
    assert.are.same({
      { display = "linux-x64-target1", absolute_path = "/mock/root/out/linux-x64-target1" },
      { display = "linux-x64-target2", absolute_path = "/mock/root/out/linux-x64-target2" },
      { display = "linux-x64-target3/sub", absolute_path = "/mock/root/out/linux-x64-target3/sub" },
    }, dbs)
  end)

  it("gets current compilation database", function()
    assert.are.equal("/mock/root/out/linux-x64-target1", clangd_config.get_current_compilation_database())
  end)

  it("gets active compilation database name", function()
    assert.are.equal("linux-x64-target1", clangd_config.active_compilation_database_name())
  end)

  it("sets compilation database", function()
    clangd_config.set_compilation_database("/mock/root/out/linux-x64-target2")
    assert.are.equal("/mock/root/out/linux-x64-target2", clangd_config.get_current_compilation_database())
    -- Verify original comment was preserved
    assert.are.same({
      "CompileFlags:",
      "  CompilationDatabase: /mock/root/out/linux-x64-target2",
      "  # CompilationDatabase: /mock/root/out/linux-x64-target2",
    }, mock_files["/mock/root/.clangd"].content)
  end)
end)

describe("targets caching", function()
  local orig_vim = _G.vim
  local orig_io_open = io.open
  local mock_files = {}

  before_each(function()
    _G.vim = {
      fn = {
        stdpath = function(path)
          if path == "cache" then
            return "/mock/cache"
          end
          return "/mock/other"
        end
      }
    }

    mock_files = {
      ["/mock/cache/chip-build-targets.txt"] = {
        content = {
          "custom-target1",
          "custom-target2-{a,b}[-opt]",
        }
      }
    }

    _G.io.open = function(path, mode)
      mode = mode or 'r'
      if path:sub(1, 11) == "/mock/cache" then
        if mode == 'r' then
          local f = mock_files[path]
          if not f then return nil end
          return {
            read = function(self, arg)
              if arg == "*a" then
                return table.concat(f.content, "\n")
              end
              return nil
            end,
            close = function() end
          }
        elseif mode == 'w' then
          mock_files[path] = { content = {} }
          return {
            write = function(self, str)
              mock_files[path].content = { str }
            end,
            close = function() end
          }
        end
      else
        return orig_io_open(path, mode)
      end
    end
  end)

  after_each(function()
    _G.vim = orig_vim
    _G.io.open = orig_io_open
    targets.reload_targets()
  end)

  it("loads targets from cache when available", function()
    targets.reload_targets()
    local next_choices, _ = targets.next_component_choices({})
    assert.are.same({ "custom-target1", "custom-target2" }, next_choices)
  end)

  it("falls back to default when cache is missing", function()
    mock_files = {} -- no cache
    targets.reload_targets()
    local next_choices, _ = targets.next_component_choices({})
    assert.are.equal("ameba-amebad", next_choices[1])
  end)
end)
