-- vim.pack has no `build` step like lazy.nvim, so we hook PackChanged to build
-- markdown-preview.nvim on install/update. mkdp#util#install() downloads a
-- standalone prebuilt preview server, so node/yarn are NOT required at runtime.
-- Registered BEFORE vim.pack.add so it fires on the initial install.
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("markdown-preview-build", { clear = true }),
	callback = function(ev)
		local spec = (ev.data or {}).spec or {}
		local is_mkdp = spec.name == "markdown-preview.nvim"
			or (spec.src and spec.src:find("markdown-preview.nvim", 1, true) ~= nil)
		if is_mkdp and ev.data.kind ~= "delete" then
			-- Defer so the plugin is fully on the runtimepath before we call its autoload fn.
			vim.schedule(function()
				local ok = pcall(vim.fn["mkdp#util#install"])
				if not ok then
					vim.notify(
						"markdown-preview: build failed, run :call mkdp#util#install() manually",
						vim.log.levels.WARN
					)
				end
			end)
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/iamcco/markdown-preview.nvim" },
})

-- In-editor markdown rendering (headings, tables, code blocks, checkboxes, etc.).
-- Uses the treesitter `markdown`/`markdown_inline` parsers (installed in
-- plugins/code-writing.lua) and nvim-web-devicons (installed in plugins/ui.lua).
require("render-markdown").setup({
	-- Render in normal mode + while editing; only the cursor line shows raw markup.
	render_modes = { "n", "c", "t" },
	completions = { lsp = { enabled = true } },
})

-- Toggle in-editor rendering on/off (e.g. to view raw markdown source).
vim.keymap.set("n", "<leader>mt", "<cmd>RenderMarkdown toggle<cr>", { desc = "[M]arkdown [T]oggle render" })

-- markdown-preview.nvim: live, scroll-synced preview in the browser
-- (Mermaid diagrams, KaTeX math, charts, etc.).
vim.g.mkdp_auto_start = 0 -- don't auto-open the browser when entering a markdown buffer
vim.g.mkdp_auto_close = 1 -- close the preview tab when leaving the markdown buffer
vim.g.mkdp_theme = "dark" -- 'dark' or 'light'
-- vim.g.mkdp_browser = "firefox"  -- uncomment to force a specific browser

vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "[M]arkdown [P]review (browser)" })
