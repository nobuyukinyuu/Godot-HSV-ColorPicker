tool
extends Control
const SQ22 = 0.70710678118654752440084436210485  #Sqrt(2)/2

enum DragType {NONE, HUE, XY}
var Dragging


#We need to save the hue in case value is zeroed out and resets it
var saved_h = 0 setget _sethue, _gethue

func _sethue(value, sender=null):
	if sender == null:
		print ("Warning:  Attempt to set private variable _hue!")
	if sender == $'../ClassicControls/Hider/ColorPicker' or sender == $'..' or sender.has_node(self.get_path()):
		saved_h = value
	else: 
		print ("Hue Circle: Warning, attempt to set private variable _hue!")
		print ("Class %s, %s" % [sender.get_class(), sender])
	pass
func _gethue():
	return saved_h



func _ready():
	update()
	pass
	
func _draw():

	var rgb  #Color()
	var short_edge = min(rect_size.x, rect_size.y)
	var outR = short_edge * 0.5  #Outer Radius
	var inR = short_edge * 0.375
	var midR = short_edge * 0.4375

	#square width, pos
	var sqw = inR * 2 * SQ22
	var sqpos = int(inR * SQ22)

	var x = rect_size.x/2 #+ SQ22
	var y = rect_size.y/2 #+ SQ22

	
	#Draw the wheel.		
	draw_circle(Vector2(x,y),outR+1.5, Color(0,0,0,0.3))

	for theta in range(720):	
		var i = deg2rad(theta/2.0)

		rgb = HSVtoRGB(theta / 720.0, 1.0, 0.5)
		
		draw_line(Vector2(x + cos(i) * inR, y + sin(i) * inR),
				  Vector2(x + cos(i + PI/12.0) * outR, y + sin(i + PI/12.0) * outR),
				  rgb,rect_size.x/64,true)
	
	
	#Reposition stuff
	$ColorRect.rect_size = Vector2(sqw, sqw)
	$ColorRect.rect_position = Vector2(rect_size.x/2 - sqw/2+1,  rect_size.y/2 - sqw/2+1)  

	
	$indicator_h.rect_pivot_offset = Vector2($indicator_h.rect_size.x / 2,
											 $indicator_h.rect_size.y / 2)
	$indicator_h.rect_size.y = outR - inR * 0.99
	$indicator_h.rect_size.x = short_edge / 25
	
func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		update()
	
	
	
	
func HSVtoRGB (hue, saturation, luminance):
	var r = float(luminance)
	var g = float(luminance)
	var b = float(luminance)
	
	var v = 0.0

	if luminance <= 0.5:
		v = luminance * (1.0 + saturation)
	else:
		v = luminance + saturation - luminance * saturation

	if v > 0:
		var m = luminance + luminance - v
		var sv = (v - m) / v
		hue *= 6
		var sextant = int(hue)
		var fract = float(hue) - float(sextant)
		var vsf = v * sv * fract
		var mid1 = m + vsf
		var mid2 = v - vsf
		
		match sextant:
			0:
				r = v
				g = mid1
				b = m
			1:
				r = mid2
				g = v
				b = m
			2:
				r = m
				g = v
				b = mid1
			3:
				r = m
				g = mid2
				b = v
			4:
				r = mid1
				g = m
				b = v
			5:
				r = v
				g = m
				b = mid2
	return Color(r,g,b)


############## SIGNALS ###############################

func _on_Hue_Circle_gui_input(ev):
	var mpos = get_local_mouse_position()

	if ev is InputEventMouseButton:
		if ev.pressed == true and ev.button_index == BUTTON_LEFT:  #MouseDown
			if $ColorRect.get_rect().has_point(mpos):
				Dragging = DragType.XY
#				saved_h = $'..'.color.h
			else:
				Dragging = DragType.HUE

	#Drag
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and Dragging == DragType.HUE:
		var angle = (rad2deg(mpos.angle_to_point(rect_size/2)+2*PI) ) / 360

		#A workaround for a bug in Godot 3.0.2 where setting HSV properties resets alpha.
		var alpha = $'..'.color.a

		$'..'.color.h = angle
		saved_h = angle

		$'..'.color.a = alpha  #Put alpha component back
		
	elif Input.is_mouse_button_pressed(BUTTON_LEFT) and Dragging == DragType.XY:
		var pos = $'ColorRect/SatVal'.get_local_mouse_position()
		var s = pos.x /  $'ColorRect/SatVal'.rect_size.x
		var v = pos.y /  $'ColorRect/SatVal'.rect_size.y

		#A workaround for a bug in Godot 3.0.2 where setting HSV properties resets alpha.
		var alpha = $'..'.color.a
			
		$'..'.color.h = saved_h  #fixy?
		$'..'.color.s = clamp(s, 0.0, 1.0)
		$'..'.color.v = clamp(1-v, 0.0, 1.0)

		$'..'.color.a = alpha  #Put alpha component back
	
	if ev is InputEventMouseButton:		
		if ev.button_index == BUTTON_LEFT and ev.pressed == false:  #MouseUp
			Dragging = DragType.NONE
			
			