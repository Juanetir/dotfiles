local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    error("lazy.nvim is not installed")
end

vim.opt.rtp:prepend(lazypath)

return {
    require("config.options"),
    require("config.keymaps"),
    require("config.lsp"),
    require("lazy").setup("plugins"),

}
