-- Core configuration loader
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Plugin management (builtin vim.pack)
require("core.pack")

-- Plugin modules: declare specs, wire lazy-loading triggers
require("plugins.colorscheme")
require("plugins.coding")
require("plugins.lsp")
require("plugins.formatting")
require("plugins.linting")
require("plugins.git")
require("plugins.oil")
require("plugins.fzf")
require("plugins.harpoon")
require("plugins.debugging")
require("plugins.docs")
require("plugins.editing")
require("plugins.ui")
require("plugins.supermaven")

-- Install everything registered via pack.lazy (no-op load)
require("core.pack").finish()
