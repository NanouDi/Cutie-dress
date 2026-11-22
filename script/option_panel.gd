class_name OptionPanel
extends HBoxContainer

var tab_col: VBoxContainer
var stack: VBoxContainer
var tabs: Array = []

func _init() -> void:
	add_theme_constant_override("separation", 6)

	tab_col = VBoxContainer.new()
	tab_col.add_theme_constant_override("separation", 8)
	add_child(tab_col)

	var content: PanelContainer = PanelContainer.new()
	content.add_theme_stylebox_override("panel", UIStyle.box(UIStyle.PINK_BG, 10))
	add_child(content)

	stack = VBoxContainer.new()
	content.add_child(stack)

func add_section(title: String, dir: String, callback: Callable, thumb: Vector2 = Vector2(100, 100), columns: int = 4, exclude: Array = []) -> void:
	var idx: int = tabs.size()

	var tab: Button = Button.new()
	tab.text = title
	tab.focus_mode = Control.FOCUS_NONE
	tab.custom_minimum_size = Vector2(112, 48)
	tab.pressed.connect(_select.bind(idx))
	tab_col.add_child(tab)

	var scroll: ScrollContainer = ScrollContainer.new()
	var w: float = columns * thumb.x + (columns - 1) * 8 + 22
	scroll.custom_minimum_size = Vector2(w, 360)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.visible = false
	stack.add_child(scroll)

	var grid: GridContainer = GridContainer.new()
	grid.columns = columns
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	scroll.add_child(grid)

	var none: Button = Button.new()
	none.text = "Aucun"
	none.custom_minimum_size = thumb
	UIStyle.style_button(none, 18, 6)
	none.pressed.connect(callback.bind(""))
	grid.add_child(none)

	for path in AssetUtil.list_images(dir, exclude):
		var tex: Texture2D = load(path) as Texture2D
		if tex == null:
			continue
		var tb: TextureButton = TextureButton.new()
		tb.texture_normal = tex
		tb.ignore_texture_size = true
		tb.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		tb.custom_minimum_size = thumb
		tb.pressed.connect(callback.bind(path))
		tb.mouse_entered.connect(func(): tb.modulate = Color(1.15, 1.15, 1.15))
		tb.mouse_exited.connect(func(): tb.modulate = Color.WHITE)
		grid.add_child(tb)

	tabs.append({"tab": tab, "scroll": scroll})
	_select(0 if idx == 0 else _active_index())

func _active_index() -> int:
	for i in tabs.size():
		if tabs[i]["scroll"].visible:
			return i
	return 0

func _select(index: int) -> void:
	for i in tabs.size():
		var active: bool = i == index
		tabs[i]["scroll"].visible = active
		var b: Button = tabs[i]["tab"]
		if active:
			UIStyle.style_button(b, 24, 10)
		else:
			UIStyle.style_button_inverse(b, 24, 10)
