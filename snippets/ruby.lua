-- Ruby スニペット
--
-- ruby-lsp は RBS の `def self?.foo` 宣言(kind == :singleton_instance)を
-- 特異メソッドとしてしかインデックスしないため(rbs_indexer.rb の real_owner 判定)、
-- Kernel#gets / Kernel#puts などのインスタンスメソッドが補完候補に一切出ない。
-- ここで欠落分を補う。

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmta

local snippets = {}

-- ruby-lsp が取りこぼす Kernel メソッド。
-- { trigger, 展開テキスト, 説明 } の形で、`<>` がプレースホルダになる。
local kernel_methods = {
  { "gets", "gets", "1行読み込む" },
  { "puts", "puts <>", "改行付き出力" },
  { "print", "print <>", "改行なし出力" },
  { "p", "p <>", "inspect 出力" },
  { "pp", "pp <>", "pretty print" },
  { "printf", 'printf("<>", <>)', "書式付き出力" },
  { "format", 'format("<>", <>)', "書式付き文字列" },
  { "require", 'require "<>"', "ライブラリ読み込み" },
  { "require_relative", 'require_relative "<>"', "相対パス読み込み" },
  { "load", 'load "<>"', "ファイル読み込み" },
  { "loop", "loop do\n\t<>\nend", "無限ループ" },
  { "rand", "rand(<>)", "乱数" },
  { "srand", "srand(<>)", "乱数シード" },
  { "sleep", "sleep <>", "スリープ" },
  { "abort", 'abort "<>"', "異常終了" },
  { "exit", "exit <>", "終了" },
  { "warn", 'warn "<>"', "stderr へ出力" },
  { "catch", "catch(:<>) do\n\t<>\nend", "catch ブロック" },
  { "throw", "throw :<>", "throw" },
  { "lambda", "lambda { |<>| <> }", "ラムダ" },
  { "proc", "proc { |<>| <> }", "Proc" },
  { "block_given?", "block_given?", "ブロック有無" },
  { "readline", "readline", "1行読み込み(EOF で例外)" },
  { "readlines", "readlines", "全行読み込み" },
  { "at_exit", "at_exit do\n\t<>\nend", "終了時フック" },
  { "caller", "caller", "コールスタック" },
  { "__method__", "__method__", "現在のメソッド名" },
  { "__dir__", "__dir__", "現在のディレクトリ" },
}

for _, m in ipairs(kernel_methods) do
  local trigger, body, desc = m[1], m[2], m[3]
  -- プレースホルダ `<>` の個数だけ insert_node を用意する
  local nodes = {}
  for n = 1, select(2, body:gsub("<>", "")) do
    nodes[n] = i(n)
  end

  if #nodes == 0 then
    snippets[#snippets + 1] = s({ trig = trigger, desc = desc }, t(body))
  else
    snippets[#snippets + 1] = s({ trig = trigger, desc = desc }, fmt(body, nodes))
  end
end

-- AtCoder 定番の入力パターン
local atcoder = {
  { "gsc", "gets.chomp", "文字列を1行" },
  { "gi", "gets.to_i", "整数を1つ" },
  { "gf", "gets.to_f", "浮動小数点を1つ" },
  { "gsa", "gets.split", "空白区切りの文字列配列" },
  { "gia", "gets.split.map(&:to_i)", "空白区切りの整数配列" },
  { "gch", "gets.chomp.chars", "1文字ずつの配列" },
  { "gn", "n = gets.to_i", "n を読む" },
  { "gab", "a, b = gets.split.map(&:to_i)", "2整数を読む" },
  { "gnl", "n = gets.to_i\na = Array.new(n) { gets.to_i }", "n 行の整数" },
  { "gnla", "n = gets.to_i\na = Array.new(n) { gets.split.map(&:to_i) }", "n 行の整数配列" },
  { "readall", '$stdin.read.split("\\n")', "全入力を一括読み込み" },
}

for _, a in ipairs(atcoder) do
  local trigger, body, desc = a[1], a[2], a[3]
  local lines = vim.split(body, "\n", { plain = true })
  snippets[#snippets + 1] = s({ trig = trigger, desc = desc }, t(lines))
end

return snippets
