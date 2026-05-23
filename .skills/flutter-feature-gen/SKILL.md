---
name: flutter-feature-gen
description: Generates a standardized Flutter feature folder structure using Clean Architecture and Riverpod. Use when the user wants to add a new module or feature like 'auth', 'home', or 'settings'.
---

# Flutter Feature Generator

When a user asks to generate a feature, follow this structure:

## 1. Directory Structure
Create the following folders under `lib/features/<feature_name>/`:
- `data/`: `datasources/`, `repositories/`, `models/`
- `domain/`: `entities/`, `repositories/`, `usecases/`
- `presentation/`: `pages/`, `widgets/`, `providers/`

## 2. Boilerplate Code
- **Provider:** Create a basic `StateNotifierProvider` or `NotifierProvider` in `presentation/providers/`.
- **Entity:** Create a simple class in `domain/entities/`.
- **Page:** Create a `ConsumerWidget` in `presentation/pages/`.

## 3. Workflow
1. Ask the user for the feature name.
2. Confirm if any specific fields are needed for the model/entity.
3. Create all directories first.
4. Generate the boilerplate files.
5. Update `lib/main.dart` or the router if necessary.
