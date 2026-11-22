extends Node

var chosen_animal: String = "cow"
var top_path: String = ""
var bottom_path: String = ""
var background_path: String = ""
var frame_path: String = ""
var top_xf: Dictionary = {}
var bottom_xf: Dictionary = {}

func _ready() -> void:
	_setup_cursor()

func _setup_cursor() -> void:
	var p: String = AssetUtil.find("res://art/boutons/cursor1")
	if p == "":
		return
	var tex: Texture2D = load(p)
	var img: Image = tex.get_image()
	if img.is_compressed():
		img.decompress()
	var h: int = 64
	var w: int = maxi(1, int(img.get_width() * float(h) / float(img.get_height())))
	img.resize(w, h, Image.INTERPOLATE_LANCZOS)
	var cursor_tex: ImageTexture = ImageTexture.create_from_image(img)
	# Point de clic : milieu, tout en haut de la barbe à papa
	var hotspot: Vector2 = Vector2(w * 0.5, 6.0)
	Input.set_custom_mouse_cursor(cursor_tex, Input.CURSOR_ARROW, hotspot)
	Input.set_custom_mouse_cursor(cursor_tex, Input.CURSOR_POINTING_HAND, hotspot)
