local function T(en, zh)
    return (locale == "zh" or locale == "zhr" or locale == "zht" or locale == "ch" or locale == "chs") and zh or en
end

local WORKSHOP_URL = "https://steamcommunity.com/sharedfiles/filedetails/?id=3754814637"

name = T("Minimap HUD", "小地图 HUD")
description = T(
    "Adds a configurable minimap to the HUD.\n\n"..
    "Features:\n"..
    "- Adjustable size, position, margins, ultrawide scaling, and update throttling.\n"..
    "- Compatible with forest/cave shard switching.\n"..
    "- Forest and cave minimap zoom can be remembered separately.\n\n"..
    "Workshop: "..WORKSHOP_URL,

    "在 HUD 上添加可配置的小地图。\n\n"..
    "功能：\n"..
    "- 可调整大小、位置、边距、超宽屏比例和刷新限频。\n"..
    "- 兼容森林/洞穴分片切换。\n"..
    "- 森林和洞穴的小地图缩放可分别记忆。\n\n"..
    "Steam 创意工坊："..WORKSHOP_URL
)
author = "Codex"
version = "1.1.3"
forumthread = WORKSHOP_URL

api_version = 10
api_version_dst = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

client_only_mod = false
server_only_mod = false
all_clients_require_mod = true

server_filter_tags =
{
    "minimap",
    "hud",
    "map",
    "client hud",
    "小地图",
    "地图",
    "界面",
}

configuration_options =
{
    {
        name = "Minimap Size",
        label = T("Minimap Size", "小地图大小"),
        hover = T("Controls the HUD minimap's rendered size.", "调整 HUD 小地图的显示大小。"),
        options =
        {
            {description = T("Tiny", "极小"), data = 0.125},
            {description = T("Small", "小"), data = 0.175},
            {description = T("Medium", "中"), data = 0.225},
            {description = T("Large", "大"), data = 0.275},
            {description = T("Huge", "很大"), data = 0.325},
            {description = T("Giant", "巨大"), data = 0.375},
        },
        default = 0.225,
    },
    {
        name = "Ultrawide",
        label = T("Ultrawide Scaling", "超宽屏比例"),
        hover = T("Adjusts the minimap aspect ratio for ultrawide displays.", "为超宽屏显示器调整小地图宽高比例。"),
        options =
        {
            {description = T("Disabled", "关闭"), data = 1.000},
            {description = T("Enabled", "开启"), data = 1.146},
        },
        default = 1.000,
    },
    {
        name = "Position",
        label = T("Position", "位置"),
        hover = T("Chooses where the minimap is anchored on the HUD.", "选择小地图在 HUD 上的锚定位置。"),
        options =
        {
            {description = T("Top Right", "右上"), data = "top_right"},
            {description = T("Top Left", "左上"), data = "top_left"},
            {description = T("Top Center", "顶部居中"), data = "top_center"},
            {description = T("Middle Left", "左侧居中"), data = "middle_left"},
            {description = T("Middle Center", "正中"), data = "middle_center"},
            {description = T("Middle Right", "右侧居中"), data = "middle_right"},
            {description = T("Bottom Left", "左下"), data = "bottom_left"},
            {description = T("Bottom Center", "底部居中"), data = "bottom_center"},
            {description = T("Bottom Right", "右下"), data = "bottom_right"},
        },
        default = "top_right",
    },
    {
        name = "Horizontal Margin",
        label = T("Horizontal Margin", "水平边距"),
        hover = T("Moves the minimap inward or outward on the horizontal axis.", "沿水平方向调整小地图与屏幕边缘的距离。"),
        options =
        {
            {description = T("None", "无"), data = 0},
            {description = T("Very Tiny", "极细"), data = 5},
            {description = T("Tiny", "很小"), data = 12.5},
            {description = T("Very Small", "较小"), data = 25},
            {description = T("Small", "小"), data = 50},
            {description = T("Medium", "中"), data = 125},
            {description = T("Large", "大"), data = 235},
            {description = T("Huge", "很大"), data = 350},
            {description = T("Giant", "巨大"), data = 450},
        },
        default = 235,
    },
    {
        name = "Vertical Margin",
        label = T("Vertical Margin", "垂直边距"),
        hover = T("Moves the minimap inward or outward on the vertical axis.", "沿垂直方向调整小地图与屏幕边缘的距离。"),
        options =
        {
            {description = T("None", "无"), data = 0},
            {description = T("Very Tiny", "极细"), data = 5},
            {description = T("Tiny", "很小"), data = 12.5},
            {description = T("Very Small", "较小"), data = 25},
            {description = T("Small", "小"), data = 50},
            {description = T("Medium", "中"), data = 125},
            {description = T("Large", "大"), data = 235},
            {description = T("Very Large", "较大"), data = 300},
            {description = T("Huge", "很大"), data = 350},
            {description = T("Giant", "巨大"), data = 450},
        },
        default = 25,
    },
    {
        name = "Updates Per Second",
        label = T("Update Throttling", "刷新限频"),
        hover = T("Limits minimap refresh frequency. Lower frequency may help FPS.", "限制小地图刷新频率。降低刷新频率可能有助于提升帧率。"),
        options =
        {
            {description = T("Default", "默认"), data = 0, hover = T("No throttling; keep the minimap up to date continuously.", "不限频；持续保持小地图实时更新。")},
            {description = T("10 ups", "每秒 10 次"), data = 0.1, hover = T("Update the map 10 times per second.", "小地图每秒刷新 10 次。")},
            {description = T("8 ups", "每秒 8 次"), data = 0.125, hover = T("Update the map 8 times per second.", "小地图每秒刷新 8 次。")},
            {description = T("6 ups", "每秒 6 次"), data = 0.166, hover = T("Update the map 6 times per second.", "小地图每秒刷新 6 次。")},
            {description = T("5 ups", "每秒 5 次"), data = 0.20, hover = T("Update the map 5 times per second.", "小地图每秒刷新 5 次。")},
            {description = T("4 ups", "每秒 4 次"), data = 0.25, hover = T("Update the map 4 times per second.", "小地图每秒刷新 4 次。")},
            {description = T("3 ups", "每秒 3 次"), data = 0.333, hover = T("Update the map 3 times per second.", "小地图每秒刷新 3 次。")},
            {description = T("2 ups", "每秒 2 次"), data = 0.5, hover = T("Update the map 2 times per second.", "小地图每秒刷新 2 次。")},
            {description = T("1 ups", "每秒 1 次"), data = 1, hover = T("Update the map every second.", "小地图每秒刷新 1 次。")},
            {description = T("4/5 ups", "5 秒 4 次"), data = 1.25, hover = T("Update the map 4 times in 5 seconds.", "小地图每 5 秒刷新 4 次。")},
            {description = T("2/3 ups", "3 秒 2 次"), data = 1.5, hover = T("Update the map 2 times in 3 seconds.", "小地图每 3 秒刷新 2 次。")},
            {description = T("1/2 ups", "2 秒 1 次"), data = 2, hover = T("Update the map every 2 seconds.", "小地图每 2 秒刷新 1 次。")},
            {description = T("1/3 ups", "3 秒 1 次"), data = 3, hover = T("Update the map every 3 seconds.", "小地图每 3 秒刷新 1 次。")},
            {description = T("1/4 ups", "4 秒 1 次"), data = 4, hover = T("Update the map every 4 seconds.", "小地图每 4 秒刷新 1 次。")},
            {description = T("1/5 ups", "5 秒 1 次"), data = 5, hover = T("Update the map every 5 seconds.", "小地图每 5 秒刷新 1 次。")},
            {description = T("1/6 ups", "6 秒 1 次"), data = 6, hover = T("Update the map every 6 seconds.", "小地图每 6 秒刷新 1 次。")},
            {description = T("1/8 ups", "8 秒 1 次"), data = 8, hover = T("Update the map every 8 seconds.", "小地图每 8 秒刷新 1 次。")},
            {description = T("1/10 ups", "10 秒 1 次"), data = 10, hover = T("Update the map every 10 seconds.", "小地图每 10 秒刷新 1 次。")},
            {description = T("1/30 ups", "30 秒 1 次"), data = 30, hover = T("Update the map every 30 seconds.", "小地图每 30 秒刷新 1 次。")},
        },
        default = 0,
    },
}
