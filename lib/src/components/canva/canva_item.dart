import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/models.dart';
import 'package:flutter_meragi_design/src/components/canva/scaling.dart';

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

class CanvasItemWidget extends StatefulWidget {
  const CanvasItemWidget({
    super.key,
    required this.item,
    required this.canvasSize,
    required this.isSelected,
    required this.onPanMove,
    required this.onResizeCommit,
    required this.onPanStart,
    required this.onPanEnd,
    required this.onResizeStart,
    required this.onResizeEnd,
    required this.scale,
  });

  final CanvasItem item;
  final Size canvasSize;
  final bool isSelected;
  final void Function(Offset delta) onPanMove; // move ALL selected
  final void Function(CanvasItem updated)
      onResizeCommit; // resize / text edit commit
  final VoidCallback onPanStart;
  final VoidCallback onPanEnd;
  final VoidCallback onResizeStart;
  final VoidCallback onResizeEnd;
  final CanvasScaleHandler scale;

  @override
  State<CanvasItemWidget> createState() => _CanvasItemWidgetState();
}

class _CanvasItemWidgetState extends State<CanvasItemWidget> {
  static const double _handleSize = 14;
  static const double _minSize = 40;

  late CanvasItem _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item.copy();
  }

  @override
  void didUpdateWidget(covariant CanvasItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _item = widget.item.copy();
  }

  void _resizeFromCorner(Offset renderDelta, _Corner corner) {
    if (_item.locked) return;

    // Convert to base-space delta first
    final delta = widget.scale.renderDeltaToBase(renderDelta);

    double left = _item.position.dx;
    double top = _item.position.dy;
    double width = _item.size.width;
    double height = _item.size.height;

    switch (corner) {
      case _Corner.topLeft:
        left += delta.dx;
        top += delta.dy;
        width -= delta.dx;
        height -= delta.dy;
        break;
      case _Corner.topRight:
        top += delta.dy;
        width += delta.dx;
        height -= delta.dy;
        break;
      case _Corner.bottomLeft:
        left += delta.dx;
        width -= delta.dx;
        height += delta.dy;
        break;
      case _Corner.bottomRight:
        width += delta.dx;
        height += delta.dy;
        break;
    }

    width = width < _minSize ? _minSize : width;
    height = height < _minSize ? _minSize : height;

    setState(() {
      _item
        ..position = Offset(left, top)
        ..size = Size(width, height);
    });
    widget.onResizeCommit(_item);
  }

  Future<void> _editText() async {
    if (_item.locked || _item.kind != CanvasItemKind.text) return;
    final updated = await showDialog<CanvasItem>(
      context: context,
      builder: (context) => _TextEditorDialog(initial: _item),
    );
    if (updated != null) {
      setState(() => _item = updated);
      widget.onResizeCommit(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final posRender = widget.scale.baseToRender(_item.position);
    final sizeRender = widget.scale.baseToRenderSize(_item.size);

    return Positioned(
      left: posRender.dx,
      top: posRender.dy,
      width: sizeRender.width,
      height: sizeRender.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: (_) => widget.onPanStart(),
        onPanUpdate: (d) {
          if (!widget.isSelected || _item.locked) return;
          // Convert render delta -> base delta
          widget.onPanMove(widget.scale.renderDeltaToBase(d.delta));
        },
        onPanEnd: (_) => widget.onPanEnd(),
        onDoubleTap: _item.kind == CanvasItemKind.text ? _editText : null,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: widget.isSelected
                      ? Border.all(color: Colors.blueAccent, width: 1)
                      : null,
                  color: _item.kind == CanvasItemKind.image
                      ? Colors.white
                      : Colors.transparent,
                ),
                child: _item.kind == CanvasItemKind.image
                    ? Image(image: _item.provider!, fit: BoxFit.contain)
                    : Padding(
                        padding: const EdgeInsets.all(6),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            _item.text ?? '',
                            maxLines: null,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            // Scale font at paint time
                            style: _item.toTextStyle().copyWith(
                                fontSize: widget.scale
                                    .fontBaseToRender(_item.fontSize)),
                          ),
                        ),
                      ),
              ),
            ),
            if (widget.isSelected && !_item.locked) ...[
              _handle(Alignment.topLeft, _Corner.topLeft),
              _handle(Alignment.topRight, _Corner.topRight),
              _handle(Alignment.bottomLeft, _Corner.bottomLeft),
              _handle(Alignment.bottomRight, _Corner.bottomRight),
            ],
            if (_item.locked)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.lock, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _handle(Alignment align, _Corner corner) => Align(
        alignment: align,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (_) => widget.onResizeStart(),
          onPanUpdate: (d) => _resizeFromCorner(d.delta, corner),
          onPanEnd: (_) => widget.onResizeEnd(),
          child: Container(
            width: _handleSize,
            height: _handleSize,
            margin: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent, width: 1),
              boxShadow: const [
                BoxShadow(blurRadius: 2, color: Colors.black26)
              ],
            ),
          ),
        ),
      );
}

/// ------------------ Text Editor Dialog ------------------

class _TextEditorDialog extends StatefulWidget {
  const _TextEditorDialog({required this.initial});

  final CanvasItem initial;

  @override
  State<_TextEditorDialog> createState() => _TextEditorDialogState();
}

class _TextEditorDialogState extends State<_TextEditorDialog> {
  late TextEditingController _ctrl;
  late double _fontSize;
  late Color _fontColor;
  late FontWeight _fontWeight;
  late bool _italic;
  late bool _underline;
  String? _fontFamily;

  static const _swatches = <Color>[
    Colors.black,
    Colors.white,
    Color(0xFF111827), // gray-900
    Color(0xFF374151), // gray-700
    Color(0xFF6B7280), // gray-500
    Color(0xFFEF4444), // red-500
    Color(0xFFF59E0B), // amber-500
    Color(0xFF10B981), // emerald-500
    Color(0xFF3B82F6), // blue-500
    Color(0xFF8B5CF6), // violet-500
  ];

  // Include fonts you actually ship with your app or via google_fonts.
  static const _fontOptions = <String?>[
    null, // System default
    'Inter',
    'Roboto',
    'Montserrat',
    'Merriweather',
    'Poppins',
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initial.text ?? '');
    _fontSize = widget.initial.fontSize;
    _fontColor = widget.initial.fontColor;
    _fontWeight = widget.initial.fontWeight;
    _italic = widget.initial.fontItalic;
    _underline = widget.initial.fontUnderline;
    _fontFamily = widget.initial.fontFamily;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggleBold() {
    setState(() {
      _fontWeight = _fontWeight.index >= FontWeight.w600.index
          ? FontWeight.w400
          : FontWeight.w700;
    });
  }

  void _toggleItalic() {
    setState(() => _italic = !_italic);
  }

  void _toggleUnderline() {
    setState(() => _underline = !_underline);
  }

  @override
  Widget build(BuildContext context) {
    final previewStyle = TextStyle(
      fontSize: _fontSize,
      color: _fontColor,
      fontWeight: _fontWeight,
      fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
      decoration: _underline ? TextDecoration.underline : TextDecoration.none,
      fontFamily: _fontFamily,
      height: 1.2,
    );

    return AlertDialog(
      title: const Text('Edit text'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Content
            TextField(
              controller: _ctrl,
              autofocus: true,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Enter text',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),

            // Font family + size
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Font',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String?>(
                        value: _fontFamily,
                        isDense: true,
                        items: _fontOptions
                            .map((f) => DropdownMenuItem<String?>(
                                  value: f,
                                  child: Text(f ?? 'System'),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _fontFamily = v),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Text('Size'),
                          const SizedBox(width: 8),
                          Text(_fontSize.toStringAsFixed(0)),
                        ],
                      ),
                      Slider(
                        value: _fontSize.clamp(8, 144),
                        min: 8,
                        max: 144,
                        divisions: 136,
                        label: _fontSize.toStringAsFixed(0),
                        onChanged: (v) => setState(() => _fontSize = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Style toggles
            Row(
              children: [
                _StyleToggle(
                  tooltip: 'Bold',
                  selected: _fontWeight.index >= FontWeight.w600.index,
                  icon: Icons.format_bold,
                  onTap: _toggleBold,
                ),
                const SizedBox(width: 8),
                _StyleToggle(
                  tooltip: 'Italic',
                  selected: _italic,
                  icon: Icons.format_italic,
                  onTap: _toggleItalic,
                ),
                const SizedBox(width: 8),
                _StyleToggle(
                  tooltip: 'Underline',
                  selected: _underline,
                  icon: Icons.format_underline,
                  onTap: _toggleUnderline,
                ),
                const Spacer(),
                // Color swatches
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final c in _swatches)
                      _ColorDot(
                        color: c,
                        selected: c.value == _fontColor.value,
                        onTap: () => setState(() => _fontColor = c),
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            // Preview
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 64),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_ctrl.text, style: previewStyle),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final updated = widget.initial.copy()
              ..text = _ctrl.text.trim()
              ..fontSize = _fontSize
              ..fontColor = _fontColor
              ..fontWeight = _fontWeight
              ..fontFamily = _fontFamily
              ..fontItalic = _italic
              ..fontUnderline = _underline;
            Navigator.pop(context, updated);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _StyleToggle extends StatelessWidget {
  const _StyleToggle({
    required this.tooltip,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? Theme.of(context).colorScheme.primary.withOpacity(0.12)
        : Colors.transparent;
    final fg = selected ? Theme.of(context).colorScheme.primary : null;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black12),
          ),
          child: Icon(icon, size: 20, color: fg),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        color.computeLuminance() < 0.5 ? Colors.white : Colors.black26;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color:
                selected ? Theme.of(context).colorScheme.primary : borderColor,
            width: selected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}
