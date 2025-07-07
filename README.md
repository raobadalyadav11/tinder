# ConnectSphere - Professional Dating & Social App

A modern, professional dating and social networking application built with Flutter, featuring beautiful UI/UX design and comprehensive functionality.

## ✨ Features

### 🎨 Modern UI/UX Design
- **Professional Color Scheme**: Carefully crafted color palette with primary (#FF4458), secondary (#6C63FF), and accent (#FFB800) colors
- **Dark/Light Theme Support**: Automatic theme switching based on system preferences
- **Smooth Animations**: Staggered animations, transitions, and micro-interactions
- **Custom Components**: Reusable gradient buttons, custom text fields, and modern cards
- **Google Fonts Integration**: Inter font family for professional typography

### 🔥 Core Functionality
- **Swipe-to-Match**: Tinder-like card swiping with smooth animations
- **Real-time Chat**: Modern chat interface with online status indicators
- **User Profiles**: Comprehensive profile management with photo galleries
- **Match System**: Advanced matching algorithm with super-likes
- **Proximity Alerts**: Location-based friend notifications
- **Group Hangouts**: Create and join local events

### 🛡️ Security & Privacy
- **JWT Authentication**: Secure token-based authentication
- **Data Encryption**: AES-256 encryption for sensitive data
- **Privacy Controls**: Granular privacy settings for location and profile visibility
- **Content Moderation**: Automated image and content filtering

## 🏗️ Architecture

### MVC Pattern Implementation
- **Model**: Data layer with MongoDB integration, user management, and API communication
- **View**: Flutter UI components with responsive design and animations
- **Controller**: Business logic, state management, and real-time features

### Tech Stack
- **Frontend**: Flutter 3.x with Dart
- **Backend**: Node.js with Express.js
- **Database**: MongoDB with geospatial queries
- **Real-time**: Socket.IO for chat and notifications
- **Authentication**: JWT with bcrypt password hashing

## 📱 Screens

1. **Splash Screen**: Animated app introduction
2. **Login/Signup**: Professional authentication with social login options
3. **Swipe Screen**: Card-based user discovery with action buttons
4. **Chat List**: Modern messaging interface with new matches section
5. **Profile Screen**: Comprehensive user profile with statistics
6. **Settings**: Privacy controls and app preferences

## 🎨 Design System

### Color Palette
```dart
// Primary Colors
static const Color primaryColor = Color(0xFFFF4458);
static const Color primaryLight = Color(0xFFFF6B7A);

// Secondary Colors
static const Color secondaryColor = Color(0xFF6C63FF);
static const Color accentColor = Color(0xFFFFB800);

// Neutral Colors
static const Color backgroundColor = Color(0xFFFAFAFA);
static const Color textPrimary = Color(0xFF1A1A1A);
```

### Typography
- **Font Family**: Inter (Google Fonts)
- **Weights**: 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)
- **Responsive Sizing**: Scales appropriately across different screen sizes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Node.js (for backend)
- MongoDB

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd connectsphere
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  http: ^1.1.0
  geolocator: ^10.1.0
  flutter_local_notifications: ^16.3.0
  socket_io_client: ^2.0.3
  image_picker: ^1.0.4
  flutter_tindercard: ^0.2.0
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  shimmer: ^3.0.0
  cached_network_image: ^3.3.0
  flutter_staggered_animations: ^1.1.1
```

## 📂 Project Structure

```
lib/
├── core/
│   └── theme/
│       └── app_theme.dart          # App-wide theme configuration
├── screens/
│   ├── auth/
│   │   └── login_screen.dart       # Authentication screens
│   ├── home/
│   │   ├── main_screen.dart        # Main navigation
│   │   └── swipe_screen.dart       # Card swiping interface
│   ├── chat/
│   │   └── chat_list_screen.dart   # Messaging interface
│   ├── profile/
│   │   └── profile_screen.dart     # User profile management
│   └── splash_screen.dart          # App introduction
├── widgets/
│   ├── custom_text_field.dart      # Reusable text input
│   ├── gradient_button.dart        # Custom button component
│   └── user_card.dart             # Swipeable user cards
└── main.dart                       # App entry point
```

## 🎯 Key Features Implementation

### Swipe Cards
- Smooth gesture recognition
- Visual feedback for like/pass/super-like
- Match detection and celebration
- Card stack management

### Real-time Chat
- WebSocket integration
- Message status indicators
- Online presence detection
- Image sharing capabilities

### Profile Management
- Photo upload and management
- Interest tags and bio editing
- Privacy settings
- Statistics dashboard

## 🔧 Customization

### Theme Customization
Modify `lib/core/theme/app_theme.dart` to customize:
- Color schemes
- Typography
- Component styles
- Dark/light theme variations

### Adding New Screens
1. Create screen file in appropriate directory
2. Add route in `main.dart`
3. Implement navigation logic
4. Follow existing design patterns

## 📈 Performance Optimizations

- **Image Caching**: Cached network images for better performance
- **Lazy Loading**: Efficient list rendering with pagination
- **State Management**: Provider pattern for optimal rebuilds
- **Animation Optimization**: 60fps smooth animations
- **Memory Management**: Proper disposal of controllers and streams

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Fonts for typography
- Open source community for packages and inspiration
- Design inspiration from modern dating apps

---

**ConnectSphere** - Where meaningful connections begin. 💕
