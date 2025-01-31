part of md_expansiontile;

/// For Every [MDExpansionTile], it should contain its unique [MDExpansionTileController].
/// Passing the same [MDExpansionTileController] to multiple [MDExpansionTile] will throw error
/// Any communication between the ExpansionTile should be done by creating unique [MDExpansionTileController]
/// and communicating with each other through the controller
class MDExpansionTileController extends ChangeNotifier implements ValueListenable<bool> {
  bool _isExpanded;
  bool _firstTime;
  final ExpansionTileController _controller;
  MDExpansionTileController()
      : _controller = ExpansionTileController(),
        _isExpanded = false,
        _firstTime = true;

  /// If you are using this method in lifecycle state or in a listener of some kind (before the expansiontitle has been initiated), make sure to wrap
  /// [WidgetsBinding.instance] with [WidgetsBinding.instance.addPostFrameworkCallback]
  /// /// Reason is that expansiontile has not been initiated when using it in a lifecycle method. Thats why the "state != null" assertion occurs
  void expand({bool notifyListeners = true}) {
    if (!_isExpanded) {
      _isExpanded = true;
      _controller.expand();
      if (notifyListeners) this.notifyListeners();
    }
  }

  /// If you are using this method in lifecycle state or in a listener of some kind (before the expansiontitle has been initiated), make sure to wrap
  /// [WidgetsBinding.instance] with [WidgetsBinding.instance.addPostFrameworkCallback]
  /// Reason is that expansiontile has not been initiated when using it in a lifecycle method. Thats why the "state != null" assertion occurs
  void collapse({bool notifyListeners = true}) {
    if (_isExpanded) {
      _isExpanded = false;
      _controller.collapse();
      if (notifyListeners) this.notifyListeners();
    }
  }

  void _setInitialValue(bool initialValue) {
    if (_firstTime) {
      _isExpanded = initialValue;
      _firstTime = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => notifyListeners());
    }
  }

  @override
  bool get value => _isExpanded;
}
