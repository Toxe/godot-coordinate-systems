class_name DebugDraw

enum LabelAlignment {
    Right,
    Bottom,
}

const font_size := 20


static func draw_label(canvas_item: CanvasItem, pos: Vector2, text: String, alignment: HorizontalAlignment, color: Color, label_alignment: LabelAlignment) -> void:
    if canvas_item.visible:
        var string_size := ThemeDB.fallback_font.get_multiline_string_size(text, alignment, -1, font_size)
        var alignment_offset := Vector2.ZERO
        match label_alignment:
            LabelAlignment.Right:
                alignment_offset -= Vector2(string_size.x, 0)
            LabelAlignment.Bottom:
                alignment_offset += Vector2(roundf(-string_size.x / 2.0), font_size)
        canvas_item.draw_multiline_string(ThemeDB.fallback_font, pos + alignment_offset, text, alignment, string_size.x + 1, font_size, -1, color)


static func draw_labeled_circle(canvas_item: CanvasItem, pos: Vector2, radius: float, color: Color, width: float, text: String) -> void:
    canvas_item.draw_circle(pos, radius, color, false, width)
    draw_label(canvas_item, pos + Vector2(0, radius + 15), text, HORIZONTAL_ALIGNMENT_RIGHT, color, LabelAlignment.Bottom)
