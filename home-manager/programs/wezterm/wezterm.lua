-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local function is_vim(pane)
    -- this is set by the plugin, and unset on ExitPre in Neovim
    return pane:get_user_vars().IS_NVIM == 'true'
end

local direction_keys = {
    Left = 'h',
    Down = 'j',
    Up = 'k',
    Right = 'l',
    -- reverse lookup
    h = 'Left',
    j = 'Down',
    k = 'Up',
    l = 'Right',
}

local function split_nav(resize_or_move, key)
    return {
        key = key,
        mods = resize_or_move == 'resize' and 'META' or 'CTRL',
        action = wezterm.action_callback(function(win, pane)
            if is_vim(pane) then
                -- pass the keys through to vim/nvim
                win:perform_action({
                    SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
                }, pane)
            else
                if resize_or_move == 'resize' then
                    win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
                else
                    win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
                end
            end
        end),
    }
end
-- my coolnight colorscheme
config.colors = {
    foreground = "#CBE0F0",
    background = "#011423",
    cursor_bg = "#47FF9C",
    cursor_border = "#47FF9C",
    cursor_fg = "#011423",
    selection_bg = "#033259",
    selection_fg = "#CBE0F0",
    ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
    brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
}

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

config.enable_tab_bar = true

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 10

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
    -- splitting
    {
        mods   = "LEADER",
        key    = "-",
        action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
    },
    {
        mods   = "LEADER",
        key    = "=",
        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
        mods = "LEADER",
        key = "Space",
        action = wezterm.action.RotatePanes "Clockwise"
    },
    {
        key = 'x',
        mods = 'CMD',
        action = wezterm.action.CloseCurrentPane { confirm = true },
    },
    -- show the pane selection mode, but have it swap the active and selected panes
    {
        mods = 'LEADER',
        key = '0',
        action = wezterm.action.PaneSelect {
            mode = 'SwapWithActive',
        },
    },
    {
        mods = 'LEADER',
        key = 'm',
        action = wezterm.action.TogglePaneZoomState
    },
    {
        key = 'Enter',
        mods = 'LEADER',
        action = wezterm.action.ActivateCopyMode
    },
    -- move between split panes
    split_nav('move', 'h'),
    split_nav('move', 'j'),
    split_nav('move', 'k'),
    split_nav('move', 'l'),
    -- resize panes
    split_nav('resize', 'h'),
    split_nav('resize', 'j'),
    split_nav('resize', 'k'),
    split_nav('resize', 'l'),
}

-- and finally, return the configuration to wezterm
return config
