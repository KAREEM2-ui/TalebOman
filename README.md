# Scholarship Finder (projectapp)

A Flutter application for discovering and managing scholarships.

This project is a Flutter app ("Scholarship Finder") built with Flutter and Firebase. It includes theming (light/dark), Firebase initialization, push/notification service initialization, and provider-based state management.

## Key features

- App name: Scholarship Finder
- Firebase initialization on startup (Firebase Core)
- Local notification / push notification initialization via a NotificationService
- MultiProvider state management (ThemeProvider, AuthenticationProvider)
- Light and dark themes with custom color palette
- Splash screen that checks authentication status and redirects users based on role
- Protected navigation: certain routes (ministryHomeScreen, userHomeScreen) require authentication

## Project structure (high level)

- lib/main.dart -> application entrypoint, initializes Firebase and notification service, wraps app in providers
- lib/utils/Thems/Colors.dart -> centralized color definitions for light/dark themes
- lib/Screens/Auth/SplashScreen.dart -> splash UI, login check and redirection logic
- lib/Providers/ -> app state providers (Auth, Theme, etc.)
- lib/Screens/ -> UI screens organized by feature and user roles

## Prerequisites

- Flutter SDK (matching the project Flutter version)
- A Firebase project and the platform-specific configuration files (e.g., GoogleService-Info.plist for iOS, google-services.json for Android)

## Setup & run

1. Install Flutter and ensure flutter command is available.
2. Add Firebase config files to the corresponding platform folders (Android/iOS) and ensure firebase_core is configured.
3. Ensure assets (e.g., assets/images/logo.png) are available and declared in pubspec.yaml.
4. Run flutter pub get to fetch dependencies.
5. Run the app:

   flutter run

Note: On startup the app initializes Firebase and a NotificationService. Make sure any platform-specific notification configuration is completed (notification permissions, manifest entries, APNs setup, etc.) before using notification features.

## Development notes

- The app uses Provider for state management (see lib/Providers/).
- The splash screen uses AuthenticationProvider to determine if the user is logged in and redirects accordingly.
- The app's MaterialApp has an onGenerateRoute hook that prevents unauthenticated access to protected routes and redirects to the auth screen when needed.
- Theme colors and styles are defined under lib/utils/Thems/ and can be customized.

If you are contributing or extending the app, review the providers and repositories under lib/Providers and lib/Repositories for business logic and data access.
