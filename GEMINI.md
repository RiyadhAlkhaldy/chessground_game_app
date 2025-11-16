# Project Overview

This is a Flutter-based chess game application. It appears to be a comprehensive chess app with features like playing against a computer (Stockfish engine), sound effects, and different board themes. The project is structured following clean architecture principles, with a clear separation of concerns into `data`, `domain`, and `presentation` layers. It uses GetX for state management and routing.

## Building and Running

To build and run this project, you will need to have the Flutter SDK installed.

1.  **Get dependencies:**
    ```bash
    flutter pub get
    ```

2.  **Run the app:**
    ```bash
    flutter run
    ```

## Development Conventions

*   **State Management:** The project uses GetX for state management.
*   **Routing:** GetX is also used for routing. The routes are defined in `lib/routes/app_pages.dart`.
*   **Dependency Injection:** The project uses `get_it` for dependency injection, with the setup in `lib/di/ingection_container.dart`.
*   **Localization:** The app supports localization, with localization files in the `lib/l10n` directory.
*   **Code Generation:** The project uses `build_runner` for code generation, likely for `freezed` and `json_serializable`. After making changes to the data models, you may need to run the following command:
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
