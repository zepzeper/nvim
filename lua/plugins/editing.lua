-- Editing: orgmode — loaded on the first org buffer
local pack = require("core.pack")

pack.load({ "https://github.com/nvim-orgmode/orgmode" })

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
end, "org")
