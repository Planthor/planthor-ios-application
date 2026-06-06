# Planthor Backend API Documentation

This document describes the RESTful API endpoints provided by the `planthor-backend` service.

## Base URL
All API requests are relative to the server's base URL and are versioned (e.g., `/v1`).

## Authentication
All endpoints require authentication. The API uses an `[Authorize]` attribute, and requests should include a valid Bearer token provided by Keycloak (OIDC/JWT).

---

## Members API

Endpoints for managing members.

### 1. Create a Member
Creates a new member in the system.

- **URL:** `/v1/Members`
- **Method:** `POST`
- **Body:** `CreateMemberCommand` (JSON object)
- **Responses:**
  - `200 OK`: Returns the newly created member's ID (`Guid`).
  - `400 Bad Request`: If the command validation fails.
  - `401 Unauthorized`: If the request is not authenticated.

### 2. Update a Member
Updates an existing member.

- **URL:** `/v1/Members/{id}`
- **Method:** `PUT`
- **Path Parameters:**
  - `id` (Guid): The ID of the member to update.
- **Body:** `UpdateMemberCommand` (JSON object)
- **Responses:**
  - `204 No Content`: If the member is updated successfully.
  - `400 Bad Request`: If the request body is null or command validation fails.
  - `401 Unauthorized`: If the request is not authenticated.
  - `404 Not Found`: If the member with the specified ID is not found.

### 3. Get Member Details
Gets the details of a specific member.

- **URL:** `/v1/Members/{id}`
- **Method:** `GET`
- **Path Parameters:**
  - `id` (Guid): The ID of the member to retrieve.
- **Responses:**
  - `200 OK`: Returns a `MemberDto` object containing member details.
  - `400 Bad Request`: If query validation fails.
  - `401 Unauthorized`: If the request is not authenticated.
  - `404 Not Found`: If the member with the specified ID is not found.

### 4. List All Members
Retrieves a list of all members.

- **URL:** `/v1/Members`
- **Method:** `GET`
- **Responses:**
  - `200 OK`: Returns an array of `MemberDto` objects.
  - `401 Unauthorized`: If the request is not authenticated.

---

## Personal Plans API

Endpoints for manipulating Personal Plans. Uses a flexible `{identifier}` route parameter where you can pass either a specific member's identity name or `"me"` for the currently authenticated user.

### 1. Create a Personal Plan
Creates a new personal plan for a member.

- **URL:** `/v1/members/{identifier}/PersonalPlans`
- **Method:** `POST`
- **Path Parameters:**
  - `identifier` (String): The identifier of the member ("me" or their identity name).
- **Body:** `CreatePlanCommand` (JSON object)
- **Responses:**
  - `200 OK`: Returns the newly created personal plan's ID (`Guid`).
  - `400 Bad Request`: If the command validation fails.
  - `401 Unauthorized`: If the request is not authenticated.
  - `403 Forbidden`: If attempting to create a plan for another user (where identifier does not match the authenticated user).

### 2. Update a Personal Plan
Updates an existing personal plan.

- **URL:** `/v1/members/{identifier}/PersonalPlans/{planId}`
- **Method:** `PUT`
- **Path Parameters:**
  - `identifier` (String): The identifier of the member ("me" or their identity name).
  - `planId` (Guid): The ID of the plan to update.
- **Body:** `UpdatePlanCommand` (JSON object)
- **Responses:**
  - `204 No Content`: If the plan is updated successfully.
  - `400 Bad Request`: If the request body is null or command validation fails.
  - `401 Unauthorized`: If the request is not authenticated.
  - `403 Forbidden`: If attempting to update another user's plan.

### 3. List Personal Plans
Retrieves all personal plans belonging to a member.

- **URL:** `/v1/members/{identifier}/PersonalPlans`
- **Method:** `GET`
- **Path Parameters:**
  - `identifier` (String): The identifier of the member ("me" or their identity name).
- **Responses:**
  - `200 OK`: Returns a collection of `PersonalPlanDto` objects.
  - `401 Unauthorized`: If the request is not authenticated.

### 4. Get Personal Plan Details
Retrieves details of a specific personal plan.

- **URL:** `/v1/members/{identifier}/PersonalPlans/{planId}`
- **Method:** `GET`
- **Path Parameters:**
  - `identifier` (String): The identifier of the member ("me" or their identity name).
  - `planId` (Guid): The ID of the personal plan to retrieve.
- **Responses:**
  - `200 OK`: Returns a `PersonalPlanDto` object containing plan details.
  - `401 Unauthorized`: If the request is not authenticated.
  - `404 Not Found`: If the personal plan with the specified ID is not found.

### 5. Patch Personal Plans (Not Implemented)
Preserved for updated custom Personal Plans Ordering and bulk plan updates.

- **URL:** `/v1/members/{identifier}/PersonalPlans`
- **Method:** `PATCH`
- **Path Parameters:**
  - `identifier` (String): The identifier of the member ("me" or their identity name).
- **Responses:**
  - `500 Internal Server Error`: Throws a `NotSupportedException`.
