local config = require("config")
local colors = config.colors
local dimensions = config.dimens

-- Equivalent to the --bar domain
sbar.bar({
	height = dimensions.graphics.bar.height,
	color = colors.bar.bg,
	border_color = colors.bar.border,
	shadow = true,
	sticky = true,
	padding_right = dimensions.padding.bar,
	padding_left = dimensions.padding.bar,
	blur_radius = dimensions.graphics.blur_radius,
	topmost = "window",
})
