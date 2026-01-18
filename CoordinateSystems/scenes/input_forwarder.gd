class_name InputForwarder extends GUIMouseListener

@export var sub_viewport: SubViewport


func _gui_input(event: InputEvent) -> void:
    super._gui_input(event) # call GUIMouseListener
    sub_viewport.push_input(event)
