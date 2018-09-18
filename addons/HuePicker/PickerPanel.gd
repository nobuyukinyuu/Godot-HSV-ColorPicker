tool
extends Panel

export(Color) var color setget color_changed
signal color_changed(color)

var isReady = false


func _ready():
	if color == null:	color = ColorN('white')


	$HuePicker.connect("color_changed", self, "huePickChange")
	$ClassicControls/Hider/Viewport/ColorPicker.connect("color_changed", 
															self, "sliderChange")
	isReady = true


func color_changed(value):
	var sliders = $ClassicControls/Hider/Viewport/ColorPicker
	color = value
	
	if value != null and sliders !=null and $HuePicker != null:
		huePickChange(value)
		sliderChange(value)
	
	emit_signal('color_changed', value)


func huePickChange(color):
	var sliders = $ClassicControls/Hider/Viewport/ColorPicker
	sliders.color = color
	pass

func sliderChange(color):
	$HuePicker.color = color

	#Prevent from accidentally resetting the internal hue if color's out of range
	var c = Color(color.r, color.g, color.b, 1)
	if c != ColorN('black', 1) and c != ColorN('white', 1) and c.s !=0:
		$HuePicker/"Hue Circle"._sethue(color.h, self)


	pass
	
	
