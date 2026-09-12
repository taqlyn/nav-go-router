import 'pending_deep_link.dart';

/// Location + query from a Taqlyn [DeferredLink]-shaped object.
///
/// Accepts any object with `path` + optional `params` so this package does not
/// depend on `taqlyn_sdk`.
String mapDeferredLinkToLocation(Object link) {
  final path = _readPath(link);
  final params = _readParams(link);
  final normalized = path.startsWith('/') ? path : '/$path';
  if (params.isEmpty) return normalized;
  final qs = Uri(queryParameters: params).query;
  return qs.isEmpty ? normalized : '$normalized?$qs';
}

/// Navigate once per link id via injected `go` / `goNamed`.
bool navigateDeferredLink(
  Object link, {
  required void Function(String location) go,
  required String Function(Object link) idOf,
  Set<String>? consumed,
}) {
  final ids = consumed ?? <String>{};
  final id = idOf(link);
  if (ids.contains(id)) return false;
  go(mapDeferredLinkToLocation(link));
  ids.add(id);
  return true;
}

/// go_router `redirect` helper: hold deep locations until [PendingDeepLink] is ready.
String? taqlynRedirect({
  required PendingDeepLink pending,
  required String matchedLocation,
  String home = '/',
  String splash = '/',
}) {
  if (pending.shouldHoldRedirect(
    matchedLocation: matchedLocation,
    home: home,
  )) {
    return splash;
  }
  return null;
}

String _readPath(Object link) {
  try {
    final value = (link as dynamic).path;
    if (value is String && value.isNotEmpty) return value;
  } catch (_) {}
  return '/';
}

Map<String, String> _readParams(Object link) {
  try {
    final value = (link as dynamic).params;
    if (value is Map) {
      return value.map((key, v) => MapEntry(key.toString(), v.toString()));
    }
  } catch (_) {}
  return const {};
}
