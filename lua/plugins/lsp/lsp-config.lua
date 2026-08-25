return {
	-- LSP設定
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			opts = {
				ensure_installed = { "stylua", "codelldb", "goimports", "shfmt", "shellcheck" },
			},
		},
	},
	config = function()
		require("mason").setup()

		-- blink.cmp の拡張 capabilities (ドキュメント解決・insertReplace 等) を全サーバに配る
		local capabilities = require("blink.cmp").get_lsp_capabilities()
		local LSP = vim.lsp

		-- 診断表示 (VSCode の Problems 相当の見た目に寄せる)
		vim.diagnostic.config({
			virtual_text = { prefix = "●", spacing = 2, source = "if_many" },
			severity_sort = true,
			update_in_insert = false,
			float = { border = "rounded", source = "if_many" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
			},
		})

		-- デフォルトのLSP設定（全サーバーに適用）
		LSP.config("*", {
			capabilities = capabilities,
		})

		-- lua_ls 個別設定
		LSP.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
					hint = { enable = true },
				},
			},
		})

		-- bashls 個別設定
		LSP.config("bashls", {
			filetypes = { "sh", "bash" },
			settings = {
				bashIde = {
					shellcheckPath = vim.fn.exepath("shellcheck"),
				},
			},
		})

		-- sourcekit-lsp for Swift (Masonでは管理不可、Xcode同梱)
		LSP.config("sourcekit", {
			capabilities = {
				workspace = {
					didChangeWatchedFiles = {
						dynamicRegistration = true,
					},
				},
			},
			cmd = { "sourcekit-lsp" },
			filetypes = { "swift", "objc", "objcpp" },
			root_markers = {
				"buildServer.json",
				"*.xcodeproj",
				"*.xcworkspace",
				"Package.swift",
				".git",
			},
		})

		-- ts_ls 個別設定（Biome採用リポジトリではフォーマットをBiome側に一本化）
		-- 自動import候補・引数付きの関数補完・inlay hints を VSCode 相当まで引き上げる
		local ts_inlay_hints = {
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = false,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		}
		LSP.config("ts_ls", {
			init_options = {
				preferences = {
					-- 未importのシンボルも候補に出し、確定時にimport行を追加する
					includeCompletionsForModuleExports = true,
					includeCompletionsWithSnippetText = true,
					importModuleSpecifierPreference = "shortest",
				},
			},
			settings = {
				completions = { completeFunctionCalls = true },
				typescript = { inlayHints = ts_inlay_hints },
				javascript = { inlayHints = ts_inlay_hints },
			},
			on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
			end,
		})

		-- cssls: Tailwind の @tailwind / @apply を未知のat-ruleとして診断させない
		LSP.config("cssls", {
			settings = {
				css = { lint = { unknownAtRules = "ignore" } },
				scss = { lint = { unknownAtRules = "ignore" } },
				less = { lint = { unknownAtRules = "ignore" } },
			},
		})

		-- tailwindcss: lspconfig 既定の root_dir は Tailwind v4 向けに `.git` を
		-- フォールバックに含むため、Tailwind 非採用のリポジトリでも起動してしまう。
		-- 実際に Tailwind を使っている印 (設定ファイル / package.json / Gemfile.lock) を
		-- 見つけた時だけ起動するよう root_dir を絞る。
		LSP.config("tailwindcss", {
			root_dir = function(bufnr, on_dir)
				local util = require("lspconfig.util")
				local root_files = {
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.mjs",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.cjs",
					"postcss.config.mjs",
					"postcss.config.ts",
				}
				local fname = vim.api.nvim_buf_get_name(bufnr)
				root_files = util.insert_package_json(root_files, "tailwindcss", fname)
				root_files = util.root_markers_with_field(root_files, { "mix.lock", "Gemfile.lock" }, "tailwind", fname)
				local found = vim.fs.find(root_files, { path = fname, upward = true })[1]
				if found then
					on_dir(vim.fs.dirname(found))
				end
			end,
		})

		-- herb-language-server は ERB の HTML 構造を解析する。
		-- html filetype では vscode-html-language-server と役割が重複するため eruby のみに絞る
		-- (Ruby 側の補完・診断は ruby_lsp が担当する)
		LSP.config("herb_ls", {
			filetypes = { "eruby" },
		})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"pyright",
				"html",
				"cssls",
				"emmet_ls",
				"tailwindcss",
				"herb_ls",
				"prismals",
				"kotlin_language_server",
				"jdtls",
				"gopls",
				"bashls",
				"biome",
			},
			automatic_enable = {
				exclude = { "stylua" },
			},
		})

		-- sourcekit は Mason 管理外なので手動で有効化
		LSP.enable("sourcekit")

		-- ruby-lsp (Masonでは管理せず gem install したグローバル版を使う / rbenv shim経由)
		-- Railsアプリを検出すると ruby-lsp-rails アドオンを composed bundle に自動追加し、
		-- モデルのカラム/アソシエーション補完・実行時イントロスペクションを提供する。
		LSP.config("ruby_lsp", {
			init_options = {
				-- プロジェクトに rubocop があれば自動採用、無ければ無効化（補完は常に動作）
				formatter = "auto",
			},
			filetypes = { "ruby", "eruby" },
		})
		LSP.enable("ruby_lsp")

		-- solargraph は「補完専用」の補助として ruby-lsp と併用する。
		-- ruby-lsp の TypeInferrer はレシーバがリテラル/定数/Klass.new の時しか型を
		-- 解決できず(それ以外は変数名を CamelCase 化して同名定数を探すだけ)、
		-- gets.to_i のようなメソッドチェーンや Kernel#gets 自体が補完できない。
		-- solargraph は YARD の core ドキュメントから戻り値型を知っているため補える。
		-- 診断・定義ジャンプ・フォーマット等は ruby-lsp 側に一本化して衝突を避ける。
		-- (Masonでは管理せず gem install したグローバル版を使う / rbenv shim経由)
		LSP.config("solargraph", {
			settings = {
				solargraph = {
					diagnostics = false,
					formatting = false,
					useBundler = false,
				},
			},
			on_attach = function(client)
				for _, cap in ipairs({
					"definitionProvider",
					"documentFormattingProvider",
					"documentRangeFormattingProvider",
					"documentSymbolProvider",
					"hoverProvider",
					"referencesProvider",
					"renameProvider",
					"signatureHelpProvider",
				}) do
					client.server_capabilities[cap] = nil
				end
			end,
		})
		LSP.enable("solargraph")

		-- rust_analyzer は rustaceanvim が起動・設定するため、ここでは何もしない
		-- (両方から有効化すると rust-analyzer が二重に立ち上がる)

		-- LSPキーマップ
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local buf = args.buf
				local keymap = vim.keymap
				local client = LSP.get_client_by_id(args.data.client_id)

				-- 型・引数名のインライン表示 (JetBrains の inlay hints 相当)
				if client and client:supports_method("textDocument/inlayHint") then
					LSP.inlay_hint.enable(true, { bufnr = buf })
				end

				keymap.set("n", "gd", LSP.buf.definition, { buffer = buf, desc = "Go to definition" })
				keymap.set("n", "K", LSP.buf.hover, { buffer = buf, desc = "Hover" })
				keymap.set("n", "<leader>rn", LSP.buf.rename, { buffer = buf, desc = "Rename" })
				keymap.set("n", "<leader>ca", LSP.buf.code_action, { buffer = buf, desc = "Code action" })
				keymap.set("n", "gr", LSP.buf.references, { buffer = buf, desc = "References" })
				keymap.set("n", "<leader>uh", function()
					local enabled = LSP.inlay_hint.is_enabled({ bufnr = buf })
					LSP.inlay_hint.enable(not enabled, { bufnr = buf })
				end, { buffer = buf, desc = "Toggle inlay hints" })

				-- ts_ls のファイル単位コードアクション (import整理・未使用コード削除)
				-- lspconfig が定義する :LspTypescriptSourceAction を呼ぶ
				if client and client.name == "ts_ls" then
					keymap.set("n", "<leader>co", "<cmd>LspTypescriptSourceAction<cr>", {
						buffer = buf,
						desc = "Organize imports / source action",
					})
				end

				keymap.set("n", "<leader>e", vim.diagnostic.open_float, { buffer = buf, desc = "Diagnostics" })
				keymap.set("n", "<leader>ey", function()
					local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
					if #diagnostics == 0 then
						vim.notify("No diagnostics on this line", vim.log.levels.INFO)
						return
					end
					local messages = {}
					for _, d in ipairs(diagnostics) do
						table.insert(messages, d.message)
					end
					vim.fn.setreg("+", table.concat(messages, "\n"))
					vim.notify("Diagnostic copied to clipboard", vim.log.levels.INFO)
				end, { buffer = buf, desc = "Copy diagnostic" })
			end,
		})
	end,
}
