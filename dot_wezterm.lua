local wezterm = require("wezterm")

return {
	font = wezterm.font_with_fallback({
		"Ubuntu Mono", -- 英文、符號、程式碼主字型，舒服耐看
		"Noto Sans Mono CJK TC", -- 繁體優先
		"Noto Sans Mono CJK SC", -- 簡體 fallback
		"WenQuanYi Zen Hei Mono", -- 額外簡繁支援
	}),
	font_size = 14.0,
}
