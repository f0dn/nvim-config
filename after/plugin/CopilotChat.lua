local chat = require('CopilotChat')
local completion = require('CopilotChat.completion')
local functions = require('CopilotChat.functions')
local async = require('plenary.async')
local cmp = require('cmp')

chat.setup({
    chat_autocomplete = false,
})

local source = {}

source.new = function()
    return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
    local old_triggers = completion.info().triggers
    old_triggers[#old_triggers + 1] = ':'
    return old_triggers
end

source.get_keyword_pattern = function(self, params)
    return [[\k\+]]
end

source.complete = function(self, params, callback)
    -- idk why it doesn't work without this
    if vim.bo.filetype ~= 'copilot-chat' then
        return callback({ items = {}, isIncomplete = false })
    end

    local word = vim.fn.matchstr(params.context.cursor_before_line:sub(1, params.context.cursor.col - 1), [[\S\+$]])

    local prefix = string.sub(word, 1, 1)
    local suffix = string.sub(word, -1)

    if prefix == '#' and suffix == ':' then
        local found_tool = chat.config.functions[word:sub(2, -2)]
        local found_schema = found_tool and functions.parse_schema(found_tool)
        if found_tool and found_schema and found_tool.uri then
            local cfg
            local name
            for prop_name, prop_cfg in pairs(found_schema.properties) do
                cfg = prop_cfg
                name = prop_name
                break
            end
            if not found_schema.required or vim.tbl_contains(found_schema.required, name) then
                async.run(function()
                    local choices = {}
                    if cfg.enum then
                        local unformatted_choices = type(cfg.enum) == 'table' and cfg.enum or
                            cfg.enum(chat.chat:get_source())
                        if #unformatted_choices == 0 then
                            choices = unformatted_choices
                        else
                            local has_display = type(unformatted_choices[1]) == 'table' and
                                unformatted_choices[1].display ~= nil
                            if has_display then
                                for _, choice in ipairs(unformatted_choices) do
                                    choices[#choices + 1] = { label = choice.value, detail = choice.display }
                                end
                            else
                                for _, choice in ipairs(unformatted_choices) do
                                    choices[#choices + 1] = { label = choice }
                                end
                            end
                        end
                    elseif cfg.type == 'boolean' then
                        choices = { { label = 'true' }, { label = 'false' } }
                    end

                    local kind = cmp.lsp.CompletionItemKind.Text

                    if name == 'path' then
                        kind = cmp.lsp.CompletionItemKind.File
                    elseif name == 'url' then
                        kind = cmp.lsp.CompletionItemKind.Value
                    elseif name == 'scope' then
                        kind = cmp.lsp.CompletionItemKind.EnumMember
                    elseif name == 'pattern' then
                        kind = cmp.lsp.CompletionItemKind.Text
                    elseif name == 'target' then
                        kind = cmp.lsp.CompletionItemKind.EnumMember
                    end

                    local items = {}
                    for _, choice in ipairs(choices) do
                        items[#items + 1] = {
                            label = choice.label,
                            labelDetails = { detail = choice.detail },
                            kind = kind,
                        }
                    end

                    callback({ items = items, isIncomplete = false })
                end)
            end
        end
    else
        async.run(function()
            local filtered_items = {}
            for _, item in ipairs(completion.items()) do
                if suffix == item.word:sub(1, 1) then
                    filtered_items[#filtered_items + 1] = item
                end
            end

            local new_items = {}
            for _, item in ipairs(filtered_items) do
                local kind = cmp.lsp.CompletionItemKind.Text

                if item.kind == 'copilot' and suffix ~= '$' then
                    kind = cmp.lsp.CompletionItemKind.Reference
                elseif item.kind == 'group' then
                    kind = cmp.lsp.CompletionItemKind.Module
                elseif item.kind == 'tool' then
                    kind = cmp.lsp.CompletionItemKind.Function
                elseif item.kind == 'system' then
                    kind = cmp.lsp.CompletionItemKind.Text
                elseif item.kind == 'user' then
                    kind = cmp.lsp.CompletionItemKind.Text
                end

                new_items[#new_items + 1] = {
                    label = item.abbr,
                    labelDetails = { detail = item.menu },
                    kind = kind,
                    documentation = item.info,
                }
            end

            callback({ items = new_items, isIncomplete = false })
        end)
    end
end

cmp.register_source('CopilotChat', source.new())

cmp.setup.filetype({ 'copilot-chat' }, { sources = cmp.config.sources({ { name = 'CopilotChat' } }) })

vim.keymap.set({ 'n', 'v' }, '<leader>cc', chat.toggle)
