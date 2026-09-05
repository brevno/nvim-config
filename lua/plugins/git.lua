-- Fix `<leader>gs` (Git Status) to always resolve against the git root of the
-- current buffer, instead of Neovim's raw working directory. This mirrors
-- how LazyVim's `<leader>gg` (Lazygit) already behaves via `LazyVim.root.git()`.
return {
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status({ cwd = LazyVim.root.git() })
        end,
        desc = "Git Status (Root Dir)",
      },
    },
  },
}
