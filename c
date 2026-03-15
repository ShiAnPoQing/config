--- Startup times for process: Embedded ---

times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.001  000.001: --- NVIM STARTING ---
000.079  000.078: event init
000.130  000.051: early init
000.154  000.023: locale set
000.180  000.026: init first window
000.398  000.218: inits 1
000.406  000.008: window checked
000.408  000.002: parsing arguments
000.764  000.031  000.031: require('vim._core.shared')
000.817  000.003  000.003: require('string.buffer')
000.837  000.035  000.032: require('vim.inspect')
000.870  000.027  000.027: require('vim._core.options')
000.874  000.108  000.047: require('vim._core.editor')
000.894  000.018  000.018: require('vim._core.system')
000.895  000.176  000.019: require('vim._init_packages')
000.896  000.311: init lua interpreter
000.937  000.042: expanding arguments
000.947  000.009: inits 2
001.151  000.205: init highlight
001.152  000.001: waiting for UI
001.226  000.074: done waiting for UI
001.234  000.008: clear screen
001.323  000.008  000.008: require('vim.keymap')
001.888  000.090  000.090: sourcing nvim_exec2()
002.110  000.874  000.776: require('vim._core.defaults')
002.112  000.004: init default mappings & autocommands
002.385  000.032  000.032: sourcing /usr/share/nvim/runtime/ftplugin.vim
002.427  000.019  000.019: sourcing /usr/share/nvim/runtime/indent.vim
002.461  000.007  000.007: sourcing /usr/share/nvim/archlinux.vim
002.464  000.022  000.015: sourcing /etc/xdg/nvim/sysinit.vim
003.500  000.064  000.064: require('vim._async')
003.693  000.190  000.190: require('vim.version')
004.162  001.621  001.367: require('vim.pack')
004.193  000.019  000.019: require('vim.fs')
004.264  000.003  000.003: require('vim.F')
004.604  000.020  000.020: require('global')
004.651  000.045  000.045: require('command')
004.684  000.031  000.031: require('autocmds')
004.742  000.027  000.027: require('native-packer.key')
004.807  000.063  000.063: require('keymaps/buffer')
004.966  000.158  000.158: require('native-packer.key.core')
005.346  000.033  000.033: require('keymaps/change')
005.430  000.027  000.027: require('keymaps/comment')
005.505  000.027  000.027: require('keymaps/copy')
005.740  000.135  000.135: require('keymaps/delete')
006.165  000.061  000.061: require('keymaps/diagnostic')
006.337  000.026  000.026: require('keymaps/directory')
006.433  000.077  000.077: require('keymaps/file')
006.525  000.023  000.023: require('keymaps/fold')
006.596  000.061  000.061: require('keymaps/indent')
006.840  000.055  000.055: require('builtin.insert-line')
006.844  000.183  000.128: require('keymaps/insert-line')
007.083  000.038  000.038: require('keymaps/jump')
007.228  000.068  000.068: require('keymaps/location-list')
007.293  000.021  000.021: require('keymaps/lsp')
007.322  000.016  000.016: require('keymaps/macro')
007.366  000.038  000.038: require('keymaps/misc')
007.708  000.207  000.207: require('keymaps/move')
008.750  000.025  000.025: require('keymaps/nop')
008.790  000.023  000.023: require('keymaps/operator')
008.854  000.032  000.032: require('keymaps/paste')
008.966  000.047  000.047: require('keymaps/quickfix')
009.025  000.029  000.029: require('keymaps/quit')
009.123  000.032  000.032: require('keymaps/register')
009.150  000.018  000.018: require('keymaps/screen-move')
009.271  000.119  000.119: require('keymaps/scroll')
009.722  000.063  000.063: require('keymaps/search')
009.868  000.108  000.108: require('keymaps/start-insert-mode')
010.222  000.039  000.039: require('keymaps/start-select-mode')
010.327  000.043  000.043: require('keymaps/start-visual-mode')
010.381  000.025  000.025: require('keymaps/stop-insert-mode')
010.766  000.176  000.176: require('keymaps/switch-option')
010.967  000.070  000.070: require('keymaps/tabpage')
011.064  000.022  000.022: require('keymaps/tagstack')
011.101  000.019  000.019: require('keymaps/terminal')
011.217  000.090  000.090: require('keymaps/textobject')
011.511  000.039  000.039: require('keymaps/tmux-fixed')
011.579  000.016  000.016: require('keymaps/undo')
011.632  000.044  000.044: require('keymaps/window')
011.810  000.089  000.089: require('keymaps/word-move')
012.057  000.057  000.057: require('keymaps/test')
012.074  007.389  004.875: require('keymaps')
012.124  000.049  000.049: require('native-packer')
012.195  000.069  000.069: require('plugins.download.style')
012.228  000.031  000.031: require('plugins.download.style.statuscol')
012.273  000.043  000.043: require('plugins.download.style.lualine')
012.287  000.013  000.013: require('plugins.download.misc.repeat')
012.298  000.011  000.011: require('plugins.local.undotree')
012.361  000.061  000.061: require('plugins.local.neo-option')
012.388  000.025  000.025: require('plugins.download.misc.linefuse')
012.417  000.028  000.028: require('plugins.local.move-line')
012.438  000.019  000.019: require('plugins.local.move-word')
012.452  000.013  000.013: require('plugins.local.file-details')
012.530  000.077  000.077: require('plugins.local.neo-lsp')
012.608  000.077  000.077: require('plugins.local.code-action')
012.649  000.040  000.040: require('plugins.local.op-register')
012.664  000.014  000.014: require('plugins.local.simple-translate')
012.882  000.216  000.216: require('plugins.local.treesitter-textobject')
012.899  000.016  000.016: require('plugins.download.misc.lazydev')
012.937  000.036  000.036: require('plugins.download.misc.zen')
012.974  000.036  000.036: require('plugins.download.snippet.luasnip')
013.057  000.081  000.081: require('plugins.download.cmp.blink-cmp')
013.421  000.048  000.048: require('plugins.download.eye-track.cword')
013.434  000.376  000.328: require('plugins.download.eye-track')
013.645  000.209  000.209: require('plugins.download.fzf')
013.686  000.040  000.040: require('plugins.download.format.conform')
013.721  000.033  000.033: require('plugins.download.treesitter')
013.749  000.027  000.027: require('plugins.download.filemanager.oil')
013.766  000.016  000.016: require('plugins.download.misc.tiny-inline-diagnostic')
013.782  000.015  000.015: require('plugins.download.misc.autopairs')
013.804  000.020  000.020: require('plugins.download.misc.nvim-ts-autotag')
013.825  000.021  000.021: require('plugins.download.misc.supermaven')
013.847  000.020  000.020: require('plugins.download.misc.grug-far')
013.905  000.057  000.057: require('plugins.download.misc.toggleterm')
013.921  000.015  000.015: require('plugins.download.git.gitsigns')
013.944  000.022  000.022: require('plugins.download.tmux.vim-tmux-navigator')
013.989  000.044  000.044: require('plugins.download.window.winshift')
014.023  000.033  000.033: require('plugins.download.misc.flash')
014.056  000.032  000.032: require('plugins.download.misc.snacks')
014.162  000.105  000.105: require('plugins.download.tex')
014.204  000.040  000.040: require('plugins.download.markdown')
014.228  000.023  000.023: require('plugins.download.misc.neotest')
014.327  000.098  000.098: require('plugins.download.misc.outline')
014.344  000.015  000.015: require('plugins.local.bufferman')
014.575  000.030  000.030: require('native-packer.handler')
014.603  000.026  000.026: require('native-packer.depend')
014.607  000.262  000.206: require('native-packer.core')
014.717  000.066  000.066: require('native-packer.handler.cmd')
014.762  000.043  000.043: require('native-packer.handler.colorscheme')
014.814  000.050  000.050: require('native-packer.handler.event')
014.857  000.041  000.041: require('native-packer.handler.ft')
014.906  000.047  000.047: require('native-packer.handler.key')
015.986  000.407  000.407: require('vim.iter')
017.483  000.218  000.218: require('paradox')
017.754  000.044  000.044: require('paradox.colors.light')
017.800  000.043  000.043: require('paradox.colors.dark')
017.802  000.116  000.028: require('paradox.colors')
018.094  000.421  000.305: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/paradox.nvim/colors/paradox.lua
018.099  000.495  000.075: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
018.529  000.117  000.117: require('snacks')
018.533  000.130  000.013: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/snacks.nvim/plugin/snacks.lua
019.646  000.794  000.794: require('vim.diagnostic')
020.502  000.410  000.410: require('vim.lsp.protocol')
020.516  000.499  000.089: require('vim.lsp.log')
021.198  000.680  000.680: require('vim.lsp.util')
021.406  000.092  000.092: require('vim.lsp.sync')
021.409  000.209  000.117: require('vim.lsp._changetracking')
021.646  000.063  000.063: require('vim.lsp._transport')
021.650  000.003  000.003: require('vim._core.stringbuffer')
021.655  000.244  000.178: require('vim.lsp.rpc')
021.683  002.035  000.402: require('vim.lsp')
021.686  002.932  000.103: require('statuscol.builtin')
021.889  000.202  000.202: require('statuscol')
021.906  000.007  000.007: require('ffi')
021.912  000.021  000.014: require('statuscol.ffidef')
022.065  000.021  000.021: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
022.502  000.131  000.131: require('nvim-navic.lib')
022.504  000.264  000.133: require('nvim-navic')
022.785  000.046  000.046: require('lualine_require')
022.916  000.408  000.363: require('lualine')
023.180  000.008  000.008: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.741  000.006  000.006: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.748  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.753  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.757  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.762  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.766  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.769  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.783  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.786  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.790  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.794  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.798  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.802  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.806  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.809  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.816  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.147  000.026  000.026: require('lualine.utils.mode')
024.312  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.319  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.430  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.439  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.444  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.447  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.452  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.455  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.467  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.474  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.504  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.508  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.512  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.515  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.519  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.524  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.529  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.533  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.536  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.541  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.544  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.548  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.551  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.625  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.628  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.630  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.633  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.864  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.871  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.876  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.880  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.883  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.887  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.891  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.896  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.900  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.920  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.923  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.926  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.929  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.933  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.939  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.943  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.947  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.950  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.953  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.957  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.961  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.966  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.969  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.973  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.976  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.979  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.984  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.988  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
025.163  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
025.193  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
025.203  000.009  000.009: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
025.208  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
025.211  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
025.353  000.025  000.025: require('repeat')
025.498  000.042  000.042: require('neo-option')
026.792  000.065  000.065: require('vim.treesitter.language')
026.812  000.018  000.018: require('vim.func')
026.881  000.067  000.067: require('vim.treesitter._range')
026.922  000.039  000.039: require('vim.func._memoize')
026.938  000.529  000.339: require('vim.treesitter.query')
026.957  000.932  000.403: require('vim.treesitter.languagetree')
026.961  001.219  000.287: require('vim.treesitter')
027.194  000.232  000.232: require('vim.treesitter._fold')
028.720  000.011  000.011: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/conform.nvim/plugin/conform.lua
029.018  000.276  000.276: require('conform')
029.263  000.119  000.119: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/filetypes.lua
029.304  000.033  000.033: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/nvim-treesitter.lua
029.329  000.018  000.018: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/query_predicates.lua
029.371  000.019  000.019: require('nvim-treesitter')
029.433  000.061  000.061: require('nvim-treesitter.config')
029.745  000.137  000.137: require('nvim-treesitter.async')
029.784  000.038  000.038: require('nvim-treesitter.log')
030.258  000.473  000.473: require('nvim-treesitter.parsers')
030.273  000.014  000.014: require('nvim-treesitter.util')
030.279  000.843  000.181: require('nvim-treesitter.install')
030.757  000.476  000.476: require('nvim-treesitter.parsers')
031.286  000.097  000.097: require('gitsigns')
031.505  000.208  000.208: require('gitsigns.highlight')
031.626  000.117  000.117: require('gitsigns.debug.log')
031.763  000.135  000.135: require('gitsigns.config')
031.962  000.040  000.040: require('gitsigns.debounce')
031.967  000.784  000.187: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/gitsigns.nvim/plugin/gitsigns.lua
032.300  029.817  008.558: sourcing /home/luoqing/.config/nvim/init.lua
032.304  000.302: sourcing vimrc file(s)
032.415  000.008  000.008: sourcing /home/luoqing/.local/share/nvim/site/ftdetect/ghostty.vim
032.455  000.006  000.006: sourcing /usr/share/nvim/site/ftdetect/ghostty.vim
032.475  000.006  000.006: sourcing /usr/share/vim/vimfiles/ftdetect/ghostty.vim
032.478  000.099  000.079: sourcing nvim_exec2() called at /usr/share/nvim/runtime/filetype.lua:0
032.479  000.134  000.035: sourcing /usr/share/nvim/runtime/filetype.lua
032.555  000.031  000.031: sourcing /usr/share/nvim/runtime/syntax/synload.vim
032.591  000.098  000.067: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
032.674  000.011  000.011: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/gitsigns.nvim/plugin/gitsigns.lua
032.781  000.077  000.077: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/filetypes.lua
032.814  000.026  000.026: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/nvim-treesitter.lua
032.838  000.018  000.018: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/query_predicates.lua
032.862  000.006  000.006: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/conform.nvim/plugin/conform.lua
032.891  000.004  000.004: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
032.914  000.003  000.003: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/snacks.nvim/plugin/snacks.lua
033.092  000.074  000.074: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
033.301  000.075  000.075: sourcing /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim
033.316  000.219  000.144: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
033.372  000.051  000.051: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
033.381  000.003  000.003: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
033.438  000.052  000.052: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
033.482  000.038  000.038: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
033.494  000.006  000.006: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
033.553  000.054  000.054: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
033.577  000.018  000.018: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
033.610  000.028  000.028: sourcing /usr/share/nvim/runtime/plugin/man.lua
033.647  000.030  000.030: sourcing /usr/share/nvim/runtime/plugin/nvim/net.lua
033.663  000.010  000.010: sourcing /usr/share/nvim/runtime/plugin/nvim/spellfile.lua
033.710  000.042  000.042: sourcing /usr/share/nvim/runtime/plugin/osc52.lua
033.769  000.054  000.054: sourcing /usr/share/nvim/runtime/plugin/shada.lua
033.792  000.014  000.014: sourcing /usr/share/nvim/runtime/plugin/tohtml.lua
034.022  000.207  000.207: sourcing /usr/share/vim/vimfiles/plugin/fzf.vim
034.053  000.006  000.006: sourcing /home/luoqing/vimcdoc-2.5.0/plugin/vimcdoc.vim
034.054  000.465: loading rtp plugins
034.095  000.040: loading packages
034.095  000.001: loading after plugins
034.100  000.005: inits 3
034.653  000.553: reading ShaDa
034.682  000.029: opening buffers
034.764  000.078  000.078: require('snacks.explorer')
034.803  000.043: BufEnter autocommands
034.804  000.001: editing files in windows
034.909  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.052  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.055  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.056  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.057  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.058  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.060  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.061  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.063  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.064  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.065  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.066  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.067  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.068  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.069  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.070  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.071  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.073  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.074  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.075  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.076  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.077  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.078  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.079  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.088  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.090  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.091  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.092  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.093  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.094  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.095  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.096  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.097  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.098  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.099  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.100  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.101  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.102  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.103  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.104  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.105  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.106  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.108  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.109  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.110  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.111  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.112  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.114  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.115  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.116  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.117  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.118  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.127  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.129  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.130  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.131  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.132  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.134  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.135  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.136  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.137  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.138  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.139  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.140  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.142  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.143  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.150  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.156  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.159  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.162  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.165  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.168  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.175  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.178  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.180  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.184  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.186  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.217  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.220  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.223  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.226  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.231  000.004  000.004: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.276  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.279  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.307  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.320  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.323  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.326  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.328  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.331  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.336  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.340  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.343  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.345  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.347  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.350  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.352  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.355  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.358  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.360  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.363  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.366  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.368  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.371  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.374  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.382  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.385  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.387  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.389  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.434  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.437  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.440  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.442  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.445  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.448  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.473  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.483  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.485  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.488  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.490  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.493  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.496  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.506  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.510  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.512  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.515  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.517  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.519  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.522  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.525  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.530  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.533  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.536  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.538  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.540  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.543  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.560  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.598  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.615  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.621  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.626  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.629  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
035.641  000.720: VimEnter autocommands
036.046  000.230  000.230: require('snacks.util')
036.190  000.115  000.115: require('vim.ui')
036.192  000.547  000.202: require('snacks.input')
036.243  000.049  000.049: require('snacks.picker')
036.406  000.162  000.162: require('snacks.picker.config')
036.564  000.157  000.157: require('snacks.picker.config.highlights')
036.723  000.158  000.158: require('snacks.picker.config.defaults')
037.029  000.305  000.305: require('snacks.picker.config.sources')
037.112  000.083  000.083: require('snacks.picker.config.layouts')
038.296  001.195: UIEnter autocommands
038.450  000.118  000.118: sourcing /usr/share/nvim/runtime/autoload/provider/clipboard.vim
038.453  000.040: before starting main loop
038.581  000.127: first screen update
038.581  000.001: --- NVIM STARTED ---

--- Startup times for process: Embedded ---

times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.002  000.002: --- NVIM STARTING ---
000.077  000.075: event init
000.129  000.052: early init
000.152  000.023: locale set
000.172  000.020: init first window
000.387  000.215: inits 1
000.395  000.008: window checked
000.396  000.002: parsing arguments
000.756  000.033  000.033: require('vim._core.shared')
000.810  000.003  000.003: require('string.buffer')
000.830  000.035  000.032: require('vim.inspect')
000.864  000.027  000.027: require('vim._core.options')
000.868  000.110  000.047: require('vim._core.editor')
000.891  000.022  000.022: require('vim._core.system')
000.892  000.184  000.021: require('vim._init_packages')
000.894  000.313: init lua interpreter
000.936  000.042: expanding arguments
000.946  000.010: inits 2
001.156  000.210: init highlight
001.157  000.001: waiting for UI
001.228  000.071: done waiting for UI
001.237  000.008: clear screen
001.342  000.008  000.008: require('vim.keymap')
002.091  000.089  000.089: sourcing nvim_exec2()
002.403  001.164  001.067: require('vim._core.defaults')
002.405  000.004: init default mappings & autocommands
002.652  000.031  000.031: sourcing /usr/share/nvim/runtime/ftplugin.vim
002.691  000.017  000.017: sourcing /usr/share/nvim/runtime/indent.vim
002.724  000.007  000.007: sourcing /usr/share/nvim/archlinux.vim
002.726  000.022  000.015: sourcing /etc/xdg/nvim/sysinit.vim
003.749  000.063  000.063: require('vim._async')
003.931  000.179  000.179: require('vim.version')
004.371  001.508  001.265: require('vim.pack')
004.394  000.016  000.016: require('vim.fs')
004.466  000.004  000.004: require('vim.F')
004.800  000.021  000.021: require('global')
004.842  000.040  000.040: require('command')
004.875  000.031  000.031: require('autocmds')
004.933  000.027  000.027: require('native-packer.key')
004.995  000.061  000.061: require('keymaps/buffer')
005.152  000.155  000.155: require('native-packer.key.core')
005.520  000.039  000.039: require('keymaps/change')
005.595  000.025  000.025: require('keymaps/comment')
005.663  000.022  000.022: require('keymaps/copy')
005.886  000.133  000.133: require('keymaps/delete')
006.344  000.063  000.063: require('keymaps/diagnostic')
006.569  000.027  000.027: require('keymaps/directory')
006.671  000.078  000.078: require('keymaps/file')
006.740  000.016  000.016: require('keymaps/fold')
006.794  000.044  000.044: require('keymaps/indent')
007.093  000.087  000.087: require('builtin.insert-line')
007.115  000.216  000.128: require('keymaps/insert-line')
007.453  000.037  000.037: require('keymaps/jump')
007.564  000.075  000.075: require('keymaps/location-list')
007.622  000.019  000.019: require('keymaps/lsp')
007.656  000.015  000.015: require('keymaps/macro')
007.701  000.039  000.039: require('keymaps/misc')
008.084  000.210  000.210: require('keymaps/move')
009.187  000.023  000.023: require('keymaps/nop')
009.227  000.022  000.022: require('keymaps/operator')
009.298  000.028  000.028: require('keymaps/paste')
009.413  000.047  000.047: require('keymaps/quickfix')
009.467  000.024  000.024: require('keymaps/quit')
009.545  000.027  000.027: require('keymaps/register')
009.568  000.014  000.014: require('keymaps/screen-move')
009.675  000.105  000.105: require('keymaps/scroll')
010.085  000.063  000.063: require('keymaps/search')
010.229  000.111  000.111: require('keymaps/start-insert-mode')
010.491  000.034  000.034: require('keymaps/start-select-mode')
010.597  000.042  000.042: require('keymaps/start-visual-mode')
010.645  000.025  000.025: require('keymaps/stop-insert-mode')
010.848  000.083  000.083: require('keymaps/switch-option')
011.171  000.169  000.169: require('keymaps/tabpage')
011.417  000.025  000.025: require('keymaps/tagstack')
011.461  000.019  000.019: require('keymaps/terminal')
011.603  000.100  000.100: require('keymaps/textobject')
011.918  000.039  000.039: require('keymaps/tmux-fixed')
012.012  000.017  000.017: require('keymaps/undo')
012.066  000.045  000.045: require('keymaps/window')
012.253  000.090  000.090: require('keymaps/word-move')
012.509  000.057  000.057: require('keymaps/test')
012.544  007.668  005.158: require('keymaps')
012.597  000.051  000.051: require('native-packer')
012.654  000.056  000.056: require('plugins.download.style')
012.685  000.029  000.029: require('plugins.download.style.statuscol')
012.728  000.041  000.041: require('plugins.download.style.lualine')
012.742  000.013  000.013: require('plugins.download.misc.repeat')
012.754  000.010  000.010: require('plugins.local.undotree')
012.818  000.063  000.063: require('plugins.local.neo-option')
012.845  000.026  000.026: require('plugins.download.misc.linefuse')
012.875  000.029  000.029: require('plugins.local.move-line')
012.896  000.019  000.019: require('plugins.local.move-word')
012.909  000.012  000.012: require('plugins.local.file-details')
012.988  000.077  000.077: require('plugins.local.neo-lsp')
013.083  000.094  000.094: require('plugins.local.code-action')
013.127  000.042  000.042: require('plugins.local.op-register')
013.141  000.013  000.013: require('plugins.local.simple-translate')
013.353  000.210  000.210: require('plugins.local.treesitter-textobject')
013.369  000.014  000.014: require('plugins.download.misc.lazydev')
013.406  000.036  000.036: require('plugins.download.misc.zen')
013.440  000.032  000.032: require('plugins.download.snippet.luasnip')
013.520  000.078  000.078: require('plugins.download.cmp.blink-cmp')
013.879  000.046  000.046: require('plugins.download.eye-track.cword')
013.886  000.364  000.319: require('plugins.download.eye-track')
014.077  000.190  000.190: require('plugins.download.fzf')
014.110  000.032  000.032: require('plugins.download.format.conform')
014.130  000.019  000.019: require('plugins.download.treesitter')
014.148  000.017  000.017: require('plugins.download.filemanager.oil')
014.174  000.025  000.025: require('plugins.download.misc.tiny-inline-diagnostic')
014.183  000.008  000.008: require('plugins.download.misc.autopairs')
014.198  000.015  000.015: require('plugins.download.misc.nvim-ts-autotag')
014.211  000.013  000.013: require('plugins.download.misc.supermaven')
014.225  000.013  000.013: require('plugins.download.misc.grug-far')
014.272  000.047  000.047: require('plugins.download.misc.toggleterm')
014.282  000.009  000.009: require('plugins.download.git.gitsigns')
014.299  000.016  000.016: require('plugins.download.tmux.vim-tmux-navigator')
014.325  000.025  000.025: require('plugins.download.window.winshift')
014.347  000.022  000.022: require('plugins.download.misc.flash')
014.372  000.025  000.025: require('plugins.download.misc.snacks')
014.453  000.080  000.080: require('plugins.download.tex')
014.477  000.023  000.023: require('plugins.download.markdown')
014.491  000.014  000.014: require('plugins.download.misc.neotest')
014.567  000.076  000.076: require('plugins.download.misc.outline')
014.577  000.009  000.009: require('plugins.local.bufferman')
014.744  000.018  000.018: require('native-packer.handler')
014.759  000.015  000.015: require('native-packer.depend')
014.763  000.186  000.153: require('native-packer.core')
014.843  000.045  000.045: require('native-packer.handler.cmd')
014.872  000.027  000.027: require('native-packer.handler.colorscheme')
014.907  000.034  000.034: require('native-packer.handler.event')
014.933  000.025  000.025: require('native-packer.handler.ft')
014.963  000.030  000.030: require('native-packer.handler.key')
015.527  000.248  000.248: require('vim.iter')
016.443  000.378  000.378: require('paradox')
016.624  000.033  000.033: require('paradox.colors.light')
016.652  000.026  000.026: require('paradox.colors.dark')
016.653  000.078  000.018: require('paradox.colors')
016.850  000.282  000.204: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/paradox.nvim/colors/paradox.lua
016.852  000.325  000.043: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.159  000.101  000.101: require('snacks')
017.161  000.107  000.006: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/snacks.nvim/plugin/snacks.lua
018.216  000.810  000.810: require('vim.diagnostic')
019.017  000.375  000.375: require('vim.lsp.protocol')
019.041  000.463  000.088: require('vim.lsp.log')
019.727  000.685  000.685: require('vim.lsp.util')
019.929  000.092  000.092: require('vim.lsp.sync')
019.932  000.203  000.110: require('vim.lsp._changetracking')
020.169  000.065  000.065: require('vim.lsp._transport')
020.173  000.003  000.003: require('vim._core.stringbuffer')
020.178  000.245  000.177: require('vim.lsp.rpc')
020.212  001.993  000.398: require('vim.lsp')
020.214  002.895  000.092: require('statuscol.builtin')
020.428  000.213  000.213: require('statuscol')
020.445  000.006  000.006: require('ffi')
020.451  000.021  000.015: require('statuscol.ffidef')
020.622  000.020  000.020: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
021.048  000.130  000.130: require('nvim-navic.lib')
021.051  000.267  000.136: require('nvim-navic')
021.332  000.046  000.046: require('lualine_require')
021.464  000.410  000.364: require('lualine')
021.606  000.008  000.008: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.135  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.144  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.149  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.154  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.159  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.163  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.167  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.172  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.182  000.006  000.006: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.185  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.189  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.193  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.197  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.200  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.204  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.211  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.527  000.032  000.032: require('lualine.utils.mode')
022.684  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.690  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.791  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.796  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.803  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.807  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.810  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.815  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.819  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.825  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.830  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.833  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.876  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.882  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.901  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.908  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.913  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.917  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.920  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.925  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.928  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.931  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.935  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.009  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.013  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.015  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.018  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.246  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.252  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.255  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.258  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.262  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.265  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.269  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.276  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.279  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.283  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.286  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.291  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.295  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.298  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.303  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.307  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.311  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.314  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.317  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.320  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.324  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.329  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.332  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.335  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.338  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.352  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.355  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.358  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.556  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.582  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.592  000.007  000.007: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.597  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.600  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.745  000.027  000.027: require('repeat')
023.876  000.039  000.039: require('neo-option')
025.167  000.064  000.064: require('vim.treesitter.language')
025.189  000.019  000.019: require('vim.func')
025.259  000.069  000.069: require('vim.treesitter._range')
025.305  000.044  000.044: require('vim.func._memoize')
025.323  000.549  000.353: require('vim.treesitter.query')
025.344  000.953  000.404: require('vim.treesitter.languagetree')
025.349  001.239  000.286: require('vim.treesitter')
025.519  000.170  000.170: require('vim.treesitter._fold')
027.474  000.108  000.108: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/filetypes.lua
027.523  000.040  000.040: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/nvim-treesitter.lua
027.550  000.019  000.019: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/query_predicates.lua
027.594  000.021  000.021: require('nvim-treesitter')
027.659  000.064  000.064: require('nvim-treesitter.config')
027.985  000.142  000.142: require('nvim-treesitter.async')
028.027  000.040  000.040: require('nvim-treesitter.log')
028.523  000.495  000.495: require('nvim-treesitter.parsers')
028.538  000.014  000.014: require('nvim-treesitter.util')
028.542  000.881  000.189: require('nvim-treesitter.install')
029.004  000.460  000.460: require('nvim-treesitter.parsers')
029.585  000.098  000.098: require('gitsigns')
029.788  000.189  000.189: require('gitsigns.highlight')
029.907  000.113  000.113: require('gitsigns.debug.log')
030.049  000.142  000.142: require('gitsigns.config')
030.273  000.040  000.040: require('gitsigns.debounce')
030.279  000.798  000.216: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/gitsigns.nvim/plugin/gitsigns.lua
030.507  027.765  007.239: sourcing /home/luoqing/.config/nvim/init.lua
030.511  000.271: sourcing vimrc file(s)
030.629  000.008  000.008: sourcing /home/luoqing/.local/share/nvim/site/ftdetect/ghostty.vim
030.669  000.006  000.006: sourcing /usr/share/nvim/site/ftdetect/ghostty.vim
030.690  000.005  000.005: sourcing /usr/share/vim/vimfiles/ftdetect/ghostty.vim
030.693  000.104  000.085: sourcing nvim_exec2() called at /usr/share/nvim/runtime/filetype.lua:0
030.694  000.138  000.034: sourcing /usr/share/nvim/runtime/filetype.lua
030.775  000.034  000.034: sourcing /usr/share/nvim/runtime/syntax/synload.vim
030.816  000.109  000.074: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
030.896  000.010  000.010: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/gitsigns.nvim/plugin/gitsigns.lua
031.013  000.087  000.087: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/filetypes.lua
031.046  000.026  000.026: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/nvim-treesitter.lua
031.074  000.022  000.022: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/query_predicates.lua
031.105  000.004  000.004: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
031.129  000.003  000.003: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/snacks.nvim/plugin/snacks.lua
031.304  000.073  000.073: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
031.504  000.076  000.076: sourcing /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim
031.525  000.215  000.139: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
031.582  000.051  000.051: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
031.591  000.003  000.003: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
031.652  000.055  000.055: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
031.695  000.038  000.038: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
031.706  000.007  000.007: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
031.766  000.054  000.054: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
031.789  000.018  000.018: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
031.823  000.028  000.028: sourcing /usr/share/nvim/runtime/plugin/man.lua
031.861  000.033  000.033: sourcing /usr/share/nvim/runtime/plugin/nvim/net.lua
031.879  000.012  000.012: sourcing /usr/share/nvim/runtime/plugin/nvim/spellfile.lua
031.924  000.040  000.040: sourcing /usr/share/nvim/runtime/plugin/osc52.lua
031.989  000.058  000.058: sourcing /usr/share/nvim/runtime/plugin/shada.lua
032.014  000.015  000.015: sourcing /usr/share/nvim/runtime/plugin/tohtml.lua
032.247  000.209  000.209: sourcing /usr/share/vim/vimfiles/plugin/fzf.vim
032.281  000.006  000.006: sourcing /home/luoqing/vimcdoc-2.5.0/plugin/vimcdoc.vim
032.282  000.456: loading rtp plugins
032.320  000.038: loading packages
032.321  000.000: loading after plugins
032.325  000.005: inits 3
032.893  000.568: reading ShaDa
032.929  000.035: opening buffers
033.015  000.080  000.080: require('snacks.explorer')
033.073  000.064: BufEnter autocommands
033.074  000.001: editing files in windows
033.159  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.387  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.389  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.395  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.396  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.398  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.399  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.400  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.402  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.403  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.404  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.405  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.407  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.408  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.409  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.411  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.412  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.413  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.414  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.415  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.416  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.417  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.418  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.420  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.421  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.423  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.424  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.439  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.440  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.441  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.445  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.447  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.448  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.449  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.450  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.451  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.452  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.453  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.454  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.455  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.456  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.457  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.458  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.460  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.461  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.462  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.463  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.464  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.465  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.467  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.468  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.469  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.470  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.471  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.473  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.474  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.475  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.476  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.477  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.478  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.479  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.480  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.482  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.483  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.484  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.485  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.493  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.500  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.503  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.508  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.526  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.529  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.531  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.533  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.537  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.539  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.541  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.544  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.547  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.551  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.553  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.558  000.004  000.004: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.591  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.594  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.640  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.643  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.646  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.649  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.651  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.654  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.657  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.664  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.667  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.671  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.674  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.676  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.679  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.682  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.686  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.688  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.691  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.694  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.697  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.699  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.702  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.706  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.709  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.711  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.719  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.840  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.844  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.846  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.848  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.851  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.854  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.887  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.892  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.895  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.897  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.902  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.904  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.907  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.910  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.945  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.958  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.961  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.964  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.966  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.968  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.971  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.974  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.977  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.979  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.981  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.984  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.986  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.988  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.071  000.006  000.006: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.092  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.099  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.103  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.107  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.119  000.922: VimEnter autocommands
034.487  000.215  000.215: require('snacks.util')
034.639  000.102  000.102: require('vim.ui')
034.642  000.519  000.202: require('snacks.input')
034.690  000.046  000.046: require('snacks.picker')
034.850  000.158  000.158: require('snacks.picker.config')
035.009  000.158  000.158: require('snacks.picker.config.highlights')
035.176  000.165  000.165: require('snacks.picker.config.defaults')
035.552  000.375  000.375: require('snacks.picker.config.sources')
035.632  000.079  000.079: require('snacks.picker.config.layouts')
036.923  001.304: UIEnter autocommands
037.097  000.127  000.127: sourcing /usr/share/nvim/runtime/autoload/provider/clipboard.vim
037.100  000.051: before starting main loop
037.243  000.143: first screen update
037.244  000.001: --- NVIM STARTED ---

--- Startup times for process: Embedded ---

times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.001  000.001: --- NVIM STARTING ---
000.077  000.076: event init
000.126  000.049: early init
000.149  000.023: locale set
000.169  000.021: init first window
000.391  000.222: inits 1
000.399  000.008: window checked
000.401  000.002: parsing arguments
000.790  000.029  000.029: require('vim._core.shared')
000.854  000.003  000.003: require('string.buffer')
000.875  000.037  000.034: require('vim.inspect')
000.907  000.026  000.026: require('vim._core.options')
000.912  000.119  000.056: require('vim._core.editor')
000.932  000.020  000.020: require('vim._core.system')
000.934  000.188  000.020: require('vim._init_packages')
000.935  000.346: init lua interpreter
000.977  000.042: expanding arguments
000.986  000.010: inits 2
001.237  000.250: init highlight
001.238  000.001: waiting for UI
001.306  000.068: done waiting for UI
001.313  000.007: clear screen
001.408  000.010  000.010: require('vim.keymap')
002.014  000.094  000.094: sourcing nvim_exec2()
002.263  000.949  000.844: require('vim._core.defaults')
002.265  000.004: init default mappings & autocommands
002.501  000.029  000.029: sourcing /usr/share/nvim/runtime/ftplugin.vim
002.543  000.018  000.018: sourcing /usr/share/nvim/runtime/indent.vim
002.594  000.007  000.007: sourcing /usr/share/nvim/archlinux.vim
002.596  000.022  000.015: sourcing /etc/xdg/nvim/sysinit.vim
003.666  000.064  000.064: require('vim._async')
003.881  000.210  000.210: require('vim.version')
004.388  001.666  001.392: require('vim.pack')
004.415  000.020  000.020: require('vim.fs')
004.479  000.004  000.004: require('vim.F')
004.879  000.021  000.021: require('global')
004.922  000.041  000.041: require('command')
004.959  000.036  000.036: require('autocmds')
005.019  000.026  000.026: require('native-packer.key')
005.083  000.062  000.062: require('keymaps/buffer')
005.238  000.153  000.153: require('native-packer.key.core')
005.616  000.033  000.033: require('keymaps/change')
005.696  000.026  000.026: require('keymaps/comment')
005.780  000.025  000.025: require('keymaps/copy')
006.010  000.136  000.136: require('keymaps/delete')
006.440  000.061  000.061: require('keymaps/diagnostic')
006.586  000.025  000.025: require('keymaps/directory')
006.681  000.073  000.073: require('keymaps/file')
006.758  000.017  000.017: require('keymaps/fold')
006.811  000.046  000.046: require('keymaps/indent')
007.035  000.095  000.095: require('builtin.insert-line')
007.056  000.199  000.105: require('keymaps/insert-line')
007.432  000.037  000.037: require('keymaps/jump')
007.576  000.057  000.057: require('keymaps/location-list')
007.631  000.017  000.017: require('keymaps/lsp')
007.662  000.015  000.015: require('keymaps/macro')
007.708  000.039  000.039: require('keymaps/misc')
008.082  000.212  000.212: require('keymaps/move')
009.211  000.025  000.025: require('keymaps/nop')
009.252  000.021  000.021: require('keymaps/operator')
009.312  000.030  000.030: require('keymaps/paste')
009.420  000.044  000.044: require('keymaps/quickfix')
009.471  000.022  000.022: require('keymaps/quit')
009.544  000.027  000.027: require('keymaps/register')
009.567  000.014  000.014: require('keymaps/screen-move')
009.707  000.138  000.138: require('keymaps/scroll')
010.149  000.066  000.066: require('keymaps/search')
010.289  000.106  000.106: require('keymaps/start-insert-mode')
010.577  000.035  000.035: require('keymaps/start-select-mode')
010.691  000.043  000.043: require('keymaps/start-visual-mode')
010.738  000.023  000.023: require('keymaps/stop-insert-mode')
010.914  000.078  000.078: require('keymaps/switch-option')
011.219  000.154  000.154: require('keymaps/tabpage')
011.471  000.024  000.024: require('keymaps/tagstack')
011.519  000.022  000.022: require('keymaps/terminal')
011.631  000.084  000.084: require('keymaps/textobject')
011.920  000.037  000.037: require('keymaps/tmux-fixed')
012.046  000.017  000.017: require('keymaps/undo')
012.097  000.042  000.042: require('keymaps/window')
012.284  000.089  000.089: require('keymaps/word-move')
012.578  000.059  000.059: require('keymaps/test')
012.597  007.636  005.175: require('keymaps')
012.647  000.049  000.049: require('native-packer')
012.705  000.055  000.055: require('plugins.download.style')
012.735  000.029  000.029: require('plugins.download.style.statuscol')
012.778  000.042  000.042: require('plugins.download.style.lualine')
012.792  000.012  000.012: require('plugins.download.misc.repeat')
012.804  000.010  000.010: require('plugins.local.undotree')
012.867  000.062  000.062: require('plugins.local.neo-option')
012.894  000.025  000.025: require('plugins.download.misc.linefuse')
012.924  000.029  000.029: require('plugins.local.move-line')
012.949  000.024  000.024: require('plugins.local.move-word')
012.964  000.013  000.013: require('plugins.local.file-details')
013.040  000.075  000.075: require('plugins.local.neo-lsp')
013.056  000.014  000.014: require('plugins.local.code-action')
013.188  000.131  000.131: require('plugins.local.op-register')
013.203  000.014  000.014: require('plugins.local.simple-translate')
013.418  000.213  000.213: require('plugins.local.treesitter-textobject')
013.433  000.014  000.014: require('plugins.download.misc.lazydev')
013.472  000.038  000.038: require('plugins.download.misc.zen')
013.505  000.032  000.032: require('plugins.download.snippet.luasnip')
013.581  000.075  000.075: require('plugins.download.cmp.blink-cmp')
013.901  000.042  000.042: require('plugins.download.eye-track.cword')
013.909  000.326  000.284: require('plugins.download.eye-track')
014.153  000.243  000.243: require('plugins.download.fzf')
014.202  000.045  000.045: require('plugins.download.format.conform')
014.226  000.022  000.022: require('plugins.download.treesitter')
014.243  000.017  000.017: require('plugins.download.filemanager.oil')
014.254  000.011  000.011: require('plugins.download.misc.tiny-inline-diagnostic')
014.262  000.007  000.007: require('plugins.download.misc.autopairs')
014.273  000.011  000.011: require('plugins.download.misc.nvim-ts-autotag')
014.305  000.032  000.032: require('plugins.download.misc.supermaven')
014.321  000.015  000.015: require('plugins.download.misc.grug-far')
014.369  000.048  000.048: require('plugins.download.misc.toggleterm')
014.378  000.008  000.008: require('plugins.download.git.gitsigns')
014.399  000.020  000.020: require('plugins.download.tmux.vim-tmux-navigator')
014.427  000.028  000.028: require('plugins.download.window.winshift')
014.451  000.023  000.023: require('plugins.download.misc.flash')
014.476  000.024  000.024: require('plugins.download.misc.snacks')
014.561  000.084  000.084: require('plugins.download.tex')
014.584  000.023  000.023: require('plugins.download.markdown')
014.600  000.015  000.015: require('plugins.download.misc.neotest')
014.675  000.074  000.074: require('plugins.download.misc.outline')
014.685  000.009  000.009: require('plugins.local.bufferman')
014.855  000.016  000.016: require('native-packer.handler')
014.872  000.016  000.016: require('native-packer.depend')
014.875  000.189  000.157: require('native-packer.core')
014.949  000.046  000.046: require('native-packer.handler.cmd')
014.981  000.031  000.031: require('native-packer.handler.colorscheme')
015.010  000.028  000.028: require('native-packer.handler.event')
015.033  000.022  000.022: require('native-packer.handler.ft')
015.065  000.031  000.031: require('native-packer.handler.key')
015.841  000.271  000.271: require('vim.iter')
016.830  000.348  000.348: require('paradox')
017.007  000.030  000.030: require('paradox.colors.light')
017.034  000.026  000.026: require('paradox.colors.dark')
017.035  000.075  000.018: require('paradox.colors')
017.237  000.284  000.209: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/paradox.nvim/colors/paradox.lua
017.239  000.331  000.047: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.541  000.102  000.102: require('snacks')
017.543  000.107  000.006: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/snacks.nvim/plugin/snacks.lua
018.614  000.808  000.808: require('vim.diagnostic')
019.453  000.398  000.398: require('vim.lsp.protocol')
019.466  000.477  000.079: require('vim.lsp.log')
020.158  000.690  000.690: require('vim.lsp.util')
020.364  000.098  000.098: require('vim.lsp.sync')
020.367  000.208  000.110: require('vim.lsp._changetracking')
020.634  000.071  000.071: require('vim.lsp._transport')
020.638  000.003  000.003: require('vim._core.stringbuffer')
020.642  000.274  000.200: require('vim.lsp.rpc')
020.671  002.055  000.406: require('vim.lsp')
020.674  002.955  000.093: require('statuscol.builtin')
020.887  000.212  000.212: require('statuscol')
020.907  000.007  000.007: require('ffi')
020.913  000.024  000.017: require('statuscol.ffidef')
021.066  000.019  000.019: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
021.485  000.126  000.126: require('nvim-navic.lib')
021.487  000.255  000.129: require('nvim-navic')
021.762  000.045  000.045: require('lualine_require')
021.891  000.402  000.357: require('lualine')
021.981  000.007  000.007: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.497  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.506  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.511  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.524  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.528  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.535  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.538  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.546  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.550  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.553  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.558  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.563  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.566  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.570  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.574  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
022.580  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.039  000.026  000.026: require('lualine.utils.mode')
023.158  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.166  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.273  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.279  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.284  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.287  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.295  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.300  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.305  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.310  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.315  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.319  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.322  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.326  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.329  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.344  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.349  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.353  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.356  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.361  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.364  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.368  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.372  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.444  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.447  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.450  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.453  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.691  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.696  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.700  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.704  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.708  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.711  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.716  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.722  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.726  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.729  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.734  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.737  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.740  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.745  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.749  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.755  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.757  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.760  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.764  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.769  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.772  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.777  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.780  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.784  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.787  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.790  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.794  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.797  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.876  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.901  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.912  000.009  000.009: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.917  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
023.920  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
024.064  000.026  000.026: require('repeat')
024.199  000.042  000.042: require('neo-option')
025.499  000.065  000.065: require('vim.treesitter.language')
025.520  000.018  000.018: require('vim.func')
025.590  000.068  000.068: require('vim.treesitter._range')
025.636  000.044  000.044: require('vim.func._memoize')
025.656  000.555  000.359: require('vim.treesitter.query')
025.678  000.966  000.412: require('vim.treesitter.languagetree')
025.683  001.254  000.287: require('vim.treesitter')
025.853  000.169  000.169: require('vim.treesitter._fold')
027.942  000.113  000.113: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/filetypes.lua
027.997  000.039  000.039: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/nvim-treesitter.lua
028.023  000.019  000.019: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/query_predicates.lua
028.071  000.022  000.022: require('nvim-treesitter')
028.136  000.064  000.064: require('nvim-treesitter.config')
028.457  000.142  000.142: require('nvim-treesitter.async')
028.497  000.039  000.039: require('nvim-treesitter.log')
029.002  000.504  000.504: require('nvim-treesitter.parsers')
029.017  000.014  000.014: require('nvim-treesitter.util')
029.022  000.884  000.184: require('nvim-treesitter.install')
029.475  000.451  000.451: require('nvim-treesitter.parsers')
029.958  000.102  000.102: require('gitsigns')
030.181  000.210  000.210: require('gitsigns.highlight')
030.301  000.116  000.116: require('gitsigns.debug.log')
030.442  000.139  000.139: require('gitsigns.config')
030.632  000.039  000.039: require('gitsigns.debounce')
030.638  000.787  000.180: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/gitsigns.nvim/plugin/gitsigns.lua
030.912  028.300  007.547: sourcing /home/luoqing/.config/nvim/init.lua
030.916  000.281: sourcing vimrc file(s)
031.034  000.009  000.009: sourcing /home/luoqing/.local/share/nvim/site/ftdetect/ghostty.vim
031.073  000.006  000.006: sourcing /usr/share/nvim/site/ftdetect/ghostty.vim
031.091  000.005  000.005: sourcing /usr/share/vim/vimfiles/ftdetect/ghostty.vim
031.094  000.099  000.079: sourcing nvim_exec2() called at /usr/share/nvim/runtime/filetype.lua:0
031.095  000.134  000.035: sourcing /usr/share/nvim/runtime/filetype.lua
031.176  000.033  000.033: sourcing /usr/share/nvim/runtime/syntax/synload.vim
031.215  000.105  000.072: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
031.300  000.011  000.011: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/gitsigns.nvim/plugin/gitsigns.lua
031.405  000.076  000.076: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/filetypes.lua
031.438  000.027  000.027: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/nvim-treesitter.lua
031.461  000.017  000.017: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/query_predicates.lua
031.491  000.004  000.004: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
031.514  000.003  000.003: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/snacks.nvim/plugin/snacks.lua
031.687  000.072  000.072: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
031.890  000.077  000.077: sourcing /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim
031.905  000.212  000.136: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
031.966  000.056  000.056: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
031.976  000.004  000.004: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
032.035  000.054  000.054: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
032.080  000.039  000.039: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
032.092  000.007  000.007: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
032.152  000.054  000.054: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
032.179  000.022  000.022: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
032.212  000.028  000.028: sourcing /usr/share/nvim/runtime/plugin/man.lua
032.251  000.033  000.033: sourcing /usr/share/nvim/runtime/plugin/nvim/net.lua
032.267  000.011  000.011: sourcing /usr/share/nvim/runtime/plugin/nvim/spellfile.lua
032.312  000.040  000.040: sourcing /usr/share/nvim/runtime/plugin/osc52.lua
032.371  000.052  000.052: sourcing /usr/share/nvim/runtime/plugin/shada.lua
032.394  000.014  000.014: sourcing /usr/share/nvim/runtime/plugin/tohtml.lua
032.624  000.207  000.207: sourcing /usr/share/vim/vimfiles/plugin/fzf.vim
032.656  000.006  000.006: sourcing /home/luoqing/vimcdoc-2.5.0/plugin/vimcdoc.vim
032.657  000.456: loading rtp plugins
032.697  000.040: loading packages
032.698  000.001: loading after plugins
032.702  000.004: inits 3
033.268  000.566: reading ShaDa
033.299  000.031: opening buffers
033.380  000.076  000.076: require('snacks.explorer')
033.420  000.045: BufEnter autocommands
033.421  000.001: editing files in windows
033.548  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.691  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.694  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.695  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.697  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.699  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.700  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.701  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.702  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.704  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.705  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.706  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.707  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.708  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.709  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.710  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.711  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.712  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.714  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.715  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.716  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.717  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.718  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.720  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.721  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.722  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.723  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.734  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.735  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.736  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.737  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.738  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.739  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.741  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.742  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.743  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.744  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.745  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.746  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.747  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.748  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.750  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.751  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.752  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.753  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.754  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.756  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.757  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.758  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.759  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.760  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.761  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.762  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.763  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.777  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.779  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.784  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.785  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.786  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.787  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.788  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.789  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.790  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.792  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.793  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.794  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.802  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.808  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.812  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.815  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.820  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.829  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.831  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.835  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.838  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.843  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.846  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.880  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.882  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.886  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.888  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.893  000.004  000.004: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.929  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.932  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.954  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.957  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.960  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.963  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.965  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.968  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.971  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.975  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.977  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.980  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.983  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.985  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.988  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
033.990  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.003  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.006  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.017  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.020  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.023  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.026  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.029  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.033  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.036  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.038  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.045  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.095  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.098  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.101  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.103  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.106  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.108  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.138  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.143  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.145  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.148  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.150  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.153  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.156  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.159  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.194  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.196  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.199  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.202  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.204  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.206  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.209  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.213  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.290  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.292  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.294  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.297  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.300  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.302  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.327  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.349  000.007  000.007: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.356  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.360  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.364  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
034.377  000.831: VimEnter autocommands
034.734  000.208  000.208: require('snacks.util')
034.883  000.103  000.103: require('vim.ui')
034.886  000.505  000.194: require('snacks.input')
034.935  000.047  000.047: require('snacks.picker')
035.074  000.138  000.138: require('snacks.picker.config')
035.214  000.131  000.131: require('snacks.picker.config.highlights')
035.340  000.125  000.125: require('snacks.picker.config.defaults')
035.680  000.339  000.339: require('snacks.picker.config.sources')
035.756  000.075  000.075: require('snacks.picker.config.layouts')
036.978  001.241: UIEnter autocommands
037.128  000.115  000.115: sourcing /usr/share/nvim/runtime/autoload/provider/clipboard.vim
037.131  000.038: before starting main loop
037.261  000.130: first screen update
037.262  000.001: --- NVIM STARTED ---

--- Startup times for process: Embedded ---

times in msec
 clock   self+sourced   self:  sourced script
 clock   elapsed:              other lines

000.001  000.001: --- NVIM STARTING ---
000.071  000.070: event init
000.121  000.050: early init
000.143  000.022: locale set
000.164  000.020: init first window
000.407  000.243: inits 1
000.415  000.008: window checked
000.417  000.002: parsing arguments
000.765  000.035  000.035: require('vim._core.shared')
000.826  000.002  000.002: require('string.buffer')
000.846  000.034  000.032: require('vim.inspect')
000.883  000.031  000.031: require('vim._core.options')
000.888  000.121  000.056: require('vim._core.editor')
000.968  000.079  000.079: require('vim._core.system')
000.971  000.255  000.021: require('vim._init_packages')
000.972  000.301: init lua interpreter
001.001  000.029: expanding arguments
001.009  000.008: inits 2
001.147  000.138: init highlight
001.147  000.001: waiting for UI
001.195  000.047: done waiting for UI
001.199  000.004: clear screen
001.284  000.008  000.008: require('vim.keymap')
001.640  000.054  000.054: sourcing nvim_exec2()
001.932  000.732  000.670: require('vim._core.defaults')
001.933  000.002: init default mappings & autocommands
002.072  000.021  000.021: sourcing /usr/share/nvim/runtime/ftplugin.vim
002.093  000.009  000.009: sourcing /usr/share/nvim/runtime/indent.vim
002.112  000.005  000.005: sourcing /usr/share/nvim/archlinux.vim
002.113  000.013  000.008: sourcing /etc/xdg/nvim/sysinit.vim
002.800  000.042  000.042: require('vim._async')
002.931  000.130  000.130: require('vim.version')
003.184  000.981  000.810: require('vim.pack')
003.202  000.013  000.013: require('vim.fs')
003.247  000.002  000.002: require('vim.F')
003.452  000.011  000.011: require('global')
003.485  000.032  000.032: require('command')
003.504  000.018  000.018: require('autocmds')
003.537  000.015  000.015: require('native-packer.key')
003.576  000.039  000.039: require('keymaps/buffer')
003.690  000.113  000.113: require('native-packer.key.core')
003.890  000.026  000.026: require('keymaps/change')
003.919  000.012  000.012: require('keymaps/comment')
003.964  000.011  000.011: require('keymaps/copy')
004.074  000.087  000.087: require('keymaps/delete')
004.327  000.039  000.039: require('keymaps/diagnostic')
004.410  000.012  000.012: require('keymaps/directory')
004.486  000.053  000.053: require('keymaps/file')
004.566  000.013  000.013: require('keymaps/fold')
004.633  000.030  000.030: require('keymaps/indent')
004.796  000.064  000.064: require('builtin.insert-line')
004.813  000.159  000.095: require('keymaps/insert-line')
004.973  000.023  000.023: require('keymaps/jump')
005.061  000.039  000.039: require('keymaps/location-list')
005.091  000.010  000.010: require('keymaps/lsp')
005.105  000.006  000.006: require('keymaps/macro')
005.132  000.024  000.024: require('keymaps/misc')
005.374  000.138  000.138: require('keymaps/move')
006.021  000.012  000.012: require('keymaps/nop')
006.042  000.011  000.011: require('keymaps/operator')
006.076  000.017  000.017: require('keymaps/paste')
006.141  000.030  000.030: require('keymaps/quickfix')
006.168  000.013  000.013: require('keymaps/quit')
006.207  000.016  000.016: require('keymaps/register')
006.216  000.006  000.006: require('keymaps/screen-move')
006.297  000.080  000.080: require('keymaps/scroll')
006.511  000.043  000.043: require('keymaps/search')
006.608  000.078  000.078: require('keymaps/start-insert-mode')
006.737  000.019  000.019: require('keymaps/start-select-mode')
006.794  000.024  000.024: require('keymaps/start-visual-mode')
006.820  000.013  000.013: require('keymaps/stop-insert-mode')
006.984  000.095  000.095: require('keymaps/switch-option')
007.186  000.100  000.100: require('keymaps/tabpage')
007.259  000.012  000.012: require('keymaps/tagstack')
007.281  000.010  000.010: require('keymaps/terminal')
007.349  000.053  000.053: require('keymaps/textobject')
007.497  000.023  000.023: require('keymaps/tmux-fixed')
007.545  000.007  000.007: require('keymaps/undo')
007.577  000.028  000.028: require('keymaps/window')
007.683  000.056  000.056: require('keymaps/word-move')
007.826  000.038  000.038: require('keymaps/test')
007.835  004.331  002.696: require('keymaps')
007.867  000.031  000.031: require('native-packer')
007.910  000.042  000.042: require('plugins.download.style')
007.929  000.018  000.018: require('plugins.download.style.statuscol')
007.956  000.026  000.026: require('plugins.download.style.lualine')
007.962  000.006  000.006: require('plugins.download.misc.repeat')
007.967  000.005  000.005: require('plugins.local.undotree')
008.011  000.043  000.043: require('plugins.local.neo-option')
008.026  000.015  000.015: require('plugins.download.misc.linefuse')
008.045  000.018  000.018: require('plugins.local.move-line')
008.056  000.011  000.011: require('plugins.local.move-word')
008.062  000.006  000.006: require('plugins.local.file-details')
008.115  000.052  000.052: require('plugins.local.neo-lsp')
008.167  000.052  000.052: require('plugins.local.code-action')
008.193  000.025  000.025: require('plugins.local.op-register')
008.200  000.006  000.006: require('plugins.local.simple-translate')
008.338  000.138  000.138: require('plugins.local.treesitter-textobject')
008.347  000.008  000.008: require('plugins.download.misc.lazydev')
008.372  000.024  000.024: require('plugins.download.misc.zen')
008.393  000.021  000.021: require('plugins.download.snippet.luasnip')
008.451  000.058  000.058: require('plugins.download.cmp.blink-cmp')
008.679  000.028  000.028: require('plugins.download.eye-track.cword')
008.689  000.238  000.210: require('plugins.download.eye-track')
008.833  000.143  000.143: require('plugins.download.fzf')
008.861  000.027  000.027: require('plugins.download.format.conform')
008.884  000.022  000.022: require('plugins.download.treesitter')
008.899  000.015  000.015: require('plugins.download.filemanager.oil')
008.911  000.011  000.011: require('plugins.download.misc.tiny-inline-diagnostic')
008.918  000.007  000.007: require('plugins.download.misc.autopairs')
008.929  000.010  000.010: require('plugins.download.misc.nvim-ts-autotag')
008.940  000.011  000.011: require('plugins.download.misc.supermaven')
008.952  000.011  000.011: require('plugins.download.misc.grug-far')
008.990  000.038  000.038: require('plugins.download.misc.toggleterm')
008.998  000.007  000.007: require('plugins.download.git.gitsigns')
009.011  000.013  000.013: require('plugins.download.tmux.vim-tmux-navigator')
009.033  000.021  000.021: require('plugins.download.window.winshift')
009.054  000.020  000.020: require('plugins.download.misc.flash')
009.074  000.019  000.019: require('plugins.download.misc.snacks')
009.143  000.069  000.069: require('plugins.download.tex')
009.164  000.020  000.020: require('plugins.download.markdown')
009.176  000.012  000.012: require('plugins.download.misc.neotest')
009.246  000.070  000.070: require('plugins.download.misc.outline')
009.256  000.009  000.009: require('plugins.local.bufferman')
009.414  000.016  000.016: require('native-packer.handler')
009.429  000.015  000.015: require('native-packer.depend')
009.432  000.175  000.145: require('native-packer.core')
009.480  000.042  000.042: require('native-packer.handler.cmd')
009.506  000.025  000.025: require('native-packer.handler.colorscheme')
009.536  000.028  000.028: require('native-packer.handler.event')
009.558  000.022  000.022: require('native-packer.handler.ft')
009.589  000.030  000.030: require('native-packer.handler.key')
010.305  000.285  000.285: require('vim.iter')
011.213  000.205  000.205: require('paradox')
011.373  000.029  000.029: require('paradox.colors.light')
011.399  000.024  000.024: require('paradox.colors.dark')
011.400  000.071  000.018: require('paradox.colors')
011.593  000.272  000.201: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/paradox.nvim/colors/paradox.lua
011.595  000.309  000.037: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
011.869  000.098  000.098: require('snacks')
011.870  000.103  000.006: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/snacks.nvim/plugin/snacks.lua
012.904  000.780  000.780: require('vim.diagnostic')
013.707  000.374  000.374: require('vim.lsp.protocol')
013.721  000.453  000.079: require('vim.lsp.log')
014.394  000.671  000.671: require('vim.lsp.util')
014.588  000.091  000.091: require('vim.lsp.sync')
014.590  000.195  000.105: require('vim.lsp._changetracking')
014.824  000.061  000.061: require('vim.lsp._transport')
014.828  000.003  000.003: require('vim._core.stringbuffer')
014.833  000.242  000.178: require('vim.lsp.rpc')
014.861  001.954  000.393: require('vim.lsp')
014.863  002.827  000.092: require('statuscol.builtin')
015.066  000.202  000.202: require('statuscol')
015.083  000.006  000.006: require('ffi')
015.090  000.021  000.015: require('statuscol.ffidef')
015.224  000.017  000.017: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
015.636  000.124  000.124: require('nvim-navic.lib')
015.638  000.254  000.130: require('nvim-navic')
015.918  000.049  000.049: require('lualine_require')
016.047  000.406  000.358: require('lualine')
016.171  000.007  000.007: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.692  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.701  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.705  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.710  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.714  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.718  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.721  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.725  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.731  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.734  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.738  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.742  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.745  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.748  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.751  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
016.758  000.005  000.005: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.224  000.025  000.025: require('lualine.utils.mode')
017.356  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.363  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.460  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.466  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.471  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.474  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.478  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.481  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.489  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.495  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.500  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.503  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.507  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.510  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.513  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.518  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.523  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.527  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.531  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.535  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.538  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.542  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.546  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.616  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.619  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.621  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.624  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.808  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.813  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.817  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.820  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.824  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.830  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.834  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.840  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.844  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.849  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.852  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.855  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.861  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.865  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.871  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.880  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.924  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.932  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.951  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.972  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.977  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.982  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.985  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.989  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.991  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.995  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
017.997  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
018.010  000.001  000.001: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
018.052  000.004  000.004: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
018.074  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
018.083  000.007  000.007: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
018.088  000.003  000.003: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
018.091  000.002  000.002: sourcing nvim_exec2() called at /home/luoqing/.config/nvim/init.lua:0
018.225  000.026  000.026: require('repeat')
018.373  000.041  000.041: require('neo-option')
019.591  000.061  000.061: require('vim.treesitter.language')
019.611  000.018  000.018: require('vim.func')
019.679  000.067  000.067: require('vim.treesitter._range')
019.721  000.040  000.040: require('vim.func._memoize')
019.737  000.522  000.336: require('vim.treesitter.query')
019.756  000.920  000.398: require('vim.treesitter.languagetree')
019.761  001.202  000.282: require('vim.treesitter')
019.933  000.171  000.171: require('vim.treesitter._fold')
021.753  000.102  000.102: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/filetypes.lua
021.799  000.036  000.036: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/nvim-treesitter.lua
021.826  000.020  000.020: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/query_predicates.lua
021.868  000.020  000.020: require('nvim-treesitter')
021.937  000.068  000.068: require('nvim-treesitter.config')
022.257  000.139  000.139: require('nvim-treesitter.async')
022.298  000.040  000.040: require('nvim-treesitter.log')
022.787  000.489  000.489: require('nvim-treesitter.parsers')
022.802  000.014  000.014: require('nvim-treesitter.util')
022.806  000.867  000.186: require('nvim-treesitter.install')
023.267  000.459  000.459: require('nvim-treesitter.parsers')
023.826  000.094  000.094: require('gitsigns')
024.043  000.204  000.204: require('gitsigns.highlight')
024.160  000.114  000.114: require('gitsigns.debug.log')
024.296  000.135  000.135: require('gitsigns.config')
024.492  000.040  000.040: require('gitsigns.debounce')
024.497  000.771  000.183: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/gitsigns.nvim/plugin/gitsigns.lua
024.808  022.686  007.024: sourcing /home/luoqing/.config/nvim/init.lua
024.811  000.149: sourcing vimrc file(s)
024.931  000.008  000.008: sourcing /home/luoqing/.local/share/nvim/site/ftdetect/ghostty.vim
024.970  000.006  000.006: sourcing /usr/share/nvim/site/ftdetect/ghostty.vim
024.988  000.005  000.005: sourcing /usr/share/vim/vimfiles/ftdetect/ghostty.vim
024.992  000.098  000.079: sourcing nvim_exec2() called at /usr/share/nvim/runtime/filetype.lua:0
024.993  000.143  000.045: sourcing /usr/share/nvim/runtime/filetype.lua
025.069  000.031  000.031: sourcing /usr/share/nvim/runtime/syntax/synload.vim
025.106  000.100  000.069: sourcing /usr/share/nvim/runtime/syntax/syntax.vim
025.187  000.011  000.011: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/gitsigns.nvim/plugin/gitsigns.lua
025.295  000.079  000.079: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/filetypes.lua
025.329  000.027  000.027: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/nvim-treesitter.lua
025.352  000.018  000.018: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-treesitter/plugin/query_predicates.lua
025.382  000.003  000.003: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/nvim-web-devicons/plugin/nvim-web-devicons.vim
025.405  000.003  000.003: sourcing /home/luoqing/.local/share/nvim/site/pack/core/opt/snacks.nvim/plugin/snacks.lua
025.578  000.071  000.071: sourcing /usr/share/nvim/runtime/plugin/gzip.vim
025.774  000.074  000.074: sourcing /usr/share/nvim/runtime/pack/dist/opt/matchit/plugin/matchit.vim
025.789  000.205  000.131: sourcing /usr/share/nvim/runtime/plugin/matchit.vim
025.845  000.051  000.051: sourcing /usr/share/nvim/runtime/plugin/matchparen.vim
025.853  000.003  000.003: sourcing /usr/share/nvim/runtime/plugin/netrwPlugin.vim
025.917  000.058  000.058: sourcing /usr/share/nvim/runtime/plugin/rplugin.vim
025.960  000.038  000.038: sourcing /usr/share/nvim/runtime/plugin/tarPlugin.vim
025.970  000.006  000.006: sourcing /usr/share/nvim/runtime/plugin/tutor.vim
026.028  000.052  000.052: sourcing /usr/share/nvim/runtime/plugin/zipPlugin.vim
026.053  000.020  000.020: sourcing /usr/share/nvim/runtime/plugin/editorconfig.lua
026.086  000.029  000.029: sourcing /usr/share/nvim/runtime/plugin/man.lua
026.123  000.032  000.032: sourcing /usr/share/nvim/runtime/plugin/nvim/net.lua
026.139  000.011  000.011: sourcing /usr/share/nvim/runtime/plugin/nvim/spellfile.lua
026.184  000.041  000.041: sourcing /usr/share/nvim/runtime/plugin/osc52.lua
026.240  000.051  000.051: sourcing /usr/share/nvim/runtime/plugin/shada.lua
026.264  000.014  000.014: sourcing /usr/share/nvim/runtime/plugin/tohtml.lua
026.495  000.208  000.208: sourcing /usr/share/vim/vimfiles/plugin/fzf.vim
026.524  000.006  000.006: sourcing /home/luoqing/vimcdoc-2.5.0/plugin/vimcdoc.vim
026.526  000.434: loading rtp plugins
026.563  000.038: loading packages
026.564  000.000: loading after plugins
026.569  000.005: inits 3
027.132  000.564: reading ShaDa
027.161  000.029: opening buffers
027.239  000.073  000.073: require('snacks.explorer')
027.278  000.044: BufEnter autocommands
027.279  000.001: editing files in windows
027.351  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.489  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.491  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.495  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.496  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.497  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.507  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.508  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.517  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.519  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.520  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.521  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.522  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.523  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.525  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.526  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.527  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.528  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.530  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.531  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.532  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.533  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.534  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.535  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.536  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.537  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.538  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.548  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.549  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.550  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.551  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.552  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.553  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.555  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.556  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.557  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.558  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.559  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.561  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.562  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.563  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.564  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.565  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.566  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.567  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.568  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.569  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.570  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.571  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.572  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.573  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.575  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.576  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.577  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.578  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.579  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.580  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.581  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.582  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.583  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.584  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.585  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.586  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.588  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.589  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.590  000.000  000.000: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.597  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.603  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.606  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.610  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.613  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.618  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.620  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.623  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.626  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.629  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.632  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.635  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.637  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.644  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.646  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.651  000.004  000.004: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.717  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.720  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.758  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.761  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.765  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.767  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.783  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.787  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.790  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.802  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.810  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.818  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.829  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.839  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.843  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.846  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.849  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.852  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.854  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.857  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.859  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.862  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.865  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.869  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.871  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.879  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.886  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.926  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.929  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.932  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.934  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.937  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.939  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.942  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.946  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.949  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.952  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.954  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.957  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.959  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.962  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.965  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.968  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.970  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.972  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.974  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.977  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.980  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.985  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.987  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.989  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.992  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.994  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
027.996  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
028.001  000.001  000.001: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
028.019  000.005  000.005: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
028.035  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
028.041  000.004  000.004: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
028.046  000.003  000.003: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
028.049  000.002  000.002: sourcing nvim_exec2() called at OptionSet Autocommands for "background":0
028.070  000.675: VimEnter autocommands
028.451  000.231  000.231: require('snacks.util')
028.584  000.105  000.105: require('vim.ui')
028.587  000.512  000.176: require('snacks.input')
028.636  000.048  000.048: require('snacks.picker')
028.783  000.145  000.145: require('snacks.picker.config')
028.936  000.152  000.152: require('snacks.picker.config.highlights')
029.092  000.154  000.154: require('snacks.picker.config.defaults')
029.413  000.320  000.320: require('snacks.picker.config.sources')
029.484  000.070  000.070: require('snacks.picker.config.layouts')
030.636  001.164: UIEnter autocommands
030.788  000.115  000.115: sourcing /usr/share/nvim/runtime/autoload/provider/clipboard.vim
030.791  000.040: before starting main loop
030.926  000.135: first screen update
030.927  000.001: --- NVIM STARTED ---

