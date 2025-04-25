-- https://github.com/ggml-org/llama.vim
-- needs model from llama.cpp (installed via brew install llama.cpp)
-- start the server with `llama-server --fim-qwen-3b-default`
return {
  'ggml-org/llama.vim',
  init = function()
    vim.g.llama_config = {
      auto_fim = true,
      keymap_trigger = '<C-F>',
      keymap_accept_full = '<S-Tab>',
      keymap_accept_line = '<C-l>',
      keymap_accept_word = '<C-B>',
    }
  end,
}
