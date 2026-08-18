-- PHP language server. The licence key is stored encrypted in the dev repo and
-- written here by `dev-secrets unlock`.
local function get_license()
  local path = os.getenv("HOME") .. "/intelephense/license.txt"

  -- Deliberately not assert(io.open(...)): on a machine where secrets have not
  -- been unlocked yet the file is absent, and throwing here takes the whole
  -- lsp config down instead of just losing the premium features.
  local f = io.open(path, "rb")
  if not f then
    return nil
  end

  local content = f:read("*a")
  f:close()

  local key = content:gsub("%s+", "")
  return key ~= "" and key or nil
end

return {
  cmd = { "intelephense", "--stdio" },
  filetypes = { "php", "twig" },
  root_markers = { "composer.json", ".git" },
  init_options = {
    -- nil is fine: intelephense simply runs unlicensed.
    licenceKey = get_license(),
  },
}
