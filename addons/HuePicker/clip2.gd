#Clipper for ClassicControls to fix buggy input handle
tool
extends Control


func _ready():
	$Hider.rect_size = rect_size
	$Hider/Viewport.size = rect_size

#Handles capture
func _gui_input(event):
#	if event is InputEventMouseButton:  
#	#Try to consume the event away from ColorPicker if clicking outside its region
#		var mpos = $'..'.get_local_mouse_position()
#		if not Rect2(Vector2(0,0),$'..'.rect_size).has_point(mpos):
#			print ("oh yes")
#			accept_event()
	pass

#func _on_ColorPicker__NeedManualClick(ev):
#	prints ("Got something!", ev.as_text())
##	_gui_input(ev)
#	$"..".emit_signal('gui_input', ev)
##	Input.
#	pass # replace with function body




func _on_ClassicControls_resized():
#	$Viewport.size = rect_size - Vector2(1,1)
	pass