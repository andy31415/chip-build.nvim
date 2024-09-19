# chip-build.nvim
A plugin for automating build commands for connectedhomeip

## Installation

### Dependencies

- [Overseer](https://github.com/stevearc/overseer.nvim)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)

### Config file

In LunarVim you can do:

```
  {
    "stevearc/overseer.nvim",
    opts = {}
  },
  {
    "andy31415/chip-build.nvim",
    config = function()
      require('chip-build').setup()
    end
  },
```

## Development

### Unit testing

Install [luarocks](http://luarocks.org).

[busted](https://lunarmodules.github.io/busted/) unit test framework via 
`luarocks install busted --local`

Then you can add `$HOME/.luarocks/bin` to your path or execute
`$HOME/.luarocks/bin/busted` directly from within the `lua/chip-build`
subsidrectory:

```
$HOME/.luarocks/bin/busted -m 'lua/?.lua;lua/?/init.lua' lua/chip-build/test.lua
```

Or execute `tests.sh` which does the same thing.



### Running inside nvim (to test the real thing)

Set the runtime path including the local plugin:

```
vim --cmd "set rtp^=.,&rtp" --cmd ":lua require('chip-build').setup({development=true})"
```
