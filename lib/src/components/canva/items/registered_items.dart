import 'package:flutter_meragi_design/src/components/canva/items/base.dart';
import 'package:flutter_meragi_design/src/components/canva/items/image.dart';
import 'package:flutter_meragi_design/src/components/canva/items/item_registry.dart';
import 'package:flutter_meragi_design/src/components/canva/items/palette.dart';
import 'package:flutter_meragi_design/src/components/canva/items/text.dart';

/// Register built-in kinds. Call once at startup.
void registerBuiltInCanvasItems() {
  CanvasItemRegistry.register(CanvasItemKind.image.name, ImageItem.fromJson);
  CanvasItemRegistry.register(CanvasItemKind.text.name, TextItem.fromJson);
  CanvasItemRegistry.register(
      CanvasItemKind.palette.name, PaletteItem.fromJson);
}
