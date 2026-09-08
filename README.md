<p align="center">
  <h1 align="center">Silora</h1>
</p>

<p align="center">
  A professional, real-time Flutter social and chat application.
</p>

---

## Overview

Silora is a modern, real-time social application that connects users through one-to-one messaging. It offers a seamless communication experience built around instant messaging, presence tracking, and profile discoverability. The application is completely localized for both English and Arabic, providing a native experience for users in different regions. 

With Silora, users can discover others, send friend requests, share their location, and engage in real-time conversations equipped with typing indicators and read receipts.

---

## Badges

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![BLoC](https://img.shields.io/badge/BLoC-blue?style=for-the-badge)

---

## Architecture Overview

Silora implements a **Feature-Based Layered Architecture**. The application is structured around discrete features, each having its own presentation and data layer, supported by shared core services. 

```text
       UI (Pages & Widgets)
                ↓
           Bloc / Cubit
                ↓
           Repository
                ↓
      Remote Data Source
                ↓
 Firebase (Firestore & RTDB)
```

### Architecture Decision

This architecture was chosen to ensure **separation of concerns** and **feature isolation**. By coupling data and presentation layers within feature directories, the codebase remains scalable and highly maintainable. Core functionality such as dependency injection, routing, theme configurations, and translations are centralized in a reusable core layer, maximizing code reuse without overcomplicating the structure with strict domain abstractions.

---

## Features

### Authentication
* Email & password registration
* Login
* Password reset
* Google Sign-In
* Email verification

### User & Profile
* User profiles
* Profile editing and management
* User discovery

### Friends
* Send friend requests
* Accept friend requests
* View friend list

### Real-Time Chat
* One-to-one text conversations
* Real-time messaging
* Typing indicators
* Seen/read status
* Unread message counts
* Delete message for me
* Delete message for everyone

### Presence
* Online/offline status indicators
* Last seen timestamps
* Automatic connection state handling

### Location
* Google Maps integration
* Location picker
* Geolocation & reverse geocoding

### Localization
* Full English support
* Full Arabic support
* Automatic RTL (Right-to-Left) layout handling

### UI / UX
* Responsive layouts
* ScreenUtil-based responsive sizing
* Custom, reusable widget system

---

## Tech Stack

| Category | Technology |
| --- | --- |
| **Framework** | Flutter |
| **Language** | Dart |
| **State Management** | BLoC / Cubit |
| **Backend** | Firebase |
| **Authentication** | Firebase Authentication |
| **Database** | Cloud Firestore / Realtime Database |
| **Routing** | GoRouter |
| **Dependency Injection** | GetIt / Injectable |
| **Localization** | Easy Localization |
| **Maps** | Google Maps |
| **Location** | Geolocator / Geocoding |
| **Local Storage** | SharedPreferences |

---

## Firebase Architecture

The application utilizes dual databases in Firebase to optimize performance and data structuring.

### Firebase Authentication
Handles user identity, Google Sign-In, and secure credential storage.

### Cloud Firestore
Used for persistent application data requiring robust query capabilities.
* `users` - Stores user profiles, location, and metadata.
* `friends` - Maintains the accepted connections between users.
* `friend_requests` - Tracks pending incoming and outgoing connection requests.

### Firebase Realtime Database
Used for high-frequency, low-latency data streams.
* `conversations/` - Conversation metadata, unread counts, and last message snippets.
* `messages/` - The actual real-time message payloads between users.
* `status/` - Tracks online/offline presence and last seen timestamps.
* `typing/` - Ephemeral typing indicator states.

---

## Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── di/
│   ├── error/
│   ├── routes/
│   ├── services/
│   ├── theme/
│   ├── translations/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── auth/
│   ├── chat/
│   ├── friends/
│   ├── layout/
│   ├── onboarding/
│   └── profile/
│
├── main.dart
└── silora.dart
```

* **`core/`**: Houses application-wide utilities, dependency injection configurations, routing logic, theming, and shared widgets.
* **`features/`**: Contains the main feature modules. Each folder encapsulates its own presentation (UI, Bloc/Cubit) and data (Repositories, Data Sources, Models) responsibilities.

---

## Screenshots

### Splash & Onboarding

<p align="center">
  <img src="assets/screenshots/splash.png" width="200" alt="Splash Screen">
</p>

<p align="center">
  <b>English</b><br>
  <img src="assets/screenshots/onboarding_en.png" width="200" alt="Onboarding English">
</p>

<p align="center">
  <b>العربية</b><br>
  <img src="assets/screenshots/onboarding_ar.png" width="200" alt="Onboarding Arabic">
</p>

### Authentication

<p align="center">
  <b>English</b><br>
  <img src="assets/screenshots/login_en.jpeg" width="200" alt="Login English">
  <img src="assets/screenshots/signup_en.jpeg" width="200" alt="Signup English">
  <img src="assets/screenshots/signup_success_message.png" width="200" alt="Signup Success Message">
</p>

<p align="center">
  <b>العربية</b><br>
  <img src="assets/screenshots/login_ar.png" width="200" alt="Login Arabic">
  <img src="assets/screenshots/signup_ar.png" width="200" alt="Signup Arabic">
</p>

### Conversations List (Home)

<p align="center">
  <b>English</b><br>
  <img src="assets/screenshots/chats_en.jpeg" width="200" alt="Chats English"> 
  <img src="assets/screenshots/chat_empty_en.png" width="200" alt="Another Empty Chat English">
</p>

<p align="center">
  <b>العربية</b><br>
  <img src="assets/screenshots/chats_ar.jpeg" width="200" alt="Chats Arabic">
  <img src="assets/screenshots/chats_empty_ar.png" width="200" alt="Empty Chats Arabic">
</p>

### Chat

<p align="center">
  <b>English</b><br>
  <img src="assets/screenshots/chat_en.jpeg" width="200" alt="Chat English">
  <img src="assets/screenshots/empty_chat_en.jpeg" width="200" alt="Empty Chat English">
 
</p>

<p align="center">
  <b>العربية</b><br>
  <img src="assets/screenshots/chat_ar.jpeg" width="200" alt="Chat Arabic">
  <img src="assets/screenshots/empty_chat_ar.jpeg" width="200" alt="Empty Chat Arabic">
</p>

### Message Actions

<p align="center">
  <b>English</b><br>
  <img src="assets/screenshots/selected_message_en.jpeg" width="200" alt="Selected Message">
  <img src="assets/screenshots/delete_message_en.jpeg" width="200" alt="Delete Message Options">
</p>

### Friends

<p align="center">
  <b>English</b><br>
  <img src="assets/screenshots/friends_en.jpeg" width="200" alt="Friends English">
  <img src="assets/screenshots/friends_empty_en.png" width="200" alt="Empty Friends English">
</p>

<p align="center">
  <b>العربية</b><br>
  <img src="assets/screenshots/friends_ar.jpeg" width="200" alt="Friends Arabic">
  <img src="assets/screenshots/friends_empty_ar.png" width="200" alt="Empty Friends Arabic">
</p>

### Add Friend

<p align="center">
  <b>English</b><br>
  <img src="assets/screenshots/add_friend_en.png" width="200" alt="Add Friend English">
</p>

<p align="center">
  <b>العربية</b><br>
  <img src="assets/screenshots/add_friend_ar.png" width="200" alt="Add Friend Arabic">
</p>

### Profile

<p align="center">
  <b>English</b><br>
  <img src="assets/screenshots/profile_en.png" width="200" alt="Profile English">
</p>

<p align="center">
  <b>العربية</b><br>
  <img src="assets/screenshots/profile_ar.png" width="200" alt="Profile Arabic">
</p>

---

## Getting Started

### Prerequisites
* Flutter SDK (>= 3.8.1)
* Dart SDK
* Android Studio / Xcode for emulators
* A Firebase Project
* Google Maps API Key

### Installation

Clone the repository and install the dependencies:

```bash
git clone <repository-url>
cd <project-folder>
flutter pub get
```

### Code Generation

Silora heavily relies on code generation for dependency injection and routing. Whenever you make changes to injectable components, run the build runner:

```bash
dart run build_runner build --delete-conflicting-outputs
```

If you modify or add translations, generate the localization keys:

```bash
dart run easy_localization:generate -S assets/translations -f keys -O lib/core/translations -o codegen_loader.g.dart
```

---

## Firebase Configuration

This project requires Firebase to operate. You must configure your own Firebase project.
1. Create a Firebase project.
2. Enable Authentication (Email/Password, Google Sign-In).
3. Enable Cloud Firestore and Realtime Database.
4. Add the appropriate `google-services.json` to `android/app/`.
5. Add the appropriate `GoogleService-Info.plist` to `ios/Runner/`.

*Note: Do not commit your sensitive configuration files or API keys.*

---

## Google Maps Configuration

To enable the location selection feature, you must configure your Google Maps API keys.
* **Android:** Add your API key to the `AndroidManifest.xml` inside `<application>`.
* **iOS:** Provide your API key in the `AppDelegate.swift` file.

---

## Localization

Silora is built with full internalization support using `easy_localization`.
* **Supported Languages:** English (en) and Arabic (ar).
* **RTL Support:** The UI automatically mirrors and aligns correctly when Arabic is selected.
* **Translation Files:** All string assets are maintained in `assets/translations/`. 

---

## Future Improvements

* Push notifications
* Group conversations
* Media/file sharing capabilities
* Voice and video calls
* Friend request rejection/declining

---

## Limitations

* Text-only messaging (No media sharing)
* One-to-one conversations only
* No push notification support
* No voice/video calling implemented

---

## License

License: Not specified.
