extends Control

const AREA_SIZE: Vector2 = Vector2(405, 540)
const AREA_POS: Vector2 = Vector2(100, 90)
const PHOTO_SCALE: int = 2   # photo enregistrée en 810 x 1080

var vp: SubViewport
var bg_rect: TextureRect
var frame_rect: TextureRect
var msg: Label
var dragging: bool = false

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var screen: Vector2 = get_viewport_rect().size

	var base: ColorRect = ColorRect.new()
	base.color = UIStyle.PINK_BG
	base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(base)
	base.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# Bordure blanche autour de la photo
	var border: Panel = Panel.new()
	border.add_theme_stylebox_override("panel", UIStyle.box(Color.WHITE, 0))
	border.position = AREA_POS - Vector2(10, 10)
	border.size = AREA_SIZE + Vector2(20, 20)
	border.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(border)

	# La photo est dessinée dans un SubViewport (c'est ce qui est enregistré)
	vp = SubViewport.new()
	vp.size = Vector2i(AREA_SIZE * PHOTO_SCALE)
	vp.size_2d_override = Vector2i(AREA_SIZE)
	vp.size_2d_override_stretch = true
	vp.transparent_bg = false
	vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(vp)

	var view: TextureRect = TextureRect.new()
	view.texture = vp.get_texture()
	view.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	view.stretch_mode = TextureRect.STRETCH_SCALE
	view.position = AREA_POS
	view.size = AREA_SIZE
	view.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(view)

	var white: ColorRect = ColorRect.new()
	white.color = Color.WHITE
	white.size = AREA_SIZE
	vp.add_child(white)

	bg_rect = TextureRect.new()
	bg_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg_rect.size = AREA_SIZE
	vp.add_child(bg_rect)

	var doll: AnimalDoll = AnimalDoll.new()
	doll.position = Vector2(AREA_SIZE.x * 0.5, AREA_SIZE.y * 0.64)
	vp.add_child(doll)
	doll.setup(Global.chosen_animal, 340.0)

	frame_rect = TextureRect.new()
	frame_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame_rect.stretch_mode = TextureRect.STRETCH_SCALE
	frame_rect.size = AREA_SIZE
	frame_rect.pivot_offset = AREA_SIZE / 2.0
	frame_rect.z_index = 10
	vp.add_child(frame_rect)

	# Réglages du cadre
	var tools: VBoxContainer = UIStyle.make_tools(
		func(): _scale_frame(1.1),
		func(): _scale_frame(1.0 / 1.1),
		func(): _rotate_frame(10.0),
		func(): _reset_frame())
	tools.position = Vector2(AREA_POS.x + AREA_SIZE.x + 20, 90)
	add_child(tools)

	# Panneau à onglets
	var panel: OptionPanel = OptionPanel.new()
	panel.position = Vector2(640, 90)
	add_child(panel)
	panel.add_section("Fonds", "res://art/backgrounds", _on_background, Vector2(104, 58), 3)
	panel.add_section("Cadres", "res://art/frame", _on_frame, Vector2(76, 101), 4, ["rectangle", "music_frame"])

	var hint: Label = Label.new()
	hint.text = "Glisse dans la photo pour déplacer le cadre. Molette = taille, Maj + molette = rotation."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.custom_minimum_size = Vector2(480, 0)
	hint.position = Vector2(640, 485)
	UIStyle.style_label(hint, 18)
	add_child(hint)

	msg = Label.new()
	msg.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	msg.custom_minimum_size = Vector2(480, 0)
	msg.position = Vector2(640, 530)
	UIStyle.style_label(msg, 16)
	add_child(msg)

	var row: HBoxContainer = HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.position = Vector2(640, screen.y - 70)
	add_child(row)

	var back: Button = Button.new()
	back.text = "Retour"
	UIStyle.style_button(back, 26)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scene/dress_up.tscn"))
	row.add_child(back)

	var shoot: Button = Button.new()
	shoot.text = "Photo"
	UIStyle.style_button(shoot, 26)
	shoot.pressed.connect(_take_photo)
	row.add_child(shoot)

	_on_background(Global.background_path)
	_on_frame(Global.frame_path)

# ---------- fonds et cadres ----------

func _on_background(path: String) -> void:
	Global.background_path = path
	if path == "":
		bg_rect.texture = null
	else:
		bg_rect.texture = load(path) as Texture2D

func _on_frame(path: String) -> void:
	Global.frame_path = path
	if path == "":
		frame_rect.texture = null
	else:
		frame_rect.texture = load(path) as Texture2D
		_reset_frame()

func _scale_frame(factor: float) -> void:
	var v: float = clampf(frame_rect.scale.x * factor, 0.3, 3.0)
	frame_rect.scale = Vector2(v, v)

func _rotate_frame(deg: float) -> void:
	frame_rect.rotation += deg_to_rad(deg)

func _reset_frame() -> void:
	frame_rect.position = Vector2.ZERO
	frame_rect.scale = Vector2.ONE
	frame_rect.rotation = 0.0

# ---------- déplacer le cadre à la souris ----------

func _in_view() -> bool:
	return Rect2(AREA_POS, AREA_SIZE).has_point(get_global_mouse_position())

func _unhandled_input(event: InputEvent) -> void:
	if frame_rect == null or frame_rect.texture == null:
		return
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index == MOUSE_BUTTON_LEFT:
			dragging = mb.pressed and _in_view()
		elif mb.pressed and _in_view():
			if mb.button_index == MOUSE_BUTTON_WHEEL_UP or mb.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				var up: bool = mb.button_index == MOUSE_BUTTON_WHEEL_UP
				if Input.is_key_pressed(KEY_SHIFT):
					_rotate_frame(5.0 if up else -5.0)
				else:
					_scale_frame(1.05 if up else 1.0 / 1.05)
	elif event is InputEventMouseMotion and dragging:
		var mm: InputEventMouseMotion = event
		frame_rect.position += mm.relative

# ---------- enregistrer la photo ----------

func _take_photo() -> void:
	await RenderingServer.frame_post_draw
	var img: Image = vp.get_texture().get_image()

	var base_dir: String = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	if base_dir == "":
		base_dir = ProjectSettings.globalize_path("user://")
	var dir: String = base_dir.path_join("CutieFarm")
	DirAccess.make_dir_recursive_absolute(dir)

	var stamp: String = Time.get_datetime_string_from_system().replace(":", "-").replace("T", "_")
	var path: String = dir.path_join("photo_" + stamp + ".png")
	var err: int = img.save_png(path)
	if err == OK:
		msg.text = "Photo enregistrée : " + path
	else:
		msg.text = "Impossible d'enregistrer la photo (erreur " + str(err) + ")."
