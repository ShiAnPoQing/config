vim.bo.textwidth = "80"
vim.bo.formatoptions = "tcqjn"
vim.wo[0][0].colorcolumn = "81"
vim.wo[0][0].concealcursor = ""
vim.wo[0][0].spell = false

require("native-packer.key").add({
  ["cem"] = {
    "<Plug>(vimtex-delim-delete)",
    "n",
    buf = 0,
  },
  ["wc"] = {
    "<Plug>(vimtex-ac)",
    { "x", "o" },
    buf = 0,
  },
  ["ec"] = {
    "<Plug>(vimtex-ic)",
    { "x", "o" },
    buf = 0,
  },
  ["wd"] = {
    "<Plug>(vimtex-ad)",
    { "x", "o" },
    buf = 0,
  },
  ["ed"] = {
    "<Plug>(vimtex-id)",
    { "x", "o" },
    buf = 0,
  },
  ["we"] = {
    "<Plug>(vimtex-ae)",
    { "x", "o" },
    buf = 0,
  },
  ["ee"] = {
    "<Plug>(vimtex-ie)",
    { "x", "o" },
    buf = 0,
  },
  ["w$"] = {
    "<Plug>(vimtex-a$)",
    { "x", "o" },
    buf = 0,
  },
  ["e$"] = {
    "<Plug>(vimtex-i$)",
    { "x", "o" },
    buf = 0,
  },
  ["wP"] = {
    "<Plug>(vimtex-aP)",
    { "x", "o" },
    buf = 0,
  },
  ["eP"] = {
    "<Plug>(vimtex-iP)",
    { "x", "o" },
    buf = 0,
  },
  ["<localleader>lt"] = {
    function()
      return require("vimtex.fzf-lua").run()
    end,
    "n",
    buf = 0,
  },
  ["<localleader>k"] = {
    "<Plug>(vimtex-doc-package)",
    "n",
    buf = 0,
  },
})
vim.keymap.set("n", "<localleader>cse", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local Client = vim.lsp.get_clients({
    bufnr = bufnr,
  })[1]

  if not Client then
    return
  end

  Client:exec_cmd({
    title = "Change Environment",
    command = "texlab.findEnvironments",
    arguments = {
      {
        textDocument = { uri = vim.uri_from_bufnr(0) },
        position = vim.api.nvim_win_get_cursor(0),
      },
    },
  }, { bufnr = bufnr }, function(err, result, ctx)
    if err or #result == 0 then
      return
    end
    local r = result[#result]

    vim.ui.input({
      prompt = "Change Environment Name: ",
      default = r.name.text or "",
    }, function(input)
      if input == nil then
        return
      end

      Client:exec_cmd({
        title = "Change Environment",
        command = "texlab.changeEnvironment",
        arguments = {
          {
            textDocument = { uri = vim.uri_from_bufnr(0) },
            position = vim.api.nvim_win_get_cursor(0),
            newName = input,
          },
        },
      })
    end)
  end)
end, { buf = 0 })
