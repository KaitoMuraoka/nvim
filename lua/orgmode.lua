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

-- 時間差を計算（分単位の数値を返す）
local function calc_duration_minutes(start_time, end_time)
  local start_pattern = "%[(%d+)-(%d+)-(%d+) %w+ (%d+):(%d+)%]"
  local sy, sm, sd, sh, smin = start_time:match(start_pattern)
  local ey, em, ed, eh, emin = end_time:match(start_pattern)

  if not (sy and ey) then
    return 0
  end

  local start_ts = os.time({year=sy, month=sm, day=sd, hour=sh, min=smin})
  local end_ts = os.time({year=ey, month=em, day=ed, hour=eh, min=emin})

  return math.floor((end_ts - start_ts) / 60)
end

-- 分を時間:分の形式に変換
local function format_minutes(total_minutes)
  local hours = math.floor(total_minutes / 60)
  local minutes = total_minutes % 60
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

-- LOGBOOKにメモを追加（複数行対応）
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

  -- 元のバッファとウィンドウを保存
  local origin_buf = vim.api.nvim_get_current_buf()
  local origin_win = vim.api.nvim_get_current_win()

  -- 新しいバッファを作成
  local note_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(note_buf, "buftype", "acwrite")
  vim.api.nvim_buf_set_option(note_buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_name(note_buf, "LOGBOOK Note")

  -- 初期メッセージを設定
  vim.api.nvim_buf_set_lines(note_buf, 0, -1, false, {
    "# Write your note here (multiple lines supported)",
    "# Save and quit (:wq or :x) to add to LOGBOOK",
    "# Quit without saving (:q!) to cancel",
    "",
  })

  -- 新しいウィンドウでバッファを開く
  vim.cmd("split")
  local note_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(note_win, note_buf)
  vim.api.nvim_win_set_height(note_win, 10)

  -- カーソルを編集開始位置に移動
  vim.api.nvim_win_set_cursor(note_win, { 4, 0 })

  -- 保存時の処理
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = note_buf,
    callback = function()
      -- バッファの内容を取得（コメント行を除く）
      local lines = vim.api.nvim_buf_get_lines(note_buf, 0, -1, false)
      local content_lines = {}

      for _, l in ipairs(lines) do
        if not l:match("^#") and l ~= "" then
          table.insert(content_lines, l)
        end
      end

      -- 内容が空でない場合のみLOGBOOKに追加
      if #content_lines > 0 then
        local timestamp = get_timestamp()
        local note_lines = {}

        -- 最初の行にタイムスタンプを追加
        if #content_lines == 1 then
          table.insert(note_lines, string.format("   - %s %s", content_lines[1], timestamp))
        else
          -- 複数行の場合
          table.insert(note_lines, string.format("   - %s %s", content_lines[1], timestamp))
          for i = 2, #content_lines do
            table.insert(note_lines, "     " .. content_lines[i])
          end
        end

        -- 元のバッファに戻ってLOGBOOKに追加
        vim.api.nvim_set_current_win(origin_win)
        vim.api.nvim_buf_set_lines(origin_buf, logbook.start_line, logbook.start_line, false, note_lines)

        vim.notify("Note added to LOGBOOK", vim.log.levels.INFO)
      end

      -- バッファを閉じる
      vim.cmd("quit!")
    end,
  })
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

-- ファイル全体のCLOCK時間を計算してレポート表示
M.show_clock_report = function()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  local total_minutes = 0
  local clock_entries = {}
  local current_heading = "Unknown"

  -- 全ての行をスキャン
  for i, line in ipairs(lines) do
    -- 見出しを追跡
    local heading = line:match("^%*+ (.+)$")
    if heading then
      current_heading = heading
    end

    -- 完了したCLOCKエントリを探す（=>を含む）
    local clock_match = line:match("^%s*CLOCK: (%[.-%])%-%-(%[.-%])%s*=>%s*(.+)$")
    if clock_match then
      local start_time, end_time, duration = line:match("^%s*CLOCK: (%[.-%])%-%-(%[.-%])%s*=>%s*(.+)$")
      if start_time and end_time then
        local minutes = calc_duration_minutes(start_time, end_time)
        total_minutes = total_minutes + minutes

        table.insert(clock_entries, {
          heading = current_heading,
          start_time = start_time,
          end_time = end_time,
          duration = duration,
          minutes = minutes
        })
      end
    end
  end

  -- レポートを生成
  local report = {}
  table.insert(report, "")
  table.insert(report, "=== CLOCK Report ===")
  table.insert(report, "")

  if #clock_entries == 0 then
    table.insert(report, "No completed clock entries found.")
  else
    table.insert(report, string.format("Total entries: %d", #clock_entries))
    table.insert(report, string.format("Total time: %s", format_minutes(total_minutes)))
    table.insert(report, "")
    table.insert(report, "Details:")
    table.insert(report, string.rep("-", 60))

    for _, entry in ipairs(clock_entries) do
      table.insert(report, string.format("• %s", entry.heading))
      table.insert(report, string.format("  %s -- %s  =>  %s",
        entry.start_time, entry.end_time, entry.duration))
    end

    table.insert(report, string.rep("-", 60))
    table.insert(report, string.format("TOTAL: %s", format_minutes(total_minutes)))
  end

  table.insert(report, "")
  table.insert(report, "Press q to close")

  -- 新しいバッファを作成して表示
  local report_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(report_buf, 0, -1, false, report)
  vim.api.nvim_buf_set_option(report_buf, "modifiable", false)
  vim.api.nvim_buf_set_option(report_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(report_buf, "bufhidden", "wipe")

  -- 新しいウィンドウで開く
  vim.cmd("split")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, report_buf)

  -- qで閉じられるようにする
  vim.api.nvim_buf_set_keymap(report_buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
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

      -- CLOCK report
      vim.keymap.set("n", "<leader>or", M.show_clock_report, vim.tbl_extend("force", opts, { desc = "Show CLOCK report" }))

      -- 見出しのレベル変更
      vim.keymap.set("n", "<M-Left>", M.promote_heading, vim.tbl_extend("force", opts, { desc = "Promote heading" }))
      vim.keymap.set("n", "<M-Right>", M.demote_heading, vim.tbl_extend("force", opts, { desc = "Demote heading" }))

      -- 折りたたみのキーマップ
      vim.keymap.set("n", "<Tab>", "za", vim.tbl_extend("force", opts, { desc = "Toggle fold" }))
      vim.keymap.set("n", "<S-Tab>", "zA", vim.tbl_extend("force", opts, { desc = "Toggle all folds" }))

      -- コマンドを作成
      vim.api.nvim_buf_create_user_command(0, "OrgClockReport", M.show_clock_report, { desc = "Show CLOCK time report" })
    end,
  })
end

return M
