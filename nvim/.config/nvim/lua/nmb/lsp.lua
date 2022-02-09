local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local nvim_lsp = require('lspconfig')
local lspkind = require("lspkind")
--
-- lspconfig
--
local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    
    -- Mappings
    local opts = {noremap=true, silent=true }

    buf_set_keymap('n','gD','<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n','gd','<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n','gr','<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n','K','<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n','<leader>dl','<cmd>Telescope diagnostics<CR>', opts)
    buf_set_keymap('n','<leader>dj','<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n','<leader>dk','<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n','<leader>r','<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts) 
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end
-- nvim-cmp supports lsp capabilities
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Loop to setup multiple servers
servers = {'tsserver','pyright','gopls','rust_analyzer'}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        capabilities=capabilities,
        on_attach = on_attach
    }
end
--
-- Nvim-cmp setup
--

cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    }),
    formatting = {
        format = lspkind.cmp_format()
    },
  })
-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

