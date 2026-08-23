return {
  "zbirenbaum/copilot.lua",
  -- LazyVim's extra only lazy-loads copilot.lua on BufReadPost, so if a
  -- CodeCompanionChat is the very first buffer opened, copilot.lua (and its
  -- attach/suggestion autocmds) never gets loaded in time. Add extra events
  -- so it's guaranteed to load whenever a codecompanion buffer shows up.
  event = { "BufReadPost", "FileType codecompanion" },
  cmd = { "Copilot", "CodeCompanionChat", "CodeCompanion" },
  opts = function(_, opts)
    -- LazyVim sets vim.g.ai_cmp = true by default, which disables ghost-text
    -- suggestions in favor of a blink.cmp/copilot-cmp dropdown. Force ghost
    -- text back on so we get shadow-text suggestions everywhere (including
    -- in the CodeCompanion chat buffer, where the cmp dropdown is disabled).
    opts.suggestion = opts.suggestion or {}
    opts.suggestion.enabled = true

    opts.filetypes = opts.filetypes or {}
    opts.filetypes.codecompanion = true

    local default_should_attach = (opts.should_attach and opts.should_attach)
      or require("copilot.config.should_attach").default

    opts.should_attach = function(bufnr, bufname)
      if vim.bo[bufnr].filetype == "codecompanion" then
        return true
      end
      return default_should_attach(bufnr, bufname)
    end

    -- LazyVim sets keymap.accept = false because it expects blink.cmp's
    -- ai_accept (bound to <Tab>) to accept ghost-text suggestions. Since we
    -- disabled blink.cmp in the codecompanion chat buffer (and want ghost
    -- text to work everywhere), let copilot.lua's own battle-tested
    -- accept keymap handle <Tab> directly instead.
    opts.suggestion.keymap = opts.suggestion.keymap or {}
    opts.suggestion.keymap.accept = "<Tab>"
  end,
}
