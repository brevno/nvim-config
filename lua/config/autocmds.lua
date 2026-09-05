-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Flip the terminal cursor color to match light/dark background
local function set_cursor_color()
  if vim.o.background == "dark" then
    -- dark mode -> light cursor
    vim.api.nvim_set_hl(0, "Cursor", { bg = "#ffffff", fg = "#000000" })
  else
    -- light mode -> dark cursor
    vim.api.nvim_set_hl(0, "Cursor", { bg = "#000000", fg = "#ffffff" })
  end
end

vim.api.nvim_create_autocmd({ "ColorScheme", "OptionSet" }, {
  pattern = "background",
  group = vim.api.nvim_create_augroup("cursor_color_bg_sync", { clear = true }),
  callback = set_cursor_color,
})

set_cursor_color()

-- When Neovim is started with a single directory argument (e.g. `nvim
-- ~/.config/nvim` while your shell is still in another folder), make that
-- directory Neovim's working directory. This keeps things like `<leader>gs`
-- (git status), pickers, etc. scoped to the project you actually opened,
-- instead of whatever folder your shell happened to be in.
--
-- Note: this only affects Neovim's own cwd; your shell's directory is
-- untouched, so once you quit Neovim you're back exactly where you started.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("cd_to_dir_arg", { clear = true }),
  once = true,
  nested = true,
  callback = function()
    if vim.fn.argc() ~= 1 then
      return
    end
    local arg = vim.fn.argv(0) --[[@as string]]
    local path = vim.fn.fnamemodify(arg, ":p")
    if vim.fn.isdirectory(path) == 1 then
      vim.cmd.cd(path)
    end
  end,
})
