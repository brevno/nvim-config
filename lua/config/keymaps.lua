-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", ";", ":", { desc = "Enter command mode" })
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Quickly swap between the file explorer (tree) and the symbol structure
-- (outline) side panel, closing whichever one is open and opening the other.
vim.keymap.set("n", "<leader>uo", function()
  local outline = package.loaded["outline"]
  local outline_open = outline and outline.is_open and outline.is_open()
  if outline_open then
    vim.cmd("Outline")
    Snacks.explorer()
  else
    vim.cmd("Outline")
  end
end, { desc = "Toggle Structure <-> Tree" })
