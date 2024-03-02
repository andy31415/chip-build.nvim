# chip-build.nvim
A plugin for automating build commands for connectedhomeip

## Development

Set the runtime path including the local plugin:

```
vim --cmd "set rtp+=." --cmd ":lua require('chip-build').setup({development=true})"
```
