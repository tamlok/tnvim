local M = {}

function M.config()
  local g = vim.g
  local fn = vim.fn

  local plugins_count = fn.len(vim.fn.globpath(fn.stdpath "data" .. "/site/pack/packer/start", "*", 0, 1))

  g.dashboard_default_executive = "Leaderf"
  g.dashboard_custom_header = {
    "  ●   ●",
    "  █   █",
    "   █   █",
    "   █   █",
    "   ███            █████ 　　　",
    " █▒░░█         ██▓▒▒▓██ ☆",
    "█▒░●░░█    ██▓▒██▓▒▒▓█　　 ★",
    "█░█▒░░██  ██▓▒██▓▒░▒▓█",
    " ██▒░░██ ██▓▒░██▓▒░▒▓█ 　　　★",
    "    █▒░██ ██▓▒░░ ████▓█",
    "   █▒░██  ██▓▓▒▒░░░██ 　 ★★",
    "    █▒░██   ████████████",
    "     █▒░█▒▒▒▒▒▒▒▒▒▒▒▒█",
    "      ██████████████████.•°*”˜҈.•°*”˜҈.",
  }

  g.dashboard_custom_section = {
    a = { description = { "     Find File" }, command = "Telescope find_files" },
    b = { description = { "       Recents" }, command = "Telescope oldfiles" },
    c = { description = { "      New File" }, command = "DashboardNewFile" },
    e = { description = { "  Last Session" }, command = "SessionLoad" },
  }

  g.dashboard_custom_footer = {
    "Enjoy NeoVim, Enjoy Coding",
    "Loaded " .. plugins_count .. " plugins .",
  }
end

return M
