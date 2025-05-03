local jdtls = require('jdtls')
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    root_dir = vim.fs.dirname(vim.fs.find({ 'settings.gradle', 'gradlew', '.git', 'mvnw', 'gradle.build' }, { upward = true })[1]),

    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {

        'java', -- or '/path/to/java17_or_newer/bin/java'
        -- depends on if `java` is in your $PATH env variable and if it points to the right version.

        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

        '-jar', '/home/there/.nvim/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
        '-configuration', '/home/there/.nvim/jdtls/config_linux',

        '-data', '/home/there/.nvim/jdtls/projects/' .. project_name,
    },

    init_options = {
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
    },

    on_attach = function(client, bufnr)
        -- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L88-L94
        local opts = { silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<C-f>', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,

    settings = {
        java = {
            configuration = {
                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- And search for `interface RuntimeOption`
                -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
                runtimes = {
                    {
                        name = "JavaSE-1.8",
                        path = "/usr/lib/jvm/java-8-openjdk-amd64/",
                    },
                    {
                        name = "JavaSE-11",
                        path = "/usr/lib/jvm/java-11-openjdk-amd64/",
                    },
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk-amd64/",
                    },
                    {
                        name = "JavaSE-19",
                        path = "/usr/lib/jvm/java-19-openjdk-amd64/",
                    },
                    {
                        default = true,
                        --name = "JavaSE-21",
                        path = "/snap/android-studio/current/jbr/",
                    },
                },
            },
            jdt = {
                ls = {
                    androidSupport = {
                        enabled = true,
                    }
                }
            },
            project = {
                referencedLibraries = {
                    '/home/there/processing-4.3/core/library/core.jar',
                }
            }
        }
    }
}

print(config.root_dir)

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
