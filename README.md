# ACT Planner App

[![Flutter](https://img.shields.io/badge/Flutter-3.7+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-blue.svg)](https://flutter.dev/docs/deployment)

An event planning and management application built with Flutter, designed to help users organize and coordinate various types of events including weddings, school annual days, and society gatherings.

## ⚠️ Status

This is an MVP and still under active development. Not intended for production use.

## 🎯 Features

### Event Management
- **Multi-Event Support**: Create and manage different types of events (Weddings, School Annual Days, Society Events)
- **Event Details**: Comprehensive event information including venue, date, time, and description
- **Event Timeline**: Visual timeline view for better event planning

### Act & Performance Management
- **Act Scheduling**: Plan and schedule individual acts within events
- **Duration Management**: Precise timing control for each act
- **Sequence Planning**: Organize acts in the desired order
- **Approval Workflow**: Track approval status for acts

### Contact Management
- **Participant Database**: Store and manage contact information
- **Contact Import**: Import contacts from device
- **Role Assignment**: Assign roles to participants

### Asset Management
- **Resource Tracking**: Manage assets associated with acts and events
- **Asset Types**: Categorize different types of resources
- **File Management**: Organize and track event-related files

### User Experience
- **Cross-Platform**: Works on Android, iOS, Web, and Desktop
- **Modern UI**: Material Design 3 with custom Roboto font family
- **Responsive Design**: Adapts to different screen sizes
- **Offline Support**: Local data storage with Hive database

## 🚀 Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) 3.7.0 or higher
- [Dart](https://dart.dev/get-dart) 3.7.0 or higher
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ankk98/act_planner_app.git
   cd act_planner_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (required for local database)
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Building for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

#### Desktop
```bash
flutter build windows --release  # Windows
flutter build macos --release    # macOS
flutter build linux --release    # Linux
```

## 🏗️ Project Structure

```
lib/
├── adapters/          # Hive database adapters
├── models/            # Data models (Event, Act, Contact, Asset)
├── providers/         # State management with Provider
├── screens/           # UI screens and pages
├── services/          # Business logic and API services
├── widgets/           # Reusable UI components
└── main.dart          # Application entry point
```

### Key Components

- **Models**: Data structures for events, acts, contacts, and assets
- **Providers**: State management using Provider pattern
- **Services**: API integration, local storage, and business logic
- **Screens**: Main application views and navigation
- **Widgets**: Reusable UI components

## 🛠️ Technology Stack

- **Frontend**: Flutter with Material Design 3
- **State Management**: Provider pattern
- **Local Database**: Hive (NoSQL database)
- **HTTP Client**: http package for API communication
- **Date/Time**: intl package for internationalization
- **File Management**: path_provider and path packages
- **UI Components**: carousel_slider, flutter_contacts
- **Permissions**: permission_handler for device access

## 📱 Screenshots

*[Screenshots will be added here]*

## 🔧 Configuration

### Environment Setup

The app uses several configuration files:
- `pubspec.yaml`: Dependencies and project metadata
- `analysis_options.yaml`: Dart analysis rules
- `devtools_options.yaml`: Development tools configuration

### Database Configuration

Hive database is automatically initialized with the following boxes:
- `events`: Event data storage
- `acts`: Act/performance data storage
- `contacts`: Contact information storage
- `assets`: Asset/resource data storage

## 🧪 Testing

Run tests using:
```bash
flutter test
```

For widget tests:
```bash
flutter test test/widget_test.dart
```

## 📦 Dependencies

### Core Dependencies
- `flutter`: Flutter SDK
- `hive`: Local NoSQL database
- `provider`: State management
- `intl`: Internationalization
- `http`: HTTP client for API calls

### UI Dependencies
- `carousel_slider`: Image carousel functionality
- `flutter_contacts`: Contact management
- `permission_handler`: Device permissions

### Development Dependencies
- `hive_generator`: Code generation for Hive
- `build_runner`: Build system for code generation
- `flutter_lints`: Code quality rules

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Run tests**
   ```bash
   flutter test
   ```
5. **Commit your changes**
   ```bash
   git commit -m 'Add amazing feature'
   ```
6. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### Contribution Guidelines

- Follow Flutter coding standards
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

## 🐛 Issue Reporting

Found a bug? Please report it:

1. Check existing issues to avoid duplicates
2. Create a new issue with:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Device/OS information
   - Flutter version

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Hive team for the local database solution
- Provider package maintainers
- All contributors and supporters

## 📞 Support

- **Documentation**: [Flutter Docs](https://flutter.dev/docs)
- **Issues**: [GitHub Issues](https://github.com/Ankk98/act_planner_app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Ankk98/act_planner_app/discussions)

## 🔮 Roadmap

Checkout issues on Github.

---

**Made with ❤️ using Flutter**

*If you find this project helpful, please consider giving it a ⭐ on GitHub!*
