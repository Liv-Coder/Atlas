# Atlas (`com.atlas.chat`)

**Atlas** is a modular Flutter monorepo AI Agent & Chat application built on the [`Liv-Coder/flutter_monorepo_boilerplate`](https://github.com/Liv-Coder/flutter_monorepo_boilerplate) architecture using **Dart 3.7+ Pub Workspaces** and **Melos 7**.

## Monorepo Architecture

```text
atlas/
├── apps/
│   └── atlas/                  # Main Flutter app (com.atlas.chat)
├── packages/
│   ├── core/                   # Result<T>, Dio SSE client, Secure & KV Storage, Env
│   ├── design_system/          # Light/Dark tokens, Manrope & JetBrains Mono, Atomic UI
│   ├── logger/                 # Structured multi-level AppLogger with key redaction
│   ├── routing/                # GoRouter navigation primitives & transitions
│   └── storage/                # Offline-first Hive CE persistence for sessions & prefs
├── tool/
│   └── setup.dart              # Interactive workspace setup & verifier
├── melos.yaml
└── pubspec.yaml
```

## Key Features

- **Multi-Provider Agent Switcher**: Cline (`minimax/minimax-m2.5`), OpenRouter (`nvidia/nemotron-3.5-super-vl:free`), Gemini (`gemini-2.5-flash`), and Custom OpenAI-compatible endpoints.
- **Three Execution Modes**:
  - **Plan (`PLAN`)**: Outlines checkable steps and drafts before running.
  - **Chat (`CHAT`)**: Fast everyday conversation without planning overhead.
  - **Agent (`AGENT`)**: 4-stage autonomous workflow (`Plan → Gather → Execute → Verify`) with live progress stepper, progress bar, and explicit user approval cards (`Approve & run` / `Edit plan`).
- **Sessions Drawer**: Grouped into **PINNED**, **TODAY**, and **PREVIOUS** with real-time search, Pin/Unpin, Duplicate, and Delete with 5-second **Undo** snackbar.
- **Full Settings Suite**: Provider & Model selector, tap-to-reveal device-local API key (`FlutterSecureStorage`), Agent approvals switch, Workflow progress toggle, Dark/Light segmented theme switcher, Text size scaling (`S` / `M` / `L`), Chat `.txt` export, and App data reset.

## Quick Start

```bash
# 1. Resolve workspace dependencies across all apps and packages
flutter pub get
# or via Melos:
dart run melos bootstrap

# 2. Run static analysis & tests
dart run melos run analyze
dart run melos run test

# 3. Launch Atlas
cd apps/atlas
flutter run
```
