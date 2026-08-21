local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4

opt.mouse = "a"
opt.clipboard = "unnamedplus"

opt.ignorecase = true
opt.smartcase = true


opt.scrolloff = 8

opt.termguicolors = true

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,
        })
    end,
})
