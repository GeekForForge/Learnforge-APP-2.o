# 📱 LearnForge-APP 2.0 - Mobile Learning Platform

![GitHub Stars](https://img.shields.io/github/stars/GeekForForge/Learnforge-APP-2.o?style=social)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Commits](https://img.shields.io/github/commit-activity/m/GeekForForge/Learnforge-APP-2.o)

> **A modern cross-platform mobile application** for structured programming and education.
> Built with cutting-edge technologies to provide seamless learning experiences on mobile devices.
>
> 🚀 **Mission**: Bring high-quality education to mobile devices with an intuitive, distraction-free experience.

## 📋 Overview

LearnForge-APP 2.0 is the mobile client for the LearnForge platform, designed to deliver structured learning paths for programming education. This next-generation app provides offline support, rich course content, progress tracking, and seamless synchronization with the cloud backend.

## ✨ Features

- 📱 **Cross-Platform Support** - Works on iOS and Android
- 🎥 **Offline Learning** - Download and study without internet
- 📊 **Progress Tracking** - Monitor your learning journey in real-time
- 🔄 **Cloud Sync** - Automatic synchronization with backend
- 🌙 **Dark Mode** - Comfortable learning at any time
- 🎯 **Structured Courses** - Spring Boot, React, DSA, and more
- 💾 **Local Database** - Fast, reliable data management
- 🔐 **Secure Authentication** - OAuth 2.0 integration
- 📚 **Ad-Free Experience** - Focus on learning without distractions
- ⚡ **High Performance** - Optimized for all devices

## 🛠️ Tech Stack

### Mobile Development
- **Language**: Dart 66.6%
- **Framework**: Flutter - Cross-platform UI toolkit
- **State Management**: Provider / Bloc / GetX
- **Local Storage**: SQLite / Hive
- **Networking**: HTTP / REST APIs

### Native Integration
- **C++ (4.6%)** - Performance-critical components
- **Platform-Specific Code**: Native iOS/Android APIs
- **Hardware Access**: Camera, location, sensors

### Frontend Assets
- **HTML (24.3%)** - Embedded web content
- **CSS** - Responsive styling
- **JavaScript** - Interactive features

### Build Tools
- **CMake (3.7%)** - C++ build system
- **Swift (0.5%)** - iOS-specific code
- **Gradle** - Android build system

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK** (v3.10+)
- **Dart SDK** (v3.0+)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development on macOS)
- **Git**
- **Visual Studio Code** or similar IDE

### Installation

```bash
# Clone the repository
git clone https://github.com/GeekForForge/Learnforge-APP-2.o.git
cd Learnforge-APP-2.o

# Get Flutter packages
flutter pub get

# Generate necessary files (if using build_runner)
flutter pub run build_runner build

# Run the app on Android
flutter run -d android

# Run the app on iOS
flutter run -d ios

# Run on specific device
flutter devices  # List available devices
flutter run -d <device_id>
```

### Directory Structure

```
learnforge_app/
├── android/                    # Android native code
│   ├── app/
│   └── gradle/
├── ios/                        # iOS native code
│   ├── Runner/
│   └── Pods/
├── lib/                        # Dart/Flutter application
│   ├── main.dart              # Application entry point
│   ├── models/                # Data models
│   ├── screens/               # App screens/pages
│   ├── widgets/               # Reusable widgets
│   ├── services/              # API and data services
│   ├── providers/             # State management
│   ├── utils/                 # Utility functions
│   ├── constants/             # App constants
│   └── themes/                # App theming
├── test/                       # Unit and widget tests
├── cpp/                        # C++ native code
│   └── CMakeLists.txt
├── web/                        # Web assets
│   ├── index.html
│   └── manifest.json
├── pubspec.yaml               # Flutter dependencies
├── pubspec.lock               # Lock file
└── README.md                  # This file
```

## 📱 App Architecture

```
┌─────────────────────────────────┐
│       Flutter UI Layer          │
│   (Screens & Widgets)           │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│    State Management Layer       │
│   (Provider/Bloc/GetX)          │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│      Business Logic Layer       │
│   (Services & Use Cases)        │
└──────────────┬──────────────────┘
               │
┌──────────────▼──────────────────┐
│      Data Layer                 │
│   (APIs, SQLite, Hive)          │
└──────────────┬──────────────────┘
               │
        ┌──────┴──────┐
        │             │
   ┌────▼──┐     ┌───▼────┐
   │Backend│     │ Native  │
   │APIs   │     │ Modules │
   └───────┘     └────────┘
```

## 🎯 Key Screens

1. **Onboarding & Authentication**
   - Splash screen
   - Login/Sign-up
   - OAuth integration

2. **Home Dashboard**
   - Course recommendations
   - Continue learning section
   - Progress overview

3. **Courses Catalog**
   - Browse courses
   - Search and filter
   - Course details

4. **Learning Experience**
   - Video player
   - Course content
   - Progress tracking
   - Bookmarks & notes

5. **User Profile**
   - Personal information
   - Learning statistics
   - Certificates
   - Settings

## 🔌 API Integration

The app communicates with the backend through RESTful APIs:

```
Base URL: https://api.learnforge.com/api

Key Endpoints:
- GET    /courses              # Get all courses
- GET    /courses/{id}         # Get course details
- GET    /lessons/{courseId}   # Get lessons for course
- POST   /progress             # Update progress
- GET    /user/profile         # Get user profile
- PUT    /user/profile         # Update profile
- POST   /sync                 # Sync offline data
```

## 🧪 Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests
```bash
flutter test --test-randomize-ordering-seed random
```

### Integration Tests
```bash
flutter test integration_test/app_test.dart
```

### Build APK (Android)
```bash
flutter build apk --release
flutter build appbundle --release  # For Google Play
```

### Build IPA (iOS)
```bash
flutter build ios --release
```

## 🎨 Customization

### Theming

Modify `lib/themes/app_theme.dart` to customize:
- Color scheme
- Typography
- Button styles
- Dark/Light modes

### Localization

Supports multiple languages through `lib/l10n/`:
- English (en)
- Spanish (es)
- French (fr)
- More languages coming soon

## 🔒 Security Considerations

- ✅ Encrypted local storage for sensitive data
- ✅ SSL/TLS for all API communications
- ✅ OAuth 2.0 authentication
- ✅ JWT token refresh mechanism
- ✅ App attestation on native platforms
- ✅ Regular security audits

## 🚀 Performance Optimization

- Lazy loading of content
- Image caching and optimization
- Database indexing
- Efficient state management
- Minimal app size (target: < 100MB)
- Fast startup time (< 2 seconds)

## 📚 Dependencies

Key Flutter packages:

```yaml
# State Management
provider: ^6.0.0
bloc: ^8.0.0
get: ^4.0.0

# Networking
http: ^1.0.0
dio: ^5.0.0

# Local Storage
sqflite: ^2.0.0
hive: ^2.0.0

# UI & Design
flutter_screenutil: ^5.0.0
get_it: ^7.0.0

# Video Playback
video_player: ^2.0.0
chewie: ^1.0.0

# Authentication
firebase_auth: ^4.0.0
google_sign_in: ^6.0.0
```

## 🤝 Contributing

We welcome contributions! Here's how to help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow Dart style guide (`dart format`)
- Write meaningful commit messages
- Add unit tests for new features
- Update documentation
- Test on both Android and iOS
- Ensure no breaking changes

## 🐛 Bug Reports & Features

- **Report Bugs**: [Open an issue](https://github.com/GeekForForge/Learnforge-APP-2.o/issues)
- **Request Features**: [Discussions](https://github.com/GeekForForge/Learnforge-APP-2.o/discussions)
- **Security Issues**: hello@geekforforge.com

## 📊 Project Statistics

- **Repository**: Open-source on GitHub
- **Language Breakdown**: Dart (66.6%), HTML (24.3%), C++ (4.6%), CMake (3.7%), Swift (0.5%), C (0.3%)
- **Latest Commit**: December 2, 2025
- **Total Commits**: 3
- **Platform Support**: iOS 12.0+, Android 8.0+

## 🗺️ Roadmap

### Current Version (2.0)
- ✅ Core learning features
- ✅ Offline support
- ✅ Progress tracking
- ⏳ Video streaming optimization
- ⏳ Advanced analytics

### Planned Features
- [ ] Push notifications
- [ ] Live tutoring sessions
- [ ] Community features
- [ ] Gamification
- [ ] Advanced search
- [ ] Achievement system
- [ ] Certificate generation
- [ ] Social sharing
- [ ] Multi-language support

## 📝 License

This project is licensed under the MIT License. See [LICENSE.md](./LICENSE.md) for details.

## 📞 Support & Community

- **Documentation**: [Wiki](https://github.com/GeekForForge/Learnforge-APP-2.o/wiki)
- **Discussions**: [GitHub Discussions](https://github.com/GeekForForge/Learnforge-APP-2.o/discussions)
- **Twitter**: [@GeekForForge](https://twitter.com/GeekForForge)
- **Email**: support@geekforforge.com

## 🎓 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Firebase Integration](https://firebase.flutter.dev/docs/overview)
- [REST API Best Practices](https://restfulapi.net/)

## 👥 Contributors

- [@samarth-sachin](https://github.com/samarth-sachin)
- [Other contributors welcome!](CONTRIBUTING.md)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- LearnForge backend team
- All open-source contributors
- Community feedback and support

---

**Made with ❤️ by GeekForForge**

⭐ If you find LearnForge-APP helpful, please star the repository!

[Report Bug](https://github.com/GeekForForge/Learnforge-APP-2.o/issues) • [Request Feature](https://github.com/GeekForForge/Learnforge-APP-2.o/discussions) • [Documentation](https://github.com/GeekForForge/Learnforge-APP-2.o/wiki)
