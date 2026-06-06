# Backend API Reference

Base URL: `AppConfig.apiBase` (see `lib/core/config/app_config.dart`)
- dev: `http://localhost:5008`
- prod: `https://api.planthor.space`

All routes are prefixed with `/v1`. All endpoints require a valid Keycloak Bearer token:

```
Authorization: Bearer <access_token>
```

The token is injected automatically by `apiClientProvider` (`lib/core/network/api_client.dart`).

---

## Members

| Method | URL | Request Body | Success Response |
|--------|-----|-------------|-----------------|
| `POST` | `/v1/Members` | `CreateMemberCommand` | `200` — Guid (new member ID) |
| `GET` | `/v1/Members` | — | `200` — `MemberDto[]` |
| `GET` | `/v1/Members/{id}` | — | `200` — `MemberDto` |
| `PUT` | `/v1/Members/{id}` | `UpdateMemberCommand` | `204 No Content` |

**Error responses:** `400` validation failure, `401` unauthenticated, `404` not found.

---

## Personal Plans

`{identifier}` is either `"me"` (current authenticated user) or a member's identity name.

| Method | URL | Request Body | Success Response |
|--------|-----|-------------|-----------------|
| `POST` | `/v1/members/{identifier}/PersonalPlans` | `CreatePlanCommand` | `200` — Guid (new plan ID) |
| `GET` | `/v1/members/{identifier}/PersonalPlans` | — | `200` — `PersonalPlanDto[]` |
| `GET` | `/v1/members/{identifier}/PersonalPlans/{planId}` | — | `200` — `PersonalPlanDto` |
| `PUT` | `/v1/members/{identifier}/PersonalPlans/{planId}` | `UpdatePlanCommand` | `204 No Content` |
| `PATCH` | `/v1/members/{identifier}/PersonalPlans` | — | `500` (not implemented) |

**Error responses:** `400` validation, `401` unauthenticated, `403` cross-user write attempt, `404` not found.

---

## Flutter Integration

### Current wired calls

| Provider | Endpoint | File |
|----------|----------|------|
| `personalPlansProvider` | `GET /v1/members/me/PersonalPlans` | `lib/features/my_garden/bloc/personal_plans_provider.dart` |

### Adding a new call

1. Add a `FutureProvider` in the relevant feature's `bloc/` folder:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planthor_ios_application/core/network/api_client.dart';
import 'package:planthor_ios_application/features/<name>/domain/entities/<model>.dart';

final myProvider = FutureProvider<List<MyModel>>((ref) async {
  final dio = ref.watch(apiClientProvider);
  final response = await dio.get('/v1/path');
  return (response.data as List)
      .map((e) => MyModel.fromJson(e as Map<String, dynamic>))
      .toList();
});
```

2. The Bearer token is injected automatically — no extra setup needed.

3. In the screen widget:

```dart
final dataAsync = ref.watch(myProvider);
dataAsync.when(
  loading: () => const CircularProgressIndicator(),
  error: (e, _) => Text(e.toString()),
  data: (items) => ListView(...),
);
```

4. To retry after error: `ref.invalidate(myProvider)`.

### Data models

| Model | File | Maps to |
|-------|------|---------|
| `PersonalPlan` | `lib/features/my_garden/domain/entities/personal_plan.dart` | `PersonalPlanDto` — fields: `id` (String), `name` (String) |

New models go in `lib/features/<name>/domain/entities/`. Add a `fromJson` factory. No code generation needed for plain data classes.
