# nav-go-router

Soft **go_router** helpers for Taqlyn Flutter apps.

- `PendingDeepLink` — hold until the host marks navigation ready
- `mapDeferredLinkToLocation(link)` — path + query
- `navigateDeferredLink(link, go: …)` — navigate once per id
- `taqlynRedirect(pending:, matchedLocation:)` — `GoRouter.redirect` helper

No Match / Install Referrer / pasteboard logic (lives in native SdkCore).
Version independently from `taqlyn_sdk`.

```dart
final pending = PendingDeepLink();

GoRouter(
  refreshListenable: pending,
  redirect: (context, state) => taqlynRedirect(
    pending: pending,
    matchedLocation: state.matchedLocation,
    splash: '/splash',
  ),
);
```

Pair with `taqlyn_sdk`:

1. `TaqlynSdk.configure` → `resolveDeferred` (iOS clipboard / Android referrer)
2. `TaqlynSdk.setReadyForNavigation(true)` + `pending.setReady(true)`
3. `observePlatformLinks` → `navigateDeferredLink` → `consume`
