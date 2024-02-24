local status, lualine = pcall(require, "lualine")
if not status then
  return
end

lualine.setup({
	sections = {
		lualine_x = { "encoding", { "fileformat", symbols = { unix = "" } }, "filetype" },
	},
})
