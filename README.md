# otlob_App 🍔☕

A Flutter mobile application that brings **cafés and restaurants together in one place**. Users can explore food and drinks, browse categories and brands, view restaurant and product details, and manage their cart and orders through a clean, coral-themed interface.

## 📱 Features

- **Authentication:** Sign-up and login screens.
- **Home Screen:** Browse featured items, categories, brands, and popular products.
- **Explore:** Discover restaurants, café products, and food options.
- **Filtering:** Browse products by category or brand.
- **Restaurant Details:** View restaurant information and menu items.
- **Food Details:** View product information and available options.
- **Shopping Cart:** Review selected products and manage cart items.
- **Orders:** Access the orders screen.
- **Profile:** Access profile-related options.
- **Splash Screen:** A branded launch screen with coral and cream styling.
- **Responsive UI:** Mobile-friendly layouts built with Flutter.

## 🛠️ Tech Stack

- Flutter
- Dart
- Material Design
- Android Studio

## 🎨 Design System

| Element | Color |
|---|---|
| Primary Coral | `#FF654F` |
| Dark Navy | `#191B24` |
| Warm Cream | `#FFF8F4` |
| Soft Peach | `#FFE1D7` |

The design uses rounded cards, soft backgrounds, food photography, and coral accents to create a modern café and restaurant ordering experience.

## 📂 Project Structure

```text
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── splash_screen.dart
│   ├── restaurant_explore_screen.dart
│   ├── restaurant_details_screen.dart
│   ├── food_details_screen.dart
│   ├── cart_screen.dart
│   └── ...
└── widgets/
    ├── bottom_nav_bar.dart
    └── ...
assets/
└── images/
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or another Flutter-compatible IDE
- Android emulator or physical Android device

### Installation

1. Clone the repository:

   ```bash
   git clone <YOUR_REPOSITORY_URL>
   ```

2. Navigate to the project directory:

   ```bash
   cd otlob_App
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Check available devices:

   ```bash
   flutter devices
   ```

5. Run the application:

   ```bash
   flutter run
   ```

## 🖼️ Assets

Place local images inside `assets/images/` and register them in `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

Example:

```dart
Image.asset('assets/images/example.png')
```

Make sure the asset paths match the actual filenames in your project.

## 🧪 Quality Checks

Run Flutter static analysis:

```bash
flutter analyze
```

Run automated tests:

```bash
flutter test
```

## 🔮 Future Improvements

- Integrate authentication with a backend service.
- Load restaurants and menu items from a database.
- Persist cart items between app sessions.
- Implement order placement and order-status tracking.
- Add automated unit and widget tests.
- Include application screenshots and a demo video.

## 👨‍💻 Author

**Project:** otlob_App

**Description:** A café and restaurant ordering application built with Flutter.

Add your name, GitHub profile, and repository link here before publishing the project.

## 📄 License

Add a license to this repository if you intend to distribute or open-source the project.