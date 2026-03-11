# 📰 Flutter TDD Clean Architecture: News App

![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)
![Dart Version](https://img.shields.io/badge/Dart-3.x-blue.svg)
![Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen.svg)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-orange.svg)

A production-grade Flutter application demonstrating strict **Test-Driven Development (TDD)** and **Feature-First Clean Architecture**. This project serves as a practical implementation of scalable mobile engineering principles, designed to be highly decoupled, easily testable, and maintainable in a team environment.

---

## 🏗️ Architecture Overview

This application strictly adheres to **Feature-First Clean Architecture**. 



By dividing the application into independent features and layering the responsibilities within those features, the codebase achieves:
* **Separation of Concerns:** UI code knows nothing about business rules or data fetching.
* **Testability:** Business logic (Domain) is written in pure Dart and can be tested completely independently of the Flutter framework.
* **Scalability:** New features can be added without modifying existing code, minimizing merge conflicts in team environments.

### The Three Layers
1. **Domain Layer:** The innermost layer. Contains pure business logic, Entities, Use Cases, and Repository Interfaces. Depends on nothing.
2. **Data Layer:** Implements the repository interfaces. Handles data retrieval (APIs, local databases) and data models.
3. **Presentation Layer:** The outermost layer. Contains the UI (Widgets/Pages) and State Management (Bloc), interacting only with the Domain layer's Use Cases.

---

## 🛠️ Tech Stack & Libraries

* **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc)
* **Networking:** [dio](https://pub.dev/packages/dio)
* **Dependency Injection:** [get_it](https://pub.dev/packages/get_it)
* **Routing:** [go_router](https://pub.dev/packages/go_router)
* **Functional Programming:** [fpdart](https://pub.dev/packages/fpdart) (for robust error handling using `Either`)
* **Testing:** `flutter_test`, [mocktail](https://pub.dev/packages/mocktail), [bloc_test](https://pub.dev/packages/bloc_test)

---

## 🧪 Testing Strategy (Strict TDD)

This project was built using a strict Red-Green-Refactor TDD approach. Tests were written *before* the implementation code for every architectural layer:

1. **Domain Tests:** Verifying use case logic and functional return types (`Right`/`Left`).
2. **Data Tests:** Mocking network responses and verifying JSON serialization/deserialization.
3. **Presentation Tests:** Verifying Bloc state emissions and UI widget rendering.

---

## 📂 Project Structure

```text
lib/
 ├── core/
 │    ├── errors/          # Global failure classes and exceptions
 │    ├── network/         # Dio client setup and interceptors
 │    ├── routing/         # GoRouter configuration
 │    ├── theme/           # App colors, typography, and styles
 │    └── utils/           # Shared formatters and constants
 ├── features/
 │    └── news/
 │         ├── domain/     # Entities, Use Cases, Repository Interfaces
 │         ├── data/       # Models, RemoteDataSource, Repository Impl
 │         └── presentation/ # Blocs, Pages, and feature-specific Widgets
 ├── service_locator.dart  # Dependency injection setup (GetIt)
 └── main.dart             # Application entry point

```

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK (`>=3.0.0`)
* Dart SDK (`>=3.0.0`)

### Installation

1. Clone the repository:
```bash
git clone [https://github.com/tomp6114/flutter-tdd-clean-arch.git](https://github.com/tomp6114/flutter-tdd-clean-arch.git)

```


2. Navigate into the directory:
```bash
cd flutter-tdd-clean-arch

```


3. Install dependencies:
```bash
flutter pub get

```


4. Run the test suite to ensure everything is passing:
```bash
flutter test

```


5. Run the application:
```bash
flutter run

```



---

## 👨‍💻 Author

**Tom P Varghese**

* Mobile Application Engineer (Android & iOS)
* LinkedIn: [linkedin.com/in/tom-p-varghese](https://www.google.com/search?q=https://linkedin.com/in/tom-p-varghese)
* GitHub: [github.com/tomp6114](https://www.google.com/search?q=https://github.com/tomp6114)

