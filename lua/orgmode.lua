local M = {}

-- TODO/DOING/DONEの状態を切り替える
M.toggle_todo = function()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local new_line

  if line:match("^%*+ TODO ") then
    -- TODO -> DOING
    new_line = line:gsub("^(%*+) TODO ", "%1 DOING ")
  elseif line:match("^%*+ DOING ") then
    -- DOING -> DONE
    new_line = line:gsub("^(%*+) DOING ", "%1 DONE ")
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

-- 現在のタイムスタンプを取得
local function get_timestamp()
  return os.date("[%Y-%m-%d %a %H:%M]")
end

-- 時間差を計算（分単位）
local function calc_duration(start_time, end_time)
  local start_pattern = "%[(%d+)-(%d+)-(%d+) %w+ (%d+):(%d+)%]"
  local sy, sm, sd, sh, smin = start_time:match(start_pattern)
  local ey, em, ed, eh, emin = end_time:match(start_pattern)

  if not (sy and ey) then
    return nil
  end

  local start_ts = os.time({year=sy, month=sm, day=sd, hour=sh, min=smin})
  local end_ts = os.time({year=ey, month=em, day=ed, hour=eh, min=emin})

  local diff_minutes = math.floor((end_ts - start_ts) / 60)
  local hours = math.floor(diff_minutes / 60)
  local minutes = diff_minutes % 60

  return string.format("%d:%02d", hours, minutes)
end

-- LOGBOOKセクションを探す、または作成する
local function find_or_create_logbook(line_num)
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- 現在の見出しのレベルを確認
  local heading_line = lines[line_num]
  local stars = heading_line:match("^(%*+) ")
  if not stars then
    return nil
  end

  -- 次の見出しを探す
  local next_heading = nil
  for i = line_num + 1, #lines do
    if lines[i]:match("^%*+ ") then
      next_heading = i
      break
    end
  end

  local search_end = next_heading or #lines + 1

  -- 既存のLOGBOOKを探す
  for i = line_num + 1, search_end - 1 do
    if lines[i]:match("^%s*:LOGBOOK:%s*$") then
      -- LOGBOOKの:END:を探す
      for j = i + 1, search_end - 1 do
        if lines[j]:match("^%s*:END:%s*$") then
          return { start_line = i, end_line = j, exists = true }
        end
      end
    end
  end

  -- LOGBOOKが存在しない場合、作成する
  local insert_line = line_num + 1
  vim.api.nvim_buf_set_lines(buf, insert_line, insert_line, false, { "   :LOGBOOK:", "   :END:" })

  return { start_line = insert_line + 1, end_line = insert_line + 2, exists = false }
end

-- Clock In: 作業開始
M.clock_in = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor_pos[1]
  local line = vim.api.nvim_get_current_line()

  -- 見出しでない場合は何もしない
  if not line:match("^%*+ ") then
    vim.notify("Clock in can only be used on a heading", vim.log.levels.WARN)
    return
  end

  local logbook = find_or_create_logbook(line_num)
  if not logbook then
    return
  end

  local timestamp = get_timestamp()
  local clock_entry = string.format("   CLOCK: %s", timestamp)

  -- LOGBOOKの最初の行（:LOGBOOK:の次）に挿入
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, logbook.start_line, logbook.start_line, false, { clock_entry })

  vim.notify("Clocked in at " .. timestamp, vim.log.levels.INFO)
end

-- Clock Out: 作業終了
M.clock_out = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor_pos[1]
  local line = vim.api.nvim_get_current_line()

  -- 見出しでない場合は何もしない
  if not line:match("^%*+ ") then
    vim.notify("Clock out can only be used on a heading", vim.log.levels.WARN)
    return
  end

  local logbook = find_or_create_logbook(line_num)
  if not logbook then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  -- 最新の未完了のCLOCKエントリを探す
  for i = logbook.start_line, logbook.end_line - 1 do
    local clock_line = lines[i]
    if clock_line:match("^%s*CLOCK: %[.-%]%s*$") then
      -- 終了時刻を追加
      local timestamp = get_timestamp()
      local start_time = clock_line:match("%[.-%]")
      local duration = calc_duration(start_time, timestamp)

      local updated_line
      if duration then
        updated_line = clock_line .. "--" .. timestamp .. " =>  " .. duration
      else
        updated_line = clock_line .. "--" .. timestamp
      end

      vim.api.nvim_buf_set_lines(buf, i, i + 1, false, { updated_line })
      vim.notify("Clocked out at " .. timestamp .. (duration and (" (Duration: " .. duration .. ")") or ""), vim.log.levels.INFO)
      return
    end
  end

  vim.notify("No active clock found", vim.log.levels.WARN)
end

-- LOGBOOKにメモを追加
M.add_logbook_note = function()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor_pos[1]
  local line = vim.api.nvim_get_current_line()

  -- 見出しでない場合は何もしない
  if not line:match("^%*+ ") then
    vim.notify("Logbook note can only be added to a heading", vim.log.levels.WARN)
    return
  end

  local logbook = find_or_create_logbook(line_num)
  if not logbook then
    return
  end

  -- メモの入力を求める
  vim.ui.input({ prompt = "Note: " }, function(input)
    if input and input ~= "" then
      local timestamp = get_timestamp()
      local note_line = string.format("   - %s %s", input, timestamp)

      local buf = vim.api.nvim_get_current_buf()
      vim.api.nvim_buf_set_lines(buf, logbook.start_line, logbook.start_line, false, { note_line })
      vim.notify("Note added to LOGBOOK", vim.log.levels.INFO)
    end
  end)
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
      vim.keymap.set("n", "<leader>ot", M.toggle_todo, vim.tbl_extend("force", opts, { desc = "Toggle TODO/DOING/DONE" }))

      -- 新しいTODOアイテムを挿入
      vim.keymap.set("n", "<leader>oi", M.insert_todo, vim.tbl_extend("force", opts, { desc = "Insert TODO item" }))

      -- Clock In/Out
      vim.keymap.set("n", "<leader>oI", M.clock_in, vim.tbl_extend("force", opts, { desc = "Clock in (start work)" }))
      vim.keymap.set("n", "<leader>oO", M.clock_out, vim.tbl_extend("force", opts, { desc = "Clock out (end work)" }))

      -- LOGBOOK note
      vim.keymap.set("n", "<leader>on", M.add_logbook_note, vim.tbl_extend("force", opts, { desc = "Add logbook note" }))

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
