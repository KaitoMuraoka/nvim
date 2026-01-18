#!/bin/bash
# Org-mode 初期セットアップスクリプト
# 使い方: bash ~/.config/nvim/docs/setup-org.sh

set -e

ORG_DIR="$HOME/org"

echo "=== Org-mode セットアップ ==="

# ディレクトリ作成
echo "ディレクトリを作成中..."
mkdir -p "$ORG_DIR"

# main.org (個人用)
if [ ! -f "$ORG_DIR/main.org" ]; then
  echo "main.org を作成中..."
  cat > "$ORG_DIR/main.org" << 'EOF'
#+TITLE: Personal
#+STARTUP: overview

* Tasks

* Notes

* Journal
EOF
  echo "  作成: $ORG_DIR/main.org"
else
  echo "  スキップ: main.org は既に存在します"
fi

# work.org (仕事用)
if [ ! -f "$ORG_DIR/work.org" ]; then
  echo "work.org を作成中..."
  cat > "$ORG_DIR/work.org" << 'EOF'
#+TITLE: Work
#+STARTUP: overview

* Tasks

* Notes

* Meetings
EOF
  echo "  作成: $ORG_DIR/work.org"
else
  echo "  スキップ: work.org は既に存在します"
fi

echo ""
echo "=== セットアップ完了 ==="
echo ""
echo "ファイル構成:"
echo "  $ORG_DIR/"
echo "  ├── main.org  (個人用)"
echo "  └── work.org  (仕事用)"
echo ""
echo "次のステップ:"
echo "  1. Neovimを起動"
echo "  2. <leader>oa でアジェンダを確認"
echo "  3. <leader>oc でキャプチャを試す"
echo ""
echo "ドキュメント:"
echo "  nvim ~/.config/nvim/docs/org-mode-guide.org"
echo "  nvim ~/.config/nvim/docs/how-to-use-work.org"
