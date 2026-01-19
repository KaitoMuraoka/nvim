local M = {}

-- TODO/DONEの状態を切り替える
M.toggle_todo = function()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local new_line

  if line:match("^%*+ TODO ") then
    -- TODO -> DONE
    new_line = line:gsub("^(%*+) TODO ", "%1 DONE ")
  elseif line:match("^%*+ DONE ") then
    -- DONE -> (状態なし)
    new_line = line:gsub("^(%*+) DONE ", "%1 ")
  elseif line:match("^%*+ ") then
    -- 状態なし -> TODO
    new_line = line:gsub("^(%*+ )", "%1TODO ")
  else
    -- 見出しでない場合は何もしない
    return
  end

  vim.api.nvim_set_current_line(new_line)
  vim.api.nvim_win_set_cursor(0, cursor_pos)
end

-- 新しいTODOアイテムを挿入
M.insert_todo = function()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local level = 1

  -- 現在の行が見出しの場合、そのレベルを取得
  local stars = line:match("^(%*+) ")
  if stars then
    level = #stars
  end

  -- 新しい行を挿入
  local new_line = string.rep("*", level) .. " TODO "
  vim.api.nvim_buf_set_lines(0, cursor_pos[1], cursor_pos[1], false, { new_line })
  vim.api.nvim_win_set_cursor(0, { cursor_pos[1] + 1, #new_line })
  vim.cmd("startinsert!")
end

-- 見出しレベルを上げる（インデント）
M.promote_heading = function()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  if line:match("^%*%* ") then
    local new_line = line:gsub("^%*", "", 1)
    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end
end

-- 見出しレベルを下げる（デミート）
M.demote_heading = function()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  if line:match("^%* ") then
    local new_line = "*" .. line
    vim.api.nvim_set_current_line(new_line)
    vim.api.nvim_win_set_cursor(0, { cursor_pos[1], cursor_pos[2] + 1 })
  end
end

-- 見出しを折りたたむ設定
M.setup_folding = function()
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.orgmode_fold_level(v:lnum)"
  vim.opt_local.foldtext = "v:lua.orgmode_fold_text()"
end

-- 折りたたみレベルを計算
function _G.orgmode_fold_level(lnum)
  local line = vim.fn.getline(lnum)
  local stars = line:match("^(%*+) ")

  if stars then
    return ">" .. #stars
  end

  return "="
end

-- 折りたたみテキストをカスタマイズ
function _G.orgmode_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local folded_lines = vim.v.foldend - vim.v.foldstart
  return line .. " ... (" .. folded_lines .. " lines)"
end

-- org-modeのセットアップ
M.setup = function()
  -- autocommandでorg fileを開いた時の設定
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "org",
    callback = function()
      -- 折りたたみ設定
      M.setup_folding()

      -- キーマッピング
      local opts = { buffer = true, silent = true }

      -- TODO状態の切り替え
      vim.keymap.set("n", "<leader>ot", M.toggle_todo, vim.tbl_extend("force", opts, { desc = "Toggle TODO/DONE" }))

      -- 新しいTODOアイテムを挿入
      vim.keymap.set("n", "<leader>oi", M.insert_todo, vim.tbl_extend("force", opts, { desc = "Insert TODO item" }))

      -- 見出しのレベル変更
      vim.keymap.set("n", "<M-Left>", M.promote_heading, vim.tbl_extend("force", opts, { desc = "Promote heading" }))
      vim.keymap.set("n", "<M-Right>", M.demote_heading, vim.tbl_extend("force", opts, { desc = "Demote heading" }))

      -- 折りたたみのキーマップ
      vim.keymap.set("n", "<Tab>", "za", vim.tbl_extend("force", opts, { desc = "Toggle fold" }))
      vim.keymap.set("n", "<S-Tab>", "zA", vim.tbl_extend("force", opts, { desc = "Toggle all folds" }))
    end,
  })
end

return M
