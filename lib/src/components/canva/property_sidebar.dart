import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/src/components/canva/models.dart';

class PropertiesSidebar extends StatefulWidget {
  const PropertiesSidebar({
    super.key,
    required this.item,
    required this.selectedCount,
    // actions
    required this.onDelete,
    required this.onDuplicate,
    required this.onFront,
    required this.onBack,
    required this.onAlignLeft,
    required this.onAlignHCenter,
    required this.onAlignRight,
    required this.onAlignTop,
    required this.onAlignVCenter,
    required this.onAlignBottom,
    required this.onAlignCanvasHCenter,
    required this.onAlignCanvasVCenter,
    required this.onLockToggle,
    // property change lifecycle
    required this.onChangeStart,
    required this.onChanged,
    required this.onChangeEnd,
  });

  /// Selected item when exactly one is selected, else null.
  final CanvasItem? item;
  final int selectedCount;

  // Actions for selection (apply to 1 or many)
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onFront;
  final VoidCallback onBack;
  final VoidCallback onAlignLeft;
  final VoidCallback onAlignHCenter;
  final VoidCallback onAlignRight;
  final VoidCallback onAlignTop;
  final VoidCallback onAlignVCenter;
  final VoidCallback onAlignBottom;
  final VoidCallback onAlignCanvasHCenter;
  final VoidCallback onAlignCanvasVCenter;
  final VoidCallback onLockToggle;

  // Property change lifecycle
  final VoidCallback onChangeStart;
  final ValueChanged<CanvasItem> onChanged;
  final VoidCallback onChangeEnd;

  @override
  State<PropertiesSidebar> createState() => _PropertiesSidebarState();
}

class _PropertiesSidebarState extends State<PropertiesSidebar> {
  bool _begun = false;

  // Generic geom controllers (single selection only)
  late TextEditingController _xCtrl;
  late TextEditingController _yCtrl;
  late TextEditingController _wCtrl;
  late TextEditingController _hCtrl;
  late TextEditingController _rotCtrl;

  @override
  void initState() {
    super.initState();
    _initFromItem(widget.item);
  }

  @override
  void didUpdateWidget(covariant PropertiesSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.item?.id != widget.item?.id) {
      if (_begun) {
        widget.onChangeEnd();
        _begun = false;
      }
      _disposeCtrls();
      _initFromItem(widget.item);
      return;
    }

    if (widget.item != null) {
      final it = widget.item!;
      _xCtrl.text = it.position.dx.toStringAsFixed(0);
      _yCtrl.text = it.position.dy.toStringAsFixed(0);
      _wCtrl.text = it.size.width.toStringAsFixed(0);
      _hCtrl.text = it.size.height.toStringAsFixed(0);
      _rotCtrl.text = it.rotationDeg.toStringAsFixed(0);
    }
  }

  void _initFromItem(CanvasItem? item) {
    _xCtrl = TextEditingController(
        text: (item?.position.dx ?? 0).toStringAsFixed(0));
    _yCtrl = TextEditingController(
        text: (item?.position.dy ?? 0).toStringAsFixed(0));
    _wCtrl =
        TextEditingController(text: (item?.size.width ?? 0).toStringAsFixed(0));
    _hCtrl = TextEditingController(
        text: (item?.size.height ?? 0).toStringAsFixed(0));
    _rotCtrl = TextEditingController(
        text: (item?.rotationDeg ?? 0).toStringAsFixed(0));
  }

  void _disposeCtrls() {
    _xCtrl.dispose();
    _yCtrl.dispose();
    _wCtrl.dispose();
    _hCtrl.dispose();
    _rotCtrl.dispose();
  }

  @override
  void dispose() {
    if (_begun) widget.onChangeEnd();
    _disposeCtrls();
    super.dispose();
  }

  void _beginIfNeeded() {
    if (_begun) return;
    _begun = true;
    widget.onChangeStart();
  }

  void _emit(CanvasItem base, void Function(CanvasItem) apply) {
    _beginIfNeeded();
    final updated = base.cloneWith();
    apply(updated);
    widget.onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final count = widget.selectedCount;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: switch (count) {
            0 => _EmptyPanel(),
            int c when c > 1 => _ActionsOnly(
                count: c,
                onDelete: widget.onDelete,
                onDuplicate: widget.onDuplicate,
                onFront: widget.onFront,
                onBack: widget.onBack,
                onAlignLeft: widget.onAlignLeft,
                onAlignHCenter: widget.onAlignHCenter,
                onAlignRight: widget.onAlignRight,
                onAlignTop: widget.onAlignTop,
                onAlignVCenter: widget.onAlignVCenter,
                onAlignBottom: widget.onAlignBottom,
                onAlignCanvasHCenter: widget.onAlignCanvasHCenter,
                onAlignCanvasVCenter: widget.onAlignCanvasVCenter,
                onLockToggle: widget.onLockToggle,
              ),
            _ => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ActionsOnly(
                      count: 1,
                      onDelete: widget.onDelete,
                      onDuplicate: widget.onDuplicate,
                      onFront: widget.onFront,
                      onBack: widget.onBack,
                      onAlignLeft: widget.onAlignLeft,
                      onAlignHCenter: widget.onAlignHCenter,
                      onAlignRight: widget.onAlignRight,
                      onAlignTop: widget.onAlignTop,
                      onAlignVCenter: widget.onAlignVCenter,
                      onAlignBottom: widget.onAlignBottom,
                      onAlignCanvasHCenter: widget.onAlignCanvasHCenter,
                      onAlignCanvasVCenter: widget.onAlignCanvasVCenter,
                      onLockToggle: widget.onLockToggle,
                    ),
                    const SizedBox(height: 12),
                    const _SectionTitle('Item'),
                    _GenericItemProps(
                      xCtrl: _xCtrl,
                      yCtrl: _yCtrl,
                      wCtrl: _wCtrl,
                      hCtrl: _hCtrl,
                      rotCtrl: _rotCtrl,
                      onRectCommit: (dx, dy, w, h) {
                        if (item == null) return;
                        _emit(item, (u) {
                          u
                            ..position = Offset(dx, dy)
                            ..size = Size(w < 1 ? 1 : w, h < 1 ? 1 : h);
                        });
                      },
                      onRotateCommit: (deg) {
                        if (item == null) return;
                        _emit(item, (u) => u.rotationDeg = deg);
                      },
                    ),
                    const SizedBox(height: 12),
                    if (item != null)
                      item.buildPropertiesEditor(
                        context,
                        onChangeStart: _beginIfNeeded,
                        onChanged: (u) => widget.onChanged(u),
                        onChangeEnd: () {
                          if (_begun) {
                            widget.onChangeEnd();
                            _begun = false;
                          }
                        },
                      ),
                  ],
                ),
              ),
          },
        ),
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Select items to see actions and properties',
        style: TextStyle(color: Colors.grey.shade600),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Actions section shown for both single and multi selection
class _ActionsOnly extends StatelessWidget {
  const _ActionsOnly({
    required this.count,
    required this.onDelete,
    required this.onDuplicate,
    required this.onFront,
    required this.onBack,
    required this.onAlignLeft,
    required this.onAlignHCenter,
    required this.onAlignRight,
    required this.onAlignTop,
    required this.onAlignVCenter,
    required this.onAlignBottom,
    required this.onAlignCanvasHCenter,
    required this.onAlignCanvasVCenter,
    required this.onLockToggle,
  });

  final int count;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onFront;
  final VoidCallback onBack;
  final VoidCallback onAlignLeft;
  final VoidCallback onAlignHCenter;
  final VoidCallback onAlignRight;
  final VoidCallback onAlignTop;
  final VoidCallback onAlignVCenter;
  final VoidCallback onAlignBottom;
  final VoidCallback onAlignCanvasHCenter;
  final VoidCallback onAlignCanvasVCenter;
  final VoidCallback onLockToggle;

  @override
  Widget build(BuildContext context) {
    final many = count > 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Actions'),
        Row(
          children: [
            _iconBtn(Icons.delete_outline, 'Delete', onDelete),
            _iconBtn(Icons.control_point_duplicate_outlined, 'Duplicate',
                onDuplicate),
            _iconBtn(Icons.lock_open, 'Lock/Unlock', onLockToggle),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _iconBtn(Icons.flip_to_front_outlined, 'Bring front', onFront),
            _iconBtn(Icons.flip_to_back_outlined, 'Send back', onBack),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _iconBtn(Icons.align_horizontal_left, 'Align left',
                many ? onAlignLeft : null),
            _iconBtn(Icons.align_horizontal_center, 'Align center',
                many ? onAlignHCenter : null),
            _iconBtn(Icons.align_horizontal_right, 'Align right',
                many ? onAlignRight : null),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _iconBtn(Icons.align_vertical_top, 'Align top',
                many ? onAlignTop : null),
            _iconBtn(Icons.align_vertical_center, 'Align middle',
                many ? onAlignVCenter : null),
            _iconBtn(Icons.align_vertical_bottom, 'Align bottom',
                many ? onAlignBottom : null),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _iconBtn(
              Icons.center_focus_strong,
              'Center horizontally in canvas',
              onAlignCanvasHCenter,
            ),
            _iconBtn(
              Icons.center_focus_weak,
              'Center vertically in canvas',
              onAlignCanvasVCenter,
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(count == 1 ? '1 selected' : '$count selected',
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _iconBtn(IconData icon, String tip, VoidCallback? onTap) {
    return IconButton(
      tooltip: tip,
      onPressed: onTap,
      icon: Icon(icon),
      color: onTap == null ? Colors.black26 : null,
    );
  }
}

class _GenericItemProps extends StatefulWidget {
  const _GenericItemProps({
    required this.xCtrl,
    required this.yCtrl,
    required this.wCtrl,
    required this.hCtrl,
    required this.rotCtrl,
    required this.onRectCommit,
    required this.onRotateCommit,
  });

  final TextEditingController xCtrl, yCtrl, wCtrl, hCtrl, rotCtrl;
  final void Function(double x, double y, double w, double h) onRectCommit;
  final void Function(double rotationDeg) onRotateCommit;

  @override
  State<_GenericItemProps> createState() => _GenericItemPropsState();
}

class _GenericItemPropsState extends State<_GenericItemProps> {
  void _commitRect() {
    final dx = double.tryParse(widget.xCtrl.text.trim()) ?? 0;
    final dy = double.tryParse(widget.yCtrl.text.trim()) ?? 0;
    final w = double.tryParse(widget.wCtrl.text.trim()) ?? 1;
    final h = double.tryParse(widget.hCtrl.text.trim()) ?? 1;
    widget.onRectCommit(dx, dy, w, h);
  }

  void _commitRot() {
    double r = double.tryParse(widget.rotCtrl.text.trim()) ?? 0;
    r = r % 360;
    if (r < 0) r += 360;
    widget.rotCtrl.text = r.toStringAsFixed(0);
    widget.onRotateCommit(r);
  }

  // NOTE: no Expanded here. Parent Rows wrap each panel in Expanded once.
  Widget _numField(TextEditingController ctrl, {VoidCallback? onDone}) {
    return TextField(
      controller: ctrl,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: const InputDecoration(
        isDense: true,
        border: OutlineInputBorder(),
      ),
      onSubmitted: (_) => onDone?.call(),
      onEditingComplete: onDone,
    );
  }

  Widget _labeled(String label, Widget field) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          field,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        _labeled('X', _numField(widget.xCtrl, onDone: _commitRect)),
        const SizedBox(width: 8),
        _labeled('Y', _numField(widget.yCtrl, onDone: _commitRect)),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        _labeled('W', _numField(widget.wCtrl, onDone: _commitRect)),
        const SizedBox(width: 8),
        _labeled('H', _numField(widget.hCtrl, onDone: _commitRect)),
      ]),
      const SizedBox(height: 8),
      Row(children: [
        _labeled('Rotation°', _numField(widget.rotCtrl, onDone: _commitRot)),
      ]),
      Slider(
        value: double.tryParse(widget.rotCtrl.text) ?? 0,
        min: 0,
        max: 360,
        onChanged: (v) {
          widget.rotCtrl.text = v.toStringAsFixed(0);
          _commitRot();
        },
      ),
    ]);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
