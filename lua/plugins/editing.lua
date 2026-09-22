-- Editing: orgmode — loaded on the first org buffer
local pack = require("core.pack")

pack.lazy({ "https://github.com/nvim-orgmode/orgmode" })

pack.load_on("FileType", "orgmode", function()
  require("orgmode").setup({
    org_agenda_files = { "~/orgfiles/*.org" },
    org_default_notes_file = "~/orgfiles/inbox.org",
    org_capture_templates = {
      w = {
        description = "Work task",
        template = [[
* TODO %? :work:
  CREATED: %U
]],
        target = "~/orgfiles/work.org",
      },
      p = {
        description = "Personal task",
        template = [[
* TODO %?
  CREATED: %U
]],
        target = "~/orgfiles/personal.org",
      },
      i = {
        description = "Inbox",
        template = [[
* TODO %?
  CREATED: %U
]],
        target = "~/orgfiles/inbox.org",
      },
    },
  })
  -- setup() registers orgmode's own FileType autocmd, but this buffer's
  -- FileType event already fired — re-dispatch so orgmode attaches to it.
  if vim.bo.filetype == "org" then
    vim.api.nvim_exec_autocmds("FileType", { buffer = 0 })
  end
end, "org")
