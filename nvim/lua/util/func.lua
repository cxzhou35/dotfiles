-- selene: allow(global_usage)

local M = {}

function M.getWords()
  if vim.fn.getfsize(vim.fn.expand("%")) > 200000 then
    return ""
  end

  if vim.fn.wordcount().visual_words == 1 then
    return "1 word"
  elseif not (vim.fn.wordcount().visual_words == nil) then
    return tostring(vim.fn.wordcount().visual_words) .. " words"
  else
    if vim.fn.wordcount().words == 1 then
      return "1 word"
    else
      return tostring(vim.fn.wordcount().words) .. " words"
    end
  end
end

return M
