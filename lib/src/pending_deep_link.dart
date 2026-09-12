import 'package:flutter/foundation.dart';

/// Holds one pending deep-link payload until auth / onboarding finishes.
///
/// Use with `GoRouter.redirect` + `refreshListenable` in the host app:
/// allow deep destinations only when [isReady].
class PendingDeepLink extends ChangeNotifier {
  Object? _link;
  bool _ready = false;

  /// Last pending link object (typically a `DeferredLink` from taqlyn_sdk).
  Object? get link => _link;

  /// Host sets true when go_router may navigate to deferred destinations.
  bool get isReady => _ready;

  void set(Object link) {
    _link = link;
    notifyListeners();
  }

  void clear({String? linkId, String Function(Object link)? idOf}) {
    if (linkId != null && _link != null && idOf != null) {
      if (idOf(_link!) != linkId) return;
    }
    _link = null;
    notifyListeners();
  }

  void setReady(bool ready) {
    if (_ready == ready) return;
    _ready = ready;
    notifyListeners();
  }

  /// Soft redirect hint: block deep destinations until [isReady].
  ///
  /// Returns `true` when the router should delay navigating to [matchedLocation].
  bool shouldHoldRedirect({
    required String matchedLocation,
    String home = '/',
  }) {
    if (isReady) return false;
    if (matchedLocation == home || matchedLocation.isEmpty) return false;
    return _link != null;
  }
}
