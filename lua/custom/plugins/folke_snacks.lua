-- https://github.com/folke/snacks.nvim?tab=readme-ov-file
---@module "snacks"

return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    git = { enabled = true },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    ---@class snacks.lazygit.Config: snacks.terminal.Opts
    lazygit = {
      enabled = true,
      -- automatically configure lazygit to use the current colorscheme
      -- and integrate edit with the current neovim instance
      configure = true,
      -- extra configuration for lazygit that will be merged with the default
      -- snacks does NOT have a full yaml parser, so if you need `"test"` to appear with the quotes
      -- you need to double quote it: `"\"test\""`
      -- config = {
      --   os = { editPreset = 'nvim-remote' },
      --   gui = {
      --     -- set to an empty string "" to disable icons
      --     nerdFontsVersion = '3',
      --   },
      -- },
      -- theme_path = svim.fs.normalize(vim.fn.stdpath("cache") .. "/lazygit-theme.yml"),
      -- Theme for lazygit
      theme = {
        [241] = { fg = 'Special' },
        activeBorderColor = { fg = 'MatchParen', bold = true },
        cherryPickedCommitBgColor = { fg = 'Identifier' },
        cherryPickedCommitFgColor = { fg = 'Function' },
        defaultFgColor = { fg = 'Normal' },
        inactiveBorderColor = { fg = 'FloatBorder' },
        optionsTextColor = { fg = 'Function' },
        searchingActiveBorderColor = { fg = 'MatchParen', bold = true },
        selectedLineBgColor = { bg = 'Visual' }, -- set to `default` to have no background colour
        unstagedChangesColor = { fg = 'DiagnosticError' },
      },
      win = {
        style = 'lazygit',
      },
    },
    -- bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    -- picker = { enabled = true },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
  -- https://github.com/folke/snacks.nvim/tree/main?tab=readme-ov-file#-usage
  keys = {
    -- Git
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = '[G]it: [B]lame line',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = '[G]it: Launch Lazy[g]it',
    },
    {
      '<leader>gG',
      function()
        local current_dir = vim.fn.expand '%:p:h'
        local git_root = Snacks.git.get_root(current_dir)
        Snacks.lazygit {
          args = { '--path=' .. git_root },
        }
      end,
      desc = '[G]it: Launch Lazy[G]it',
    },
  },
}
