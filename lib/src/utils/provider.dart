import 'package:flutter/cupertino.dart';

extension MDProviderReadExt on BuildContext {
  T read<T>() => MDProvider.of<T>(this, listen: false);
  T? maybeRead<T>() => MDProvider.maybeOf<T>(this, listen: false);
}

extension MDProviderWatchExt on BuildContext {
  T watch<T>() => MDProvider.of<T>(this);
  T? maybeWatch<T>() => MDProvider.maybeOf<T>(this);
}

class MDProvider<T> extends InheritedWidget {
  const MDProvider({
    super.key,
    required super.child,
    required this.data,
    this.notifyUpdate,
  });

  /// The data to be provided
  final T data;

  /// Whether to notify the update of the provider, defaults to false
  final bool Function(MDProvider<T> oldWidget)? notifyUpdate;

  static T of<T>(BuildContext context, {bool listen = true}) {
    final inherited = maybeOf<T>(context, listen: listen);
    if (inherited == null) {
      throw FlutterError(
        'Could not find $T InheritedWidget in the ancestor widget tree.',
      );
    }
    return inherited;
  }

  static T? maybeOf<T>(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<MDProvider<T>>()?.data;
    }
    final provider = context
        .getElementForInheritedWidgetOfExactType<MDProvider<T>>()
        ?.widget;
    return (provider as MDProvider<T>?)?.data;
  }

  @override
  bool updateShouldNotify(covariant MDProvider<T> oldWidget) {
    return notifyUpdate?.call(oldWidget) ?? false;
  }
}
