class_name Main extends Node2D


func _input(event: InputEvent) -> void:
    var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
    if mouse_motion_event:
        Events.mouse_moved.emit(self, mouse_motion_event.position, get_global_transform() * mouse_motion_event.position)
