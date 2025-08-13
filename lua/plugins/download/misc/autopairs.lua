return {
  "windwp/nvim-autopairs",
  lazy = true,
  event = "InsertEnter",
  config = function()
    require("nvim-autopairs").setup({
      -- check_ts = true,
      -- ts_config = {
      --   lua = { "string" }
      -- }
    })
  end,
}
