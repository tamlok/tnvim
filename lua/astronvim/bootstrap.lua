--- ### AstroNvim Core Bootstrap
--
-- This module simply sets up the global `astronvim` module.
-- This is automatically loaded and should not be resourced, everything is accessible through the global `astronvim` variable.
--
-- @module astronvim.bootstrap
-- @copyright 2022
-- @license GNU General Public License v3.0

_G.astronvim = {}

--- installation details from external installers
astronvim.install = _G["astronvim_installation"] or { home = vim.fn.stdpath "config" }
astronvim.supported_configs = { astronvim.install.home }

--- Looks to see if a module path references a lua file in a configuration folder and tries to load it. If there is an error loading the file, write an error and continue
---@param module string The module path to try and load
---@return table|nil # The loaded module if successful or nil
local function load_module_file(module)
  -- placeholder for final return value
  local found_file = nil
  -- search through each of the supported configuration locations
  for _, config_path in ipairs(astronvim.supported_configs) do
    -- convert the module path to a file path (example user.init -> user/init.lua)
    local module_path = config_path .. "/lua/" .. module:gsub("%.", "/") .. ".lua"
    -- check if there is a readable file, if so, set it as found
    if vim.fn.filereadable(module_path) == 1 then found_file = module_path end
  end
  -- if we found a readable lua file, try to load it
  local out = nil
  if found_file then
    -- try to load the file
    local status_ok, loaded_module = pcall(require, module)
    -- if successful at loading, set the return variable
    if status_ok then
      out = loaded_module
    -- if unsuccessful, throw an error
    else
      vim.api.nvim_err_writeln("Error loading file: " .. found_file .. "\n\n" .. loaded_module)
    end
  end
  -- return the loaded module or nil if no file found
  return out
end

--- Main configuration engine logic for extending a default configuration table with either a function override or a table to merge into the default option
-- @param overrides the override definition, either a table or a function that takes a single parameter of the original table
-- @param default the default configuration table
-- @param extend boolean value to either extend the default or simply overwrite it if an override is provided
-- @return the new configuration table
local function func_or_extend(overrides, default, extend)
  -- if we want to extend the default with the provided override
  if extend then
    -- if the override is a table, use vim.tbl_deep_extend
    if type(overrides) == "table" then
      local opts = overrides or {}
      default = default and vim.tbl_deep_extend("force", default, opts) or opts
    -- if the override is  a function, call it with the default and overwrite default with the return value
    elseif type(overrides) == "function" then
      default = overrides(default)
    end
  -- if extend is set to false and we have a provided override, simply override the default
  elseif overrides ~= nil then
    default = overrides
  end
  -- return the modified default table
  return default
end

--- table of user created terminals
astronvim.user_terminals = {}
astronvim.lsp = { skip_setup = {}, progress = {} }
--- the default colorscheme to apply on startup
astronvim.default_colorscheme = "onenord"
astronvim.last_active_tab = 1
