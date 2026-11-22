class_name UIStyle
extends RefCounted

const FONT_PATH: String = "res://art/fonts/LEMONMILK-Medium.otf"

const PINK: Color = Color(1.0, 0.37, 0.66)
const PINK_LIGHT: Color = Color(1.0, 0.55, 0.76)
const PINK_DARK: Color = Color(0.86, 0.27, 0.55)
const PINK_BG: Color = Color(1.0, 0.89, 0.94)
const OUTLINE_COLOR: Color = Color(0.35, 0.12, 0.25)

static func get_font() -> Font:
	if ResourceLoader.exists(FONT_PATH):
		return load(FONT_PATH) as Font
	return null

static func style_label(label: Label, size: int = 36) -> void:
	var f: Font = get_font()
	if f != null:
		label.add_theme_font_override("font", f)
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	label.add_theme_constant_override("outline_size", maxi(2, int(size * 0.08)))

static func box(fill: Color, margin_h: int = 28, border: Color = OUTLINE_COLOR) -> StyleBoxFlat:
	var sb: StyleBoxFlat = StyleBoxFlat.new()
	sb.bg_color = fill
	sb.set_corner_radius_all(22)
	sb.set_border_width_all(2)
	sb.border_color = border
	sb.content_margin_left = margin_h
	sb.content_margin_right = margin_h
	sb.content_margin_top = 8
	sb.content_margin_bottom = 8
	return sb

# Bouton rose, écriture blanche
static func style_button(btn: Button, size: int = 32, margin_h: int = 28) -> void:
	btn.add_theme_stylebox_override("normal", box(PINK, margin_h))
	btn.add_theme_stylebox_override("hover", box(PINK_LIGHT, margin_h))
	btn.add_theme_stylebox_override("pressed", box(PINK_DARK, margin_h))
	btn.add_theme_stylebox_override("focus", box(PINK, margin_h))
	var f: Font = get_font()
	if f != null:
		btn.add_theme_font_override("font", f)
	btn.add_theme_font_size_override("font_size", size)
	for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		btn.add_theme_color_override(c, Color.WHITE)
	btn.add_theme_color_override("font_outline_color", OUTLINE_COLOR)
	btn.add_theme_constant_override("outline_size", maxi(2, int(size * 0.08)))

# Bouton blanc, écriture rose (l'inverse)
static func style_button_inverse(btn: Button, size: int = 28, margin_h: int = 20) -> void:
	btn.add_theme_stylebox_override("normal", box(Color.WHITE, margin_h, PINK))
	btn.add_theme_stylebox_override("hover", box(PINK_BG, margin_h, PINK))
	btn.add_theme_stylebox_override("pressed", box(Color(1.0, 0.8, 0.9), margin_h, PINK))
	btn.add_theme_stylebox_override("focus", box(Color.WHITE, margin_h, PINK))
	var f: Font = get_font()
	if f != null:
		btn.add_theme_font_override("font", f)
	btn.add_theme_font_size_override("font_size", size)
	for c in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
		btn.add_theme_color_override(c, PINK_DARK)
	btn.add_theme_constant_override("outline_size", 0)

# Colonne de réglage : + / - / Tourner / Reset
static func make_tools(on_plus: Callable, on_minus: Callable, on_rotate: Callable, on_reset: Callable) -> VBoxContainer:
	var col: VBoxContainer = VBoxContainer.new()
	col.add_theme_constant_override("separation", 8)
	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	col.add_child(row)
	row.add_child(_tool_btn("+", 34, Vector2(52, 48), on_plus))
	row.add_child(_tool_btn("-", 34, Vector2(52, 48), on_minus))
	col.add_child(_tool_btn("Tourner", 20, Vector2(112, 44), on_rotate))
	col.add_child(_tool_btn("Reset", 20, Vector2(112, 44), on_reset))
	return col

static func _tool_btn(text: String, size: int, min_size: Vector2, action: Callable) -> Button:
	var b: Button = Button.new()
	b.text = text
	b.focus_mode = Control.FOCUS_NONE
	b.custom_minimum_size = min_size
	style_button_inverse(b, size, 8)
	b.pressed.connect(action)
	return b
