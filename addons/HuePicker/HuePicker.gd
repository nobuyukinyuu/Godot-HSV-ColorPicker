tool
extends Control

export(Color) var color setget color_changed
signal color_changed(color)


export(bool) var ShowClassicControls=true setget toggle_classic_controls 

var isReady = false

func color_changed(value):
#	if isReady == false:  
#		print ("I'm not ready! %s" % color)
#		return 
	color = value
	
	#TODO: This line is so we know to update the hue spinner if a property
	#is set from within the Godot editor. Will cause problems for downstream
	#Plugins, so try to figure out a way to determine that we're SPECIFICALLY
	#editing this property from the Inspector, somehow.  Hack!!!
	if Engine.editor_hint == true and $"Hue Circle" != null: 
		$"Hue Circle"._sethue(value.h, self)
	
	emit_signal('color_changed', value)
	

func _ready():	
#	print ("Setting up HuePicker.. %s" % color)
	if color == null: color = ColorN('white')
	isReady = true
	
	reposition_hue_picker()
	_on_HuePicker_color_changed(color)


func _on_HuePicker_resized():
	reposition_hue_picker()

func toggle_classic_controls(value):
	if isReady == false:  return 
	ShowClassicControls = value
	match value:
		true:
			$ClassicControls.visible = true
			reposition_hue_picker()			
		false:
			$ClassicControls.visible = false
			reposition_hue_picker()			
	
			
func reposition_hue_picker():
	if ShowClassicControls:
		$"Hue Circle".rect_size.y = rect_size.y - $ClassicControls/Hider.rect_size.y - 4
		$"Hue Circle".rect_size.x = rect_size.x 
		$"Hue Circle".update()
	else:
		$"Hue Circle".rect_size = rect_size

		
	reposition_hue_indicator()
	
func reposition_hue_indicator():
	var hc   = $"Hue Circle"
	var i    = $"Hue Circle/indicator_h"
	var midR = min(hc.rect_size.x, hc.rect_size.y) * 0.4375
	var ihx  = midR*cos(hc.saved_h * 2*PI) + hc.rect_size.x/2 - i.rect_size.x/2
	var ihy  = midR*sin(hc.saved_h * 2*PI) + hc.rect_size.y/2 - i.rect_size.y/2
	i.rect_position = Vector2(ihx,ihy)
	

#Color change handler.
func _on_HuePicker_color_changed(color):
	if isReady == false or color == null:  
		print("HuePicker:  Warning, attempting to change color before control is ready")
		return 
	$"Hue Circle/indicator_h".set_rotation($"Hue Circle".saved_h * 2*PI + PI/2)
	$"Hue Circle/ColorRect/SatVal".material.set_shader_param("hue", $"Hue Circle".saved_h)
	reposition_hue_indicator()
	
	$"Hue Circle/ColorRect/indicator_sv".position = Vector2(color.s, 1-color.v) * $"Hue Circle/ColorRect".rect_size
	
	#update the classic controls.
	$ClassicControls/Hider/ColorPicker.color = color
	$'ClassicControls/Hider/R_Prev'.material.set_shader_param("color1", Color(0,color.g,color.b,1))
	$'ClassicControls/Hider/R_Prev'.material.set_shader_param("color2", Color(1,color.g,color.b,1))
	$'ClassicControls/Hider/G_Prev'.material.set_shader_param("color1", Color(color.r,0,color.b,1))
	$'ClassicControls/Hider/G_Prev'.material.set_shader_param("color2", Color(color.r,1,color.b,1))
	$'ClassicControls/Hider/B_Prev'.material.set_shader_param("color1", Color(color.r,color.g,0,1))
	$'ClassicControls/Hider/B_Prev'.material.set_shader_param("color2", Color(color.r,color.g,1,1))
	$'ClassicControls/Hider/A_Prev'.material.set_shader_param("color1", Color(color.r,color.g,color.b,0))
	$'ClassicControls/Hider/A_Prev'.material.set_shader_param("color2", Color(color.r,color.g,color.b,1))
	