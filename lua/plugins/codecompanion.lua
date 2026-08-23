return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
    "CodeCompanionCmd",
  },
  keys = {
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle @agent<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    { "<leader>ai", "<cmd>CodeCompanion @agent<cr>", mode = { "n", "v" }, desc = "CodeCompanion Inline" },
  },
  opts = {
    strategies = {
      chat = {
        adapter = "copilot",
        tools = {
          opts = {
            default_tools = { "agent" }, -- Always load the @agent tool group in every chat
          },
        },
      },
      inline = { adapter = "copilot" },
      cmd = { adapter = "copilot" },
    },
    adapters = {
      http = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-sonnet-5",
              },
            },
          })
        end,
      },
    },
    extensions = {
      history = {
        enabled = true,
        opts = {
          -- Automatically save every chat session as you go
          auto_save = true,
          -- Save chats under stdpath("data")/codecompanion-history
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
          keymap = "gh",
          save_chat_keymap = "sc",
          continue_last_chat = false,
          delete_on_clearing_chat = false,
          picker = "snacks",
          auto_generate_title = true,
        },
      },
    },
  },
}
