tool
extends ColorPicker

#Used to stop the Hue Circle and SatVal setters from an infinite update loop
var Focused  setget _Focused
func _on_ColorPicker_focus_entered():
	Focused = true 
func _on_ColorPicker_focus_exited():
	Focused = false
func _Focused():
	Print ("WARNING:  Attempting to set read-only var ColorPicker.Focused") 



func _ready():
#	connect("resized",self,"_resized")
	reposition()
func _draw():
#	VisualServer.canvas_item_set_clip(get_canvas_item(),true)
	reposition()
	

#motherfucker don't you even THINK about repositioning yourself to 0 on me
func reposition():
	if rect_position.y >= 0: 
		rect_position.y = -284
		rect_size.x -= 4



func _resized():
	print(rect_position.y)

##  UPDATE THE HUE CIRCLE BASE COLOR ETC.
func _on_ColorPicker_color_changed(color):

	#Prevent from accidentally resetting the internal hue if color's out of range
	var c = Color(color.r, color.g, color.b, 1)
	if c != ColorN('black', 1) and c != ColorN('white', 1) and c.s !=0:
		$'../../../Hue Circle'._sethue(self.color.h, self)
		

#		$'../../..'._on_HuePicker_color_changed(color)
		$'../../..'.emit_signal('color_changed', color)
		
	$'../../..'.color.a = color.a