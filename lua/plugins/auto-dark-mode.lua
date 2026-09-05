return {
  "f-person/auto-dark-mode.nvim",
  event = "VeryLazy",
  opts = {
    update_interval = 3000,
    set_dark_mode = function()
      vim.o.background = "dark"
      vim.cmd("colorscheme gruvbox")
    end,
    set_light_mode = function()
      vim.o.background = "light"
      vim.cmd("colorscheme gruvbox")
    end,
  },
}
