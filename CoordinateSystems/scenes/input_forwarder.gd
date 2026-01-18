class_name InputForwarder extends Control

@export var sub_viewport: SubViewport


func _gui_input(event: InputEvent) -> void:
    var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
    if mouse_motion_event:
        Events.mouse_moved.emit(self, mouse_motion_event.position)
    sub_viewport.push_input(event)
