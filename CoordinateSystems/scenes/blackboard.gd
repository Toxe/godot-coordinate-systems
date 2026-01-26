class_name Blackboard extends GUIMouseListener

var dots: PackedVector2Array

@onready var coords_label: Label = $CoordsLabel
@onready var info_label: Label = $InfoLabel


func _ready() -> void:
    info_label.text = "%s\nsize: %s\nscale: %s" % [name, Format.format_size(size), Format.format_size(scale)]
    info_label.tooltip_text = info_label.text
    coords_label.visible = false


func _on_mouse_exited() -> void:
    coords_label.visible = false


func _gui_input(event: InputEvent) -> void:
    super._gui_input(event) # call GUIMouseListener

    var mouse_event: InputEventMouse = event as InputEventMouse
    if mouse_event:
        coords_label.text = Format.format_position(mouse_event.position)
        coords_label.visible = true

        if mouse_event.button_mask == 1:
            dots.append(mouse_event.position)
            queue_redraw()


func _draw() -> void:
    for dot in dots:
        draw_circle(dot, 5, Color.WHEAT, true)


func _on_button_pressed() -> void:
    ($Button/GPUParticles2D as GPUParticles2D).emit_particle(Transform2D.IDENTITY, Vector2.ZERO, Color.BLACK, Color.BLACK, 0)
