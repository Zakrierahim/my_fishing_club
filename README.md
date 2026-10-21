# My Fishing App

A dark, ocean-themed Flutter companion for fishing. This first version is a local prototype: splash, login, account creation, and a four-tab shell. There is no backend and no real authentication.

The interface is available in **English** and **Bahasa Melayu**. English is the default. The language chosen in Settings is saved on the device and restored on the next launch.

## Features

- Splash screen with the night-fishing artwork, then the login screen
- Login and create-account forms that open the app without checking credentials
- Social sign-in buttons for Google, Facebook, TikTok, and WhatsApp. These do not sign anyone in until a backend confirms the identity
- Linked Accounts in Settings. Every provider stays "Not connected" until that confirmation
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
├── controllers/     # Provider ChangeNotifiers (tabs, login, locale, auth)
├── core/            # Theme, constants, navigation, and the auth gateway
├── generated/l10n/  # Generated AppLocalizations
├── l10n/            # English and Bahasa Melayu ARB files
├── models/          # Provider identity and link results
├── views/           # Splash, login, register, and tab screens
└── widgets/         # Shared layout and navigation widgets
```

## Social sign-in setup

There is no authentication backend in this project, and no provider app is configured. Google, Facebook, TikTok, and WhatsApp buttons report **Configuration required** and stay on the login screen. Settings does not show **Connected** for any provider. The email login and register actions are still the local prototype; they do not create a provider session.

A real integration needs a backend that checks the provider identity and creates the app session. Keep client secrets, one-time codes, and token exchange on that server. Do not mark an account linked from the button alone.

| Provider | What is still missing |
| --- | --- |
| Google | OAuth client for Android package `com.example.my_fishing_club` (debug and release SHA-1 / SHA-256) and iOS bundle `com.example.myFishingClub`. Add `google_sign_in` only after those clients and the session backend exist. The iOS URL scheme is the reversed iOS client ID. |
| Facebook | Facebook app ID, client token, iOS URL scheme `fb{app-id}`, and Android key hashes. Package: `flutter_facebook_auth`. The app must not ship the client token as a session. |
| TikTok | Login Kit client key, redirect URI, PKCE `state`, and server-side authorization-code exchange. No in-app token exchange. |
| WhatsApp | Not an OAuth login. Phone verification has to be sent by a backend that supports WhatsApp one-time codes. The app only collects the phone number and the code the user received. |

`AuthGateway` in `lib/core/auth/auth_gateway.dart` is the seam for that backend. `UnconfiguredAuthGateway` is what the app uses today.

State is managed with Provider. Strings come from Flutter's `gen-l10n` setup. Add copy in `lib/l10n/app_en.arb` and `lib/l10n/app_ms.arb`, then run:

```bash
flutter gen-l10n
```
