return {
  {
    "<leader>cp",
    function()
      require("fzf-lua").complete_path()
    end,
    desc = "Complete Path",
  },
  {
    "<leader>cf",
    function()
      require("fzf-lua").complete_file()
    end,
    desc = "Complete File",
  },
}
