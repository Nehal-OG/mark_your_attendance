# Mark Your Attendance

A Flutter application for managing employee attendance using GetX state management and clean architecture.

Step to create dynamic Icons
<!-- Run below command to generate icon for web and other mode -->
- flutter pub run flutter_launcher_icons

## Features

- User Authentication (Login/Register)
- Mark Attendance (Check-in/Check-out)
- View Attendance History
- Calendar View of Attendance
- Profile Management

## Project Structure

```
lib/
├── core/
│   ├── bindings/
│   ├── routes/
│   └── utils/
└── features/
    ├── auth/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── attendance/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── calendar/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── more/
        ├── data/
        ├── domain/
        └── presentation/
```

## Getting Started

### Prerequisites

- Flutter 3.27.2 or higher
- Dart SDK 3.6.1 or higher

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/mark_your_attendance.git
```

2. Navigate to the project directory:
```bash
cd mark_your_attendance
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Architecture

This project follows clean architecture principles and is organized using a feature-first approach. Each feature has its own set of layers:

- **Data**: Models, repositories implementations, and data sources
- **Domain**: Repository interfaces, entities, and use cases
- **Presentation**: Controllers, views, and widgets

## State Management

The project uses GetX for state management, routing, and dependency injection. Key features include:

- Reactive state management with `Rx` variables
- Route management with `GetPage`
- Dependency injection with `Get.put()` and `Get.find()`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
