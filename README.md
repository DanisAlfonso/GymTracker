# Gym Tracker

Gym Tracker is a Flutter-based mobile application designed to help users track their workout routines, exercises, and progress. The app provides functionalities such as viewing and editing workout routines, tracking exercise performance, and managing user preferences.

## Features

- **Multilingual Support**: The app supports multiple languages including English, Spanish, French, and German.
- **Workout Routines**: Create, view, and edit workout routines.
- **Exercise Performance Tracking**: Track and visualize performance for different exercises over time.
- **Progress Overview**: Weekly and monthly progress visualizations.
- **User Preferences**: Customize app settings, including unit preferences and workout reminders.
- **Data Persistence**: User data is saved using shared preferences.

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) should be installed on your local machine.
- An IDE like [Visual Studio Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio) is recommended.

### Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/DanisAlfonso/gym_tracker.git
    cd gym_tracker
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Run the app:**
    ```sh
    flutter run
    ```

## Project Structure

- **lib/**
    - **models/**: Contains the data models for exercises and workout routines.
    - **screens/**: Contains the UI screens such as Home, Settings, Statistics, etc.
    - **statistics/**: Contains widgets for displaying various statistics.
    - **app_localizations.dart**: Manages localization for different languages.
    - **main.dart**: The entry point of the application.

- **assets/languages/**: Contains JSON files for different languages.
    - **en.json**: English translations.
    - **es.json**: Spanish translations.
    - **fr.json**: French translations.
    - **de.json**: German translations.

## Usage

### Localization

To add a new language, create a new JSON file in the `assets/languages/` directory with the translations for your desired language. Update the `isSupported` method in `app_localizations.dart` to include the new language code.

### Adding a New Screen

1. Create a new Dart file in the `lib/screens/` directory.
2. Define your screen widget.
3. Update the navigation in the appropriate place (e.g., add a new route in `main.dart` or link in a settings menu).

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/YourFeature`.
3. Make your changes and commit them: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature/YourFeature`.
5. Submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [FL Chart](https://pub.dev/packages/fl_chart) for charting widgets.
- [Provider](https://pub.dev/packages/provider) for state management.
- [Shared Preferences](https://pub.dev/packages/shared_preferences) for data persistence.

---

*Note: Replace any placeholder text such as URLs and email addresses as needed.*
