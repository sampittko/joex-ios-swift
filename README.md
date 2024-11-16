# Joex - Journal extension app

Joex is a native iOS application built with SwiftUI that helps users quickly capture and manage their thoughts and notes. This is the original implementation that inspired the cross-platform [PWA version](https://github.com/sampittko/joex-pwa-ionic).

## 🌟 Features

- Quick note capture with floating action button
- SwiftUI native animations and transitions
- Two-state system: Active & Migrated notes
- Secure storage with SwiftData
- Native iOS notifications
- Face ID authentication support
- Dark mode support
- Siri Shortcuts integration
- Firebase Analytics integration

## 🔧 Technology Stack

- Swift 5
- SwiftUI
- SwiftData
- Firebase SDK
- App Intents (Siri Shortcuts)
- Local Authentication Framework

## 🏗️ Project Structure

The project follows a modular architecture with:

- **Views**: UI components organized by feature
- **Models**: SwiftData models
- **Intents**: Siri Shortcuts integration
- **Constants**: App-wide configuration
- **Helpers**: Utility functions

## 💡 Legacy

This SwiftUI implementation served as the foundation and inspiration for the cross-platform PWA version. While this version provides the best native iOS experience, the PWA implementation aims to make the app accessible to all users across different platforms.

## 🚀 Getting Started

1. Clone the repository:

```bash
git clone https://github.com/sampittko/joex-ios-swift.git
```

2. Open the project in Xcode:

```bash
open Joex.xcodeproj
```

3. Install dependencies through Swift Package Manager (automatically handled by Xcode)

4. Build and run the project in Xcode

## 📱 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## 🔒 Privacy

Joex respects your privacy:
- All data is stored locally using SwiftData
- Face ID authentication for added security
- Analytics data is anonymized through Firebase
- No personal data is collected or shared

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 Author

Samuel Pitonak - [@sampittko](https://github.com/sampittko)

## 🙏 Acknowledgments

- SwiftUI
- Firebase iOS SDK
- Apple Developer Documentation
