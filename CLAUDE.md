# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Real-time chat application with a Node.js/TypeScript backend and Flutter mobile client. Both use Clean Architecture with feature-first organization.

## Development Commands

### Backend (`backend/`)
- **Dev server:** `npm run dev` (nodemon + ts-node, hot reload)
- **Build:** `npm run build` (compiles TypeScript to `dist/`)
- **Production:** `npm start` (runs compiled JS)
- **Database:** `docker-compose up -d` (PostgreSQL 16 on port 5432, schema auto-created on server start)

### Mobile (`client/mobile/`)
- **Run:** `flutter run`
- **Build:** `flutter build apk` / `flutter build ios`
- **Get deps:** `flutter pub get`

## Architecture

Both backend and mobile follow the same layered structure per feature:

```
features/<feature_name>/
  domain/       → Entities, usecases, repository contracts (pure Dart/TS, no framework imports)
  data/         → Datasources, models, repository implementations
  presentation/ → Controllers/cubits, pages, widgets, routes
```

**Dependency rule:** Presentation → Domain ← Data. Domain never depends on Data or Presentation.

### Backend
- **Framework:** Express 5 + Socket.IO
- **Entry point:** `src/index.ts` (HTTP server + Socket.IO `/chat` namespace)
- **Auth:** JWT Bearer tokens, middleware in `core/middlewares/auth.ts`
- **Features:** `auth`, `chat`, `friendship`
- **Database:** PostgreSQL via `pg` pool (config in `core/config/database.ts`)
- **Real-time events:** `join:conversation`, `send:message`, `new:message`, `error:message`

### Mobile (Flutter)
- **State management:** flutter_bloc (Cubit pattern)
- **DI:** get_it service locator (`core/di/service_locator.dart`)
- **Error handling:** fpdart `Either<Failure, T>` for result types
- **Networking:** Custom `ApiClient` with JWT auth headers; `SocketService` for Socket.IO
- **Routing:** Named routes in `core/router/app_router.dart`
- **Features:** `auth`, `chats`, `home`, `people`, `settings`, `notifications`

## Conventions (from .cursorrules)

- **English only** for all UI strings, comments, and code
- **No emojis or icons** in comments
- Usecases: verb+noun naming (e.g., `GetMessages`, `SendMessage`), single public `call()` method
- Repositories: contract is `<Feature>Repository`, implementation is `<Feature>RepositoryImpl`
- Data layer catches exceptions and maps to typed `Failure` objects; presentation converts failures to user-facing messages in one place
- When changing a feature, update the full vertical slice (navigation, UI, state, usecase, repo, datasource) and remove dead code
- Domain layer tests are highest priority

## Definition of Done
A task is done only when:
- code is implemented
- relevant state flows are handled
- loading/error/empty states are considered if applicable
- tests are added or test impact is explained
- flutter analyze passes
- changed files are summarized
- trade-offs / known limitations are reported
