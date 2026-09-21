-- Plugin management via the builtin `vim.pack` (see :h vim.pack).
--
-- Plugins are installed into `site/pack/core/opt` and the install state is
-- tracked in `nvim-pack-lock.json` (commit it for reproducible setups).
--
-- Eager plugins are added with `M.add()`: their directories land on
-- 'runtimepath' and their `plugin/` scripts are sourced during startup.
--
-- Lazy plugins are registered with `M.lazy()` (added to disk, but not loaded)
-- and are loaded on demand via `M.load()`, typically from keymaps or
-- `once` autocmds. `M.finish()` must be called after all plugin modules.

local M = {}

local lazy_specs = {}
local loaded = {}

--- Add plugins that load during startup (specs: strings or vim.pack.Spec).
function M.add(specs)
  vim.pack.add(specs, { confirm = false })
end

--- Register plugins to install now, but load only on demand.
function M.lazy(specs)
  vim.list_extend(lazy_specs, specs)
end

--- Load a lazy plugin: put it on 'runtimepath' (sourcing its `plugin/`
--- scripts), then run `config` once. Subsequent calls are no-ops.
function M.load(name, config)
  if loaded[name] then
    return
  end
  loaded[name] = true
  vim.cmd.packadd(name)
  if config then
    config()
  end
end

--- Load a lazy plugin the first time `event` fires (optional `pattern`,
--- e.g. `"FileType"` + `"lua"`).
function M.load_on(event, name, config, pattern)
  vim.api.nvim_create_autocmd(event, {
    pattern = pattern,
    once = true,
    group = vim.api.nvim_create_augroup("pack_load_" .. name, { clear = true }),
    callback = function()
      M.load(name, config)
    end,
  })
end

--- Wrap `fn` so that lazy plugin `name` is loaded (running `config` once)
--- right before it runs. Use as keymap callback for lazy plugins.
function M.wrap(name, config, fn)
  return function(...)
    M.load(name, config)
    if fn then
      return fn(...)
    end
  end
end

--- Add all deferred lazy plugins. Call once after all plugin modules ran.
function M.finish()
  if #lazy_specs > 0 then
    vim.pack.add(lazy_specs, { confirm = false, load = function() end })
  end
end

return M
