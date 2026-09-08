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
| `POST` | `/v1/members/{identifier}/personal-plans` | `CreatePlanCommand` | `200` — Guid (new plan ID) |
| `GET` | `/v1/members/{identifier}/personal-plans` | — | `200` — `PersonalPlanDto[]` |
| `GET` | `/v1/members/{identifier}/personal-plans/{planId}` | — | `200` — `PersonalPlanDto` |
| `PUT` | `/v1/members/{identifier}/personal-plans/{planId}` | `UpdatePlanCommand` | `204 No Content` |
| `PATCH` | `/v1/members/{identifier}/personal-plans` | — | `500` (not implemented) |

**Error responses:** `400` validation, `401` unauthenticated, `403` cross-user write attempt, `404` not found.

---

## Flutter integration

The existing plans queries live in `lib/features/plans/presentation/providers/`:

| Provider / repository | Endpoint |
| --- | --- |
| `personalPlansProvider` | `GET /v1/members/me/personal-plans` |
| `activityLogsProvider(planId)` | `GET /v1/plans/{planId}/activity-logs` |
| `sportTypesProvider` | `GET /v1/sport-types` |
| `PlanRepository` | POST/PUT/DELETE personal-plan mutations |

`PlansScreen` watches the live plans provider. Its parser accepts both a legacy
list and a paginated object containing `items`. The mutation repository lives in
`lib/features/plans/data/repositories/plan_repository.dart`. These locations changed;
request behavior and payloads did not.

`PersonalPlan` lives in `lib/features/plans/domain/entities/personal_plan.dart`.
Its existing parser maps `planId`, `planName`, `target`, `currentValue`, dates, and
status. It currently also contains presentation concerns. See
[architecture](architecture.md) for these preserved exceptions.

For new or deliberately migrated calls, keep HTTP and wire decoding in data,
expose a repository contract, and let a provider coordinate screen state. Existing
query providers still call Dio directly; do not copy that coupling as the target
architecture or refactor it during a folder-only task.
