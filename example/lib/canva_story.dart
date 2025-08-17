import 'package:flutter/material.dart';
import 'package:flutter_meragi_design/flutter_meragi_design.dart';

class CanvaStory extends StatelessWidget {
  const CanvaStory({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SimpleCanvaController();
    final palette = <CanvasPaletteImage>[
      const CanvasPaletteImage(
        id: 'panda',
        srcUri:
            'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=600',
      ),
      const CanvasPaletteImage(
        id: 'flower',
        srcUri:
            'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?q=80&w=600',
      ),
      const CanvasPaletteImage(
        id: 'mountain',
        srcUri:
            'https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=600',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SimpleCanva with Save/Load JSON'),
        actions: [
          IconButton(
            tooltip: 'Viewer',
            icon: const Icon(Icons.visibility_outlined),
            onPressed: () {
              final jsonStr = controller.exportAsJson();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Viewer')),
                    body: CanvaViewer.fromJsonString(
                      jsonStr,
                      workspaceColor: const Color(0xFFF3F4F6),
                      borderRadius: 12,
                      showShadow: true,
                      interactions: CanvasItemInteractions(
                        onTap: (c, it, d, scale) => debugPrint(
                            'tap -> ${it.toJson(1)} at ${d.localPosition}'),
                        onDoubleTap: (context, item, scale) =>
                            debugPrint('double tap -> ${item.id}'),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Export PNG',
            icon: const Icon(Icons.download),
            onPressed: () async {
              final bytes = await controller.exportAsPng();
              if (bytes != null) {
                debugPrint('Exported PNG bytes: ${bytes.length}');
              }
            },
          ),
          IconButton(
            tooltip: 'Save JSON',
            icon: const Icon(Icons.save_alt),
            onPressed: () async {
              final jsonStr = controller.exportAsJson(pretty: true);
              // ignore: use_build_context_synchronously
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: SingleChildScrollView(
                    child: SelectableText(jsonStr),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close'),
                    )
                  ],
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Load JSON',
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              final controllerText = TextEditingController();
              // ignore: use_build_context_synchronously
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Paste JSON'),
                  content: TextField(
                    controller: controllerText,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: '{"version":1,"items":[...]}',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Load'),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                controller.loadFromJson(controllerText.text);
              }
            },
          ),
        ],
      ),
      body: SimpleCanva(
        palette: palette,
        controller: controller,
        onChanged: (items) => debugPrint('Items on canvas: ${items.length}'),
      ),
    );
  }
}
