return {
  "saghen/blink.cmp",
  optional = true,
  opts = function(_, opts)
    local disabled_filetypes = { "codecompanion" }

    local prev_enabled = opts.enabled
    opts.enabled = function()
      if vim.tbl_contains(disabled_filetypes, vim.bo.filetype) then
        return false
      end
      if type(prev_enabled) == "function" then
        return prev_enabled()
      end
      return true
    end

    -- Default experience: Copilot's own gray ghost-text suggestion only.
    -- Never let blink.cmp auto-pop the dropdown while typing (it's only
    -- shown explicitly via <C-space>), and disable blink's own ghost text
    -- preview so it doesn't fight with Copilot's.
    opts.completion = opts.completion or {}
    opts.completion.trigger = vim.tbl_deep_extend("force", opts.completion.trigger or {}, {
      show_on_keyword = false,
      show_on_trigger_character = false,
      show_on_insert = false,
      show_on_backspace = false,
      show_on_backspace_in_keyword = false,
      show_on_backspace_after_accept = false,
      show_on_backspace_after_insert_enter = false,
    })
    opts.completion.ghost_text = vim.tbl_deep_extend("force", opts.completion.ghost_text or {}, {
      enabled = false,
    })

    -- Copilot is wired in as a regular blink source (see the `ai.copilot`
    -- extra). We don't want it mixed into the manually-triggered dropdown
    -- since it's already shown as ghost text, so build the source list
    -- without it.
    local default_sources = opts.sources and opts.sources.default or { "lsp", "path", "snippets", "buffer" }
    local lsp_sources = vim.tbl_filter(function(id)
      return id ~= "copilot"
    end, default_sources)

    -- <C-space> toggles between Copilot ghost text and the blink.cmp
    -- dropdown (LSP/snippets/path/buffer):
    --  - if the dropdown is open, close it and let Copilot's ghost text
    --    take back over
    --  - otherwise, dismiss the ghost text and force-open the dropdown
    opts.keymap = opts.keymap or {}
    -- Navigate the dropdown with <C-n>/<C-p> regardless of the active
    -- keymap preset (works alongside arrow keys, which remain bound too).
    opts.keymap["<C-n>"] = { "select_next", "fallback" }
    opts.keymap["<C-p>"] = { "select_prev", "fallback" }
    opts.keymap["<C-j>"] = { "select_next", "fallback" }
    opts.keymap["<C-k>"] = { "select_prev", "fallback" }

    opts.keymap["<C-space>"] = {
      function(cmp)
        if cmp.is_visible() then
          cmp.hide()
          -- nudge copilot to re-request a suggestion now that the
          -- dropdown is gone, instead of waiting for the next keystroke
          vim.schedule(function()
            pcall(vim.api.nvim_exec_autocmds, "CursorMovedI", { buffer = 0 })
          end)
          return true
        end

        local ok, suggestion = pcall(require, "copilot.suggestion")
        if ok then
          suggestion.dismiss()
        end

        cmp.show({ providers = lsp_sources, force = true })
        return true
      end,
    }
  end,
}
