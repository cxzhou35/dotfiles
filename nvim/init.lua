if vim.loader then
  vim.loader.enable()
end

-- load debug module
_G.dd = function(...)
  require("util.debug").dump(...)
end
vim.print = _G.dd

require("config.lazy")
