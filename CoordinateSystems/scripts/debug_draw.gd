class_name DebugDraw

enum LabelAlignment {
    Right,
    Bottom,
}

const font_size := 20


static func draw_label(canvas_item: CanvasItem, pos: Vector2, text: String, alignment: HorizontalAlignment, color: Color, label_alignment: LabelAlignment) -> void:
    if canvas_item.visible:
        var label_size := ThemeDB.fallback_font.get_multiline_string_size(text, alignment, -1, font_size)
        var label_rect := Rect2(pos, label_size)
        match label_alignment:
            LabelAlignment.Right:
                label_rect.position -= Vector2(label_size.x, font_size)
            LabelAlignment.Bottom:
                label_rect.position += Vector2(roundf(-label_size.x / 2.0), font_size)

        var viewport_rect := canvas_item.get_viewport_rect()
        var moved_rect := Rect2(label_rect)

        if label_rect.end.x > viewport_rect.end.x:
            moved_rect.position.x += viewport_rect.end.x - label_rect.end.x
        elif label_rect.position.x < viewport_rect.position.x:
            moved_rect.position.x += viewport_rect.position.x - label_rect.position.x

        if label_rect.end.y > viewport_rect.end.y:
            moved_rect.position.y += viewport_rect.end.y - label_rect.end.y
        elif label_rect.position.y < viewport_rect.position.y:
            moved_rect.position.y += viewport_rect.position.y - label_rect.position.y

        canvas_item.draw_multiline_string(ThemeDB.fallback_font, moved_rect.position + Vector2(0, font_size), text, alignment, moved_rect.size.x + 1, font_size, -1, color)


static func draw_labeled_circle(canvas_item: CanvasItem, pos: Vector2, radius: float, color: Color, width: float, text: String) -> void:
    canvas_item.draw_circle(pos, radius, color, false, width)
    draw_label(canvas_item, pos + Vector2(0, radius), text, HORIZONTAL_ALIGNMENT_RIGHT, color, LabelAlignment.Bottom)
