extends CanvasLayer

const MUSIC_DIR: String = "res://art/music"

var player: AudioStreamPlayer
var songs: Array[String] = []
var header: Button
var play_btn: Button
var list_panel: PanelContainer
var icon_play: Texture2D
var icon_pause: Texture2D
var is_on: bool = false

func _ready() -> void:
	layer = 100
	player = AudioStreamPlayer.new()
	add_child(player)
	# Boucle : quand la musique finit, elle recommence
	player.finished.connect(func(): player.play())
	songs = AssetUtil.list_files(MUSIC_DIR, ["mp3", "ogg", "wav"])

	var p1: String = AssetUtil.find("res://art/boutons/run")
	var p2: String = AssetUtil.find("res://art/boutons/pause")
	if p1 != "":
		icon_play = load(p1)
	if p2 != "":
		icon_pause = load(p2)
	_build_ui()

func _build_ui() -> void:
	var root := Control.new()
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var box := VBoxContainer.new()
	box.position = Vector2(16, 16)
	box.add_theme_constant_override("separation", 6)
	root.add_child(box)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	box.add_child(row)

	header = Button.new()
	header.text = "Pas de musique"
	header.clip_text = true
	header.custom_minimum_size = Vector2(300, 48)
	UIStyle.style_button(header, 20)
	header.pressed.connect(func(): list_panel.visible = not list_panel.visible)
	row.add_child(header)

	play_btn = Button.new()
	play_btn.custom_minimum_size = Vector2(56, 48)
	UIStyle.style_button(play_btn, 20, 10)
	play_btn.add_theme_constant_override("icon_max_width", 26)
	play_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	play_btn.pressed.connect(_on_play_pressed)
	row.add_child(play_btn)
	_refresh_play_icon()

	list_panel = PanelContainer.new()
	list_panel.add_theme_stylebox_override("panel", UIStyle.box(UIStyle.PINK_BG, 12))
	list_panel.visible = false
	box.add_child(list_panel)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(340, 240)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	list_panel.add_child(scroll)

	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 6)
	scroll.add_child(list)

	var none := Button.new()
	none.text = "Pas de musique"
	none.custom_minimum_size = Vector2(300, 42)
	UIStyle.style_button(none, 18)
	none.pressed.connect(_stop)
	list.add_child(none)

	if songs.is_empty():
		header.text = "Aucune musique"
	for path in songs:
		var b := Button.new()
		b.text = path.get_file().get_basename()
		b.clip_text = true
		b.custom_minimum_size = Vector2(300, 42)
		UIStyle.style_button(b, 18)
		b.pressed.connect(_play_song.bind(path))
		list.add_child(b)

func _play_song(path: String) -> void:
	var stream: AudioStream = load(path) as AudioStream
	if stream == null:
		return
	player.stream = stream
	player.stream_paused = false
	player.play()
	is_on = true
	header.text = path.get_file().get_basename()
	list_panel.visible = false
	_refresh_play_icon()

func _stop() -> void:
	player.stop()
	player.stream = null
	is_on = false
	header.text = "Pas de musique"
	list_panel.visible = false
	_refresh_play_icon()

func _on_play_pressed() -> void:
	if player.stream == null:
		list_panel.visible = true
		return
	is_on = not is_on
	player.stream_paused = not is_on
	_refresh_play_icon()

func _refresh_play_icon() -> void:
	var tex: Texture2D = icon_pause if is_on else icon_play
	if tex != null:
		play_btn.icon = tex
		play_btn.text = ""
	else:
		play_btn.text = "II" if is_on else ">"
