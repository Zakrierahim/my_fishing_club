# My Fishing App

A dark, ocean-themed Flutter companion for fishing. This first version is a local prototype: splash, login, account creation, and a four-tab shell. There is no backend and no real authentication.

The interface is available in **English** and **Bahasa Melayu**. English is the default. The language chosen in Settings is saved on the device and restored on the next launch.

## Features

- Splash screen with the night-fishing artwork, then the login screen
- Login and create-account forms that open the app without checking credentials
- Home header using the wide fishing scene
- Floating bottom navigation: Home, Explore, Notification, and Settings
- Language selector in Settings for English and Bahasa Melayu
- Layouts that adapt to phones, tablets, and landscape

Explore, Notification, and the rest of Home are placeholders for later features.

## Requirements

- Flutter 3.41 or newer (Dart 3.11)
- iOS 15 or newer when building for iPhone

## Run

```bash
flutter pub get
flutter run
```

On iPhone, pick the device when Flutter asks, or pass it directly:

```bash
flutter run -d <device>
```

## Checks

```bash
flutter analyze
flutter test
```

## Project layout

```text
lib/
├── controllers/     # Provider ChangeNotifiers (tabs, login, locale)
├── core/            # Theme, constants, and navigation
├── generated/l10n/  # Generated AppLocalizations
├── l10n/            # English and Bahasa Melayu ARB files
├── views/           # Splash, login, register, and tab screens
└── widgets/         # Shared layout and navigation widgets
```

State is managed with Provider. Strings come from Flutter's `gen-l10n` setup. Add copy in `lib/l10n/app_en.arb` and `lib/l10n/app_ms.arb`, then run:

```bash
flutter gen-l10n
```
