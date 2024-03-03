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

Set the runtime path including the local plugin:

```
vim --cmd "set rtp^=.,&rtp" --cmd ":lua require('chip-build').setup({development=true})"
```
