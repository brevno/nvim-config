-- Symbol structure pane (outline.nvim), shown side-by-side with the
-- snacks.nvim explorer tree. `<leader>cs` toggles it, and `<leader>e` still
-- toggles the file tree, so you can have either (or both) open at once.
return {
  {
    "hedyhli/outline.nvim",
    keys = {
      { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline (structure)" },
    },
    cmd = "Outline",
    opts = function()
      local defaults = require("outline.config").defaults
      local opts = {
        outline_window = {
          -- keep it on the same side as the file tree, but nvim will
          -- stack it once the tree is already open on the left
          position = "left",
          width = 30,
          relative_width = false,
          auto_close = false,
          auto_jump = false,
        },
        symbols = {
          icons = {},
          filter = vim.deepcopy(LazyVim.config.kind_filter),
        },
        keymaps = {
          up_and_jump = "<up>",
          down_and_jump = "<down>",
        },
      }

      for kind, symbol in pairs(defaults.symbols.icons) do
        opts.symbols.icons[kind] = {
          icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
          hl = symbol.hl,
        }
      end
      return opts
    end,
  },
}
