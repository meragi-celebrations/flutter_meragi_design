import 'dart:math';

import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 1. Abstract Base Class for Moodboard Tiles
/// ---------------------------------------------------------------------------

/// An abstract base class for moodboard tiles. Instead of using a “mainAxis
/// cell count,” the tile now carries an initial pixel height and notifies the
/// parent when its desired height (in pixels) has been computed.
abstract class MDMoodboardTile extends StatefulWidget {
  /// How many columns (cells) this tile occupies horizontally.
  final int tileCrossAxisSpan;

  /// The initial height (in pixels) assumed for the tile.
  final double initialTileHeight;

  /// Callback when the tile has computed its desired height (in pixels).
  final ValueChanged<double> onTileHeightComputed;

  const MDMoodboardTile({
    Key? key,
    required this.tileCrossAxisSpan,
    this.initialTileHeight = 100.0,
    required this.onTileHeightComputed,
  }) : super(key: key);
}

/// ---------------------------------------------------------------------------
/// 2. Generic Moodboard Widget
/// ---------------------------------------------------------------------------

/// A generic staggered grid (moodboard) that builds its layout based on a list
/// of tiles. Instead of hard–coded image URLs, the caller supplies a tile builder
/// function. The builder returns an [MDMoodboardTile] for each index.
class MDMoodboard extends StatefulWidget {
  /// Number of tiles.
  final int tileCount;

  /// The tile builder function.
  ///
  /// The builder is given the [BuildContext], tile index, grid parameters, and a
  /// callback [onTileHeightComputed] that the tile should call when its desired
  /// height (in pixels) is known.
  final MDMoodboardTile Function(
    BuildContext context,
    int index,
    int crossAxisCount,
    double crossAxisSpacing,
    double mainAxisSpacing,
    double cellWidth,
    ValueChanged<double> onTileHeightComputed,
  ) tileBuilder;

  /// Total number of columns in the grid.
  final int crossAxisCount;

  /// Horizontal spacing between columns.
  final double crossAxisSpacing;

  /// Vertical spacing between tiles.
  final double mainAxisSpacing;

  const MDMoodboard({
    Key? key,
    required this.tileCount,
    required this.tileBuilder,
    this.crossAxisCount = 4,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
  }) : super(key: key);

  @override
  _MDMoodboardState createState() => _MDMoodboardState();
}

class _MDMoodboardState extends State<MDMoodboard> {
  /// For each tile, store its current computed height (in pixels).
  late List<double> _tileHeights;

  @override
  void initState() {
    super.initState();
    // Initially, assume each tile is 100 pixels tall.
    _tileHeights = List<double>.filled(widget.tileCount, 100.0);
  }

  /// Callback from a tile when its computed height changes.
  void _updateTileHeight(int index, double newHeight) {
    if (_tileHeights[index] != newHeight) {
      setState(() {
        _tileHeights[index] = newHeight;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Total available width.
      final double availableWidth = constraints.maxWidth;

      final double cellWidth = (availableWidth -
              (widget.crossAxisCount - 1) * widget.crossAxisSpacing) /
          widget.crossAxisCount;

      // Build a list of tiles by calling the tile builder for each index.
      final List<MDMoodboardTile> tiles = List.generate(
        widget.tileCount,
        (index) => widget.tileBuilder(
          context,
          index,
          widget.crossAxisCount,
          widget.crossAxisSpacing,
          widget.mainAxisSpacing,
          cellWidth,
          (computedHeight) => _updateTileHeight(index, computedHeight),
        ),
      );

      // Build a list of [StaggeredTile] objects for the grid delegate.
      final List<MDStaggeredTile> staggeredTiles =
          List.generate(widget.tileCount, (index) {
        return MDStaggeredTile(
          crossAxisCellCount: tiles[index].tileCrossAxisSpan,
          tileHeight: _tileHeights[index],
        );
      });

      return CustomMultiChildLayout(
        delegate: _MDStaggeredGridDelegate(
          tiles: staggeredTiles,
          crossAxisCount: widget.crossAxisCount,
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing,
          availableWidth: availableWidth,
          cellWidth: cellWidth,
        ),
        children: List.generate(widget.tileCount, (index) {
          return LayoutId(
            id: index,
            child: tiles[index],
          );
        }),
      );
    });
  }
}

/// A helper data class that tells the grid how many columns a tile spans and
/// what its height (in pixels) should be.
class MDStaggeredTile {
  /// Number of columns the tile occupies.
  final int crossAxisCellCount;

  /// The tile’s height in pixels.
  final double tileHeight;

  MDStaggeredTile({
    required this.crossAxisCellCount,
    required this.tileHeight,
  });

  @override
  String toString() =>
      'StaggeredTile($crossAxisCellCount, height: $tileHeight)';
}

///
/// A custom layout delegate that “packs” tiles into a grid using a waterfall
/// (column–based) algorithm. Each tile has a fixed width (based on the number of
/// columns it spans) and a computed pixel height.
///
class _MDStaggeredGridDelegate extends MultiChildLayoutDelegate {
  final List<MDStaggeredTile> tiles;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double availableWidth;
  final double cellWidth;

  _MDStaggeredGridDelegate({
    required this.tiles,
    required this.crossAxisCount,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    required this.availableWidth,
    required this.cellWidth,
  });

  @override
  void performLayout(Size size) {
    // Maintain an array for the current vertical offset (y position) for each column.
    List<double> columnHeights = List.filled(crossAxisCount, 0.0);
    final List<_TilePlacement> placements = [];

    // Place each tile in the column (or contiguous columns) that has the smallest
    // maximum height.
    for (int i = 0; i < tiles.length; i++) {
      final tile = tiles[i];
      int span = tile.crossAxisCellCount.clamp(1, crossAxisCount);
      final double tileHeight = tile.tileHeight;

      double minMaxHeight = double.infinity;
      int chosenCol = 0;
      // Try every contiguous block of columns of length [span].
      for (int col = 0; col <= crossAxisCount - span; col++) {
        double currentMax = 0.0;
        for (int j = col; j < col + span; j++) {
          currentMax = max(currentMax, columnHeights[j]);
        }
        if (currentMax < minMaxHeight) {
          minMaxHeight = currentMax;
          chosenCol = col;
        }
      }

      final double tileTop = minMaxHeight;
      final double tileLeft = chosenCol * (cellWidth + crossAxisSpacing);
      final double tileWidth = span * cellWidth + (span - 1) * crossAxisSpacing;
      placements.add(_TilePlacement(
          top: tileTop, left: tileLeft, width: tileWidth, height: tileHeight));

      // Update the columns that this tile spans.
      final double newHeight = tileTop + tileHeight + mainAxisSpacing;
      for (int j = chosenCol; j < chosenCol + span; j++) {
        columnHeights[j] = newHeight;
      }
    }

    // Layout and position each child based on the computed placements.
    for (int i = 0; i < placements.length; i++) {
      if (hasChild(i)) {
        final placement = placements[i];
        layoutChild(
            i, BoxConstraints.tight(Size(placement.width, placement.height)));
        positionChild(i, Offset(placement.left, placement.top));
      }
    }
  }

  @override
  Size getSize(BoxConstraints constraints) {
    // Re-run the placement algorithm to determine the overall grid height.

    List<double> columnHeights = List.filled(crossAxisCount, 0.0);
    for (int i = 0; i < tiles.length; i++) {
      final tile = tiles[i];
      int span = tile.crossAxisCellCount.clamp(1, crossAxisCount);
      final double tileHeight = tile.tileHeight;

      double minMaxHeight = double.infinity;
      int chosenCol = 0;
      for (int col = 0; col <= crossAxisCount - span; col++) {
        double currentMax = 0.0;
        for (int j = col; j < col + span; j++) {
          currentMax = max(currentMax, columnHeights[j]);
        }
        if (currentMax < minMaxHeight) {
          minMaxHeight = currentMax;
          chosenCol = col;
        }
      }
      final double newHeight = minMaxHeight + tileHeight + mainAxisSpacing;
      for (int j = chosenCol; j < chosenCol + span; j++) {
        columnHeights[j] = newHeight;
      }
    }
    double gridHeight = columnHeights.reduce(max);
    if (gridHeight > 0) gridHeight -= mainAxisSpacing; // Remove extra spacing.
    return Size(availableWidth, gridHeight);
  }

  @override
  bool shouldRelayout(covariant _MDStaggeredGridDelegate oldDelegate) {
    return oldDelegate.tiles != tiles ||
        oldDelegate.crossAxisCount != crossAxisCount ||
        oldDelegate.crossAxisSpacing != crossAxisSpacing ||
        oldDelegate.mainAxisSpacing != mainAxisSpacing ||
        oldDelegate.availableWidth != availableWidth;
  }
}

/// A helper class to record a tile’s placement.
class _TilePlacement {
  final double top;
  final double left;
  final double width;
  final double height;

  _TilePlacement({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });
}

/// ---------------------------------------------------------------------------
/// 3. A Concrete Tile: AsyncImageTile
/// ---------------------------------------------------------------------------

/// A concrete tile that displays an image from the network. It waits for the image
/// to load so that it can compute its intrinsic aspect ratio and then, using the grid’s
/// cell parameters, computes its desired pixel height. When computed, it notifies the
/// parent via [onTileHeightComputed]. Optionally, the image can be wrapped with a custom
/// builder.
class MDAsyncImageTile extends MDMoodboardTile {
  final String imageUrl;

  /// The width (in pixels) of one grid cell. (Computed by the parent.)
  final double cellWidth;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Widget Function(BuildContext context, String url) builder;

  const MDAsyncImageTile({
    Key? key,
    required this.imageUrl,
    required int tileCrossAxisSpan,
    double initialTileHeight = 100.0,
    required ValueChanged<double> onTileHeightComputed,
    required this.cellWidth,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    required this.builder,
  }) : super(
          key: key,
          tileCrossAxisSpan: tileCrossAxisSpan,
          initialTileHeight: initialTileHeight,
          onTileHeightComputed: onTileHeightComputed,
        );

  @override
  MDAsyncImageTileState createState() => MDAsyncImageTileState();
}

class MDAsyncImageTileState extends State<MDAsyncImageTile> {
  ImageStream? _imageStream;
  ImageStreamListener? _imageStreamListener;
  bool _didComputeHeight = false;

  @override
  void initState() {
    super.initState();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant MDAsyncImageTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _resolveImage();
    }
  }

  void _resolveImage() {
    String formatterUrl = "${widget.imageUrl}?format=webp";
    final ImageProvider provider = NetworkImage(formatterUrl);
    _imageStream = provider.resolve(const ImageConfiguration());
    _imageStreamListener =
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (!_didComputeHeight) {
        _didComputeHeight = true;
        final int naturalWidth = info.image.width;
        final int naturalHeight = info.image.height;
        final double aspectRatio = naturalWidth / naturalHeight;

        // Compute the tile’s width in pixels.
        final double tileWidth = (widget.tileCrossAxisSpan * widget.cellWidth);

        // Desired height to preserve the aspect ratio.
        final double desiredHeight = tileWidth / aspectRatio;
        final double computedHeight = max(50.0, desiredHeight);

        // Notify the parent.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onTileHeightComputed(computedHeight);
        });
      }
    });
    _imageStream?.addListener(_imageStreamListener!);
  }

  @override
  void dispose() {
    if (_imageStreamListener != null) {
      _imageStream?.removeListener(_imageStreamListener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.imageUrl);
  }
}
