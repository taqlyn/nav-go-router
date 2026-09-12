import 'package:flutter_test/flutter_test.dart';
import 'package:taqlyn_nav_go_router/taqlyn_nav_go_router.dart';

class _FakeLink {
  _FakeLink({
    required this.path,
    required this.linkId,
    this.params = const {},
  });

  final String path;
  final String linkId;
  final Map<String, String> params;
}

void main() {
  test('mapDeferredLinkToLocation adds slash + query', () {
    expect(
      mapDeferredLinkToLocation(
        _FakeLink(path: 'home', linkId: '1', params: {'sku': '9'}),
      ),
      '/home?sku=9',
    );
  });

  test('navigateDeferredLink dedupes by id', () {
    final locations = <String>[];
    final consumed = <String>{};
    final link = _FakeLink(path: '/malls', linkId: 'lnk_a');
    expect(
      navigateDeferredLink(
        link,
        go: locations.add,
        idOf: (o) => (o as _FakeLink).linkId,
        consumed: consumed,
      ),
      isTrue,
    );
    expect(
      navigateDeferredLink(
        link,
        go: locations.add,
        idOf: (o) => (o as _FakeLink).linkId,
        consumed: consumed,
      ),
      isFalse,
    );
    expect(locations, ['/malls']);
  });

  test('taqlynRedirect holds deep location until ready', () {
    final pending = PendingDeepLink();
    pending.set(_FakeLink(path: '/home', linkId: 'x'));
    expect(
      taqlynRedirect(
        pending: pending,
        matchedLocation: '/home',
        splash: '/splash',
      ),
      '/splash',
    );
    pending.setReady(true);
    expect(
      taqlynRedirect(
        pending: pending,
        matchedLocation: '/home',
        splash: '/splash',
      ),
      isNull,
    );
  });
}
