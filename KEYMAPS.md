# Neovim Keymaps

**Leader = `Space`** (`vim.g.mapleader = " "`)

> **macOS note:** `<M-…>` = **Option (⌥)**. Enable "Use Option as Meta": iTerm2 → Keys → Left Option = `Esc+`; Terminal.app → "Use Option as Meta key"; Alacritty → `option_as_alt = "Both"` (already set). Else `<M-h>`, `<M-1..4>`, `<M-j>/<M-k>` won't fire. `<C-…>` = Control, `<F8>`… = function keys.

> **Mode legend:** n=normal, i=insert, v=visual, x=visual-block/charwise, o=operator-pending, s=select. Buffer-local maps noted.

---

## Core / motions (`remap.lua`)
| Key | Mode | Action |
|---|---|---|
| `<leader>pv` | n | netrw file explorer (`:Ex`) |
| `J` / `K` | v | Move selected lines down / up |
| `J` | n | Join line below, keep cursor pos |
| `<C-d>` / `<C-u>` | n | Half-page down / up, centered |
| `n` / `N` | n | Next / prev search, centered |
| `=ap` | n | Reindent paragraph, keep pos |
| `<C-c>` | i | Esc |
| `Q` | n | Disabled (no-op) |
| `<leader>x` | n | `chmod +x` current file |
| `<leader>zig` | n | `:LspRestart` |
| `<leader>ca` | n | cellular-automaton "make it rain" |
| `<leader><leader>` | n | Source current file (lua/vim only) |

## Yank / paste / delete
| Key | Mode | Action |
|---|---|---|
| `<leader>p` | x | Paste over selection, keep register |
| `<leader>y` / `<leader>Y` | n,v / n | Yank (line) to system clipboard |
| `<leader>d` | n,v | Delete to void register |

## Quickfix / location / search
| Key | Mode | Action |
|---|---|---|
| `<C-k>` / `<C-j>` | n | Quickfix next / prev, centered |
| `<leader>k` / `<leader>j` | n | Location-list next / prev |
| `<leader>s` | n | Replace word under cursor (global) |
| `<leader>F` | n | Project find & replace (spectre) |

## tmux
| Key | Mode | Action |
|---|---|---|
| `<C-f>` | n | tmux-sessionizer (new window) |
| `<M-h>` ⌥h | n | tmux-sessionizer session 0, vsplit |
| `<M-H>` ⌥⇧h | n | tmux-sessionizer session 0, new window |

## Go error snippets (`remap.lua`)
| Key | Action |
|---|---|
| `<leader>ee` | `if err != nil { return err }` |
| `<leader>ea` | `assert.NoError(err, "")` |
| `<leader>ef` | `if err != nil { log.Fatalf(...) }` |
| `<leader>el` | `if err != nil { .logger.Error(...) }` |

---

## LSP (buffer-local on attach — `init.lua`)
| Key | Mode | Action |
|---|---|---|
| `gd` | n | Go to definition |
| `K` | n | Hover docs |
| `<leader>vws` | n | Workspace symbol |
| `<leader>vd` | n | Diagnostic float |
| `<leader>vca` | n | Code action |
| `<leader>vrr` | n | References |
| `<leader>vrn` | n | Rename |
| `<C-h>` | i | Signature help |
| `[d` / `]d` | n | Next / prev diagnostic |
| `<leader>ih` | n | Toggle inlay hints |

## Completion (nvim-cmp — insert)
| Key | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next / prev completion item |
| `<C-y>` | Confirm selection |
| `<C-Space>` | Trigger completion |
| `<C-k>` | Toggle signature popup (lsp_signature) |

## Format / test / debug
| Key | Action |
|---|---|
| `<leader>f` | Format buffer (conform) |
| `<leader>tf` | PlenaryTestFile |
| `<leader>lt` | PlenaryBustedFile (current) |
| `<leader>vwm` / `<leader>svwm` | Start / stop VimWithMe |
| `<F8>` | DAP continue |
| `<F10>` / `<F11>` / `<F12>` | DAP step over / into / out |
| `<leader>b` / `<leader>B` | DAP toggle / conditional breakpoint |
| `<leader>dr/ds/dw/db/dS/dc` | DAP UI: repl/stacks/watches/breakpoints/scopes/console |

---

## Telescope
| Key | Action |
|---|---|
| `<leader>pf` | Find files |
| `<C-p>` | Git files (normal mode) |
| `<leader>pws` / `<leader>pWs` | Grep word / WORD under cursor |
| `<leader>ps` | Grep (prompt) |
| `<leader>pt` | Search todos |
| `<leader>fp` | Switch project |
| `<leader>vh` | Help tags |

## Files / buffers / outline
| Key | Action |
|---|---|
| `<leader>n` | nvim-tree toggle |
| `-` | oil — parent dir as buffer |
| `<leader>cs` | Symbol outline (aerial) |
| `[b` / `]b` | Prev / next buffer (bufferline) |
| `<leader>bd` | Delete buffer, keep window (mini.bufremove) |
| `<leader>u` | Undotree toggle |
| `<leader>zz` / `<leader>zZ` | Zen mode (variants) |

## Harpoon (`harpoon2`)
| Key | Action |
|---|---|
| `<leader>a` / `<leader>A` | Add / prepend file |
| `<C-e>` | Toggle quick menu |
| `<M-1>`…`<M-4>` ⌥1–4 | Jump to file 1–4 |

## Navigation / editing
| Key | Mode | Action |
|---|---|---|
| `s` / `S` | n,x,o | Flash jump / treesitter jump |
| `r` | o | Remote flash |
| `ysiw)` `cs"'` `ds(` | n | Surround add / change / delete |
| `<C-n>` | n,x | Multi-cursor select+add (visual-multi); `n`/`N` nav, `q` skip |
| `<M-j>` / `<M-k>` | n,v | Move line/selection down / up (mini.move) |
| `]]` / `[[` | n | Next / prev reference highlight (illuminate) |
| `[x` | n | Jump to context (treesitter-context) |
| `zR` / `zM` | n | Open / close all folds (ufo) |
| `<C-s>e` | i | LuaSnip expand |
| `<C-s>;` / `<C-s>,` | i,s | LuaSnip jump fwd / back |
| `<C-E>` | i,s | LuaSnip change choice |

---

## Git
| Key | Action |
|---|---|
| `<leader>gs` | `:Git` status (fugitive) |
| `<leader>gg` | Neogit (magit-style UI) |
| `<leader>p` / `<leader>P` | (fugitive buf) push / pull |
| `<leader>t` | (fugitive buf) `:Git push -u origin ` |
| `gu` / `gh` | diffget //2 (target) / //3 (merge) |
| `<leader>gD` | Diffview open |
| `<leader>gH` | Diffview file history (this file) |
| `<leader>gQ` | Diffview close |

### Gitsigns (buffer-local)
| Key | Action |
|---|---|
| `]c` / `[c` | Next / prev hunk |
| `<leader>hs` / `<leader>hr` / `<leader>hu` | Stage / reset / undo-stage hunk |
| `<leader>hp` / `<leader>hb` / `<leader>hd` | Preview hunk / blame line / diff this |
| `<leader>tb` | Toggle line blame |

### Git conflict (inside conflict buffers)
| Key | Action |
|---|---|
| `co` / `ct` / `cb` / `c0` | Choose ours / theirs / both / none |
| `]x` / `[x` | Next / prev conflict (overrides context-jump here) |

## Diagnostics / lists
| Key | Action |
|---|---|
| `<leader>tt` | Trouble toggle |
| `[t` / `]t` | Trouble prev / next |
| `]T` / `[T` | Next / prev todo comment |

---

## Tooling
| Key | Action |
|---|---|
| `<C-\>` | Toggle floating terminal (toggleterm) |
| `<leader>rr` | Refactor menu — n,x (refactoring.nvim) |
| `<leader>Du` | Database UI (dadbod-ui) |
| `<leader>kr` / `<leader>kp` / `<leader>kn` | Run / prev / next HTTP request (kulala, `.http`) |

## Sessions (persistence)
| Key | Action |
|---|---|
| `<leader>qs` | Restore session (cwd) |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Stop saving session |

## Notes — obsidian (vault `~/notes`)
| Key | Action |
|---|---|
| `<leader>on` | New note |
| `<leader>os` | Search notes |
| `<leader>oq` | Quick switch note |
| `<leader>ob` | Backlinks |
| `<leader>od` | Daily note |

---

## Org-mode (nvim-orgmode, files in `~/org`)
| Key | Action |
|---|---|
| `<leader>oa` | Agenda (global) |
| `<leader>oc` | Capture — task / note / journal (global) |
| `<leader>oeh` | Export current `.org` → HTML (via headless emacs) |
| `<leader>oep` | Export current `.org` → PDF (via headless emacs) |
| `<leader>oex` | Babel: execute code blocks in buffer (via headless emacs) |
| `<leader>R` … | org-roam prefix: find / insert / capture nodes (vault `~/org/roam`) |

In `.org` buffers (orgmode defaults): `<CR>` follow/toggle, `cit` cycle TODO, `<S-Up/Down>` priority, `<C-Space>` toggle checkbox, `<Tab>`/`<S-Tab>` fold, `<leader>o*` (org actions). See `:h orgmode-mappings`.

> **emacs backend** = invisible. `<leader>oeh/oep/oex` shell out to `emacs --batch` (no window). Requires working `emacs` (emacs-plus@30, verified). Editing/agenda/capture need NO emacs — pure nvim-orgmode.

## Documents / preview
| Key | Action |
|---|---|
| `<leader>mp` | Markdown live preview in browser (auto-refresh, markdown-preview.nvim) |
| `<leader>Pp` / `<leader>Ph` / `<leader>Pd` | Pandoc export current buffer → PDF / HTML / docx (opens result) |
| `<leader>oeh` / `<leader>oep` / `<leader>oex` | Org → HTML / PDF / babel-execute (headless emacs) |
| `\ll` / `\lv` / `\lc` | LaTeX (vimtex, in `.tex`): compile / view in Skim / clean — `\` = localleader |

**Markdown preview:** `:RenderMarkdown` inline (auto) + peek browser preview. **Images inline** (`image.nvim`): auto in **Ghostty/Kitty/WezTerm only** — Alacritty can't (no graphics protocol). **YAML/JSON**: schema-aware completion/validation auto (SchemaStore).

## Auto (no keymap)
**barbecue** breadcrumb winbar · **nvim-lint** (rubocop/eslint_d/shellcheck/hadolint if installed) · **dressing** select/input UI · **nvim-bqf** quickfix preview · **render-markdown** inline md · **nvim-dap-virtual-text** inline debug values · **colorizer** hex swatches · **indent-blankline** guides · **autopairs** · **fidget** LSP progress · **noice** LSP doc borders (cmdline popup disabled).

## `local.lua` (active — leader 9 / `99` agent)
| Key | Action |
|---|---|
| `<leader>9s/9vv/9vp/9x/9i/9l/9n/9p` | local `99` plugin actions |

> Most of `local.lua` (`<leader>5*`, `<leader>ct/cr`) is commented out — inactive.

---

## Notable overrides (changed from vanilla vim)
- `s` / `S` → flash jump (was substitute — use `cl` / `cc`)
- `-` → oil (was a line motion)
- `<leader><leader>` → source file, **lua/vim only** (guarded against E488)
- `<C-n>`/`<C-p>`: cmp in **insert**, telescope git-files / visual-multi in **normal** (no clash)
- `[x`: treesitter-context jump globally; git-conflict nav inside conflict buffers
