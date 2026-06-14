# Chatify 💬

Chatify is a real-time chat application built with Flutter and Firebase, following Clean Architecture principles to ensure scalability, maintainability, and clean separation of concerns.

## ✨ Features

* User Authentication
* Real-Time Messaging
* User Search
* Chat Management
* Responsive UI
* Firebase Authentication
* Cloud Firestore Integration
* State Management with Bloc/Cubit
* Dependency Injection using GetIt
* Clean Architecture Implementation

## 🏗️ Architecture

The project follows Clean Architecture and is divided into three main layers:

### Presentation Layer

* UI Screens
* Widgets
* Bloc/Cubit State Management

### Domain Layer

* Entities
* Repositories Contracts
* Use Cases

### Data Layer

* Repository Implementations
* Data Sources
* Models
* Firebase Services

## 📂 Project Structure

```text
lib/
├── core/
├── common/
├── data/
│── domain/
│── presentation/
│── services/
└── main.dart
└── service_locator.dart
```

## 🛠️ Technologies

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Flutter Bloc
* GetIt
* Clean Architecture

## 🚀 Getting Started

```bash
git clone <repository-url>
cd chatify
flutter pub get
flutter run
```

## 🔐 Configuration

Some configuration files such as `app_urls.dart` are excluded from version control and should be created locally before running the application.

## 📚 Learning Goals

This project was built to practice:

* Clean Architecture
* Flutter Bloc
* Firebase Integration
* Dependency Injection
* Scalable Flutter Project Structure

## 📄 License

This project is intended for educational and portfolio purposes.
