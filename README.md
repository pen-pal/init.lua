# Neovim Configuration

A personal Neovim setup built around [lazy.nvim](https://github.com/folke/lazy.nvim),
aiming for full IDE / Emacs-level capability while staying fast and modal.

## Highlights

- **LSP** via `mason` + `nvim-lspconfig` (lua, go, rust, typescript, tailwind, ruby),
  completion with `nvim-cmp` + `LuaSnip`, inlay hints, signature help, breadcrumbs.
- **Diagnostics & quality**: `trouble`, `nvim-lint`, `conform` formatting,
  `todo-comments`, reference highlighting.
- **Debugging**: `nvim-dap` + `dap-ui` + virtual text, `neotest` for tests.
- **Git**: `fugitive`, `gitsigns`, `diffview`, `neogit`, `git-conflict`.
- **Navigation**: `telescope` (+ fzf-native), `harpoon`, `flash`, `aerial`
  symbol outline, `nvim-tree` / `oil` file management, `project.nvim`.
- **Editing**: `nvim-surround`, `nvim-autopairs`, `mini.nvim`, multi-cursor,
  `nvim-spectre` project find/replace, `refactoring.nvim`.
- **Tooling**: `toggleterm`, `dadbod-ui` database client, `kulala` REST client.
- **Notes**: `obsidian.nvim` (org-mode style), `render-markdown`.
- **UI**: `lualine`, `bufferline`, `alpha` dashboard, `which-key`, `noice`,
  `nvim-web-devicons`, `indent-blankline`, `colorizer`.

## Layout

```
init.lua                 -- entrypoint
lua/manishk/
  init.lua               -- options, autocmds, LSP-attach keymaps
  set.lua, remap.lua     -- options and core keymaps
  lazy_init.lua          -- bootstraps lazy.nvim
  lazy/                  -- one file per plugin spec
```

## Keymaps

See [KEYMAPS.md](./KEYMAPS.md) for the full reference. Leader is `Space`.

## Requirements

- Neovim 0.10+
- A Nerd Font in the terminal (for devicons)
- `git`, `make`, a C compiler, and the `tree-sitter` CLI (for parser builds)
- `ripgrep` (for telescope live grep)
- Optional per-language tools: `ruby-lsp`, `rubocop`, `eslint_d`, etc.

## License

[MIT](./LICENSE)
