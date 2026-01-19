" Org-mode syntax highlighting
if exists("b:current_syntax")
  finish
endif

" 見出し (Headings)
syntax match orgHeading1 "^\* .*$"
syntax match orgHeading2 "^\*\* .*$"
syntax match orgHeading3 "^\*\*\* .*$"
syntax match orgHeading4 "^\*\*\*\* .*$"
syntax match orgHeading5 "^\*\*\*\*\* .*$"
syntax match orgHeading6 "^\*\*\*\*\*\* .*$"

" TODO キーワード
syntax match orgTodo "\<TODO\>" contained
syntax match orgDoing "\<DOING\>" contained
syntax match orgDone "\<DONE\>" contained

" 見出し内のTODO/DOING/DONEをハイライト
syntax match orgHeadingTodo "^\*\+ TODO .*$" contains=orgTodo,orgHeading1,orgHeading2,orgHeading3,orgHeading4,orgHeading5,orgHeading6
syntax match orgHeadingDoing "^\*\+ DOING .*$" contains=orgDoing,orgHeading1,orgHeading2,orgHeading3,orgHeading4,orgHeading5,orgHeading6
syntax match orgHeadingDone "^\*\+ DONE .*$" contains=orgDone,orgHeading1,orgHeading2,orgHeading3,orgHeading4,orgHeading5,orgHeading6

" リスト
syntax match orgListBullet "^\s*[-+*] "

" 太字とイタリック
syntax region orgBold start="\*" end="\*" oneline
syntax region orgItalic start="/" end="/" oneline
syntax region orgUnderline start="_" end="_" oneline

" コード
syntax region orgCode start="=" end="=" oneline
syntax region orgVerbatim start="\~" end="\~" oneline

" リンク
syntax region orgLink start="\[\[" end="\]\]"

" 日付
syntax match orgDate "\[\d\{4\}-\d\{2\}-\d\{2\}.*\]"

" タグ
syntax match orgTag ":\w\+:" contained
syntax match orgHeadingTags ":\w\+:\(\w\+:\)*\s*$" contains=orgTag

" LOGBOOK
syntax match orgDrawer "^\s*:\(LOGBOOK\|PROPERTIES\|END\):\s*$"
syntax match orgClock "^\s*CLOCK:.*$" contains=orgDate
syntax match orgLogbookNote "^\s*- .*\[\d\{4\}-\d\{2\}-\d\{2\}.*\]$" contains=orgDate

" ハイライト設定
highlight default link orgHeading1 Title
highlight default link orgHeading2 Title
highlight default link orgHeading3 Title
highlight default link orgHeading4 Title
highlight default link orgHeading5 Title
highlight default link orgHeading6 Title

highlight default link orgTodo Todo
highlight default orgDoing term=bold cterm=bold ctermfg=Yellow gui=bold guifg=Orange
highlight default link orgDone Comment

highlight default link orgListBullet Statement

highlight default orgBold term=bold cterm=bold gui=bold
highlight default orgItalic term=italic cterm=italic gui=italic
highlight default orgUnderline term=underline cterm=underline gui=underline

highlight default link orgCode String
highlight default link orgVerbatim String
highlight default link orgLink Underlined
highlight default link orgDate Special
highlight default link orgTag Label

highlight default link orgDrawer Comment
highlight default link orgClock Identifier
highlight default link orgLogbookNote Comment

let b:current_syntax = "org"
