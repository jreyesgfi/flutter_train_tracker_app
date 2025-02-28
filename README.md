# gymini

Your Training Tracker.

## Project Structure
lib/
├── bindings/
│   └── data/
│       ├── repositories/
│       │   ├── training_repository.dart
│       │   ├── exercise_repository.dart
│       │   └── ... (other repositories)
│       ├── services/
│       │   ├── training_service.dart
│       │   ├── exercise_service.dart
│       │   └── ... (other services)
│       └── models/
│           ├── training_model.dart
│           ├── exercise_model.dart
│           └── ... (other data models)
│
├── features/
│   ├── create_training/
│   │   ├── create_training_controller.dart
│   │   ├── create_training_view.dart
│   │   └── create_training_bindings.dart
│   ├── save_results/
│   │   ├── save_results_controller.dart
│   │   ├── save_results_view.dart
│   │   └── save_results_bindings.dart
│   ├── charts/
│   │   ├── charts_controller.dart
│   │   ├── charts_view.dart
│   │   └── charts_bindings.dart
│   └── settings/
│       ├── settings_controller.dart
│       ├── settings_view.dart
│       └── settings_bindings.dart
│
├── localization/
│   ├── en.json
│   ├── es.json
│   └── ... (other locales)
│
├── common/
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── custom_card.dart
│   │   └── ... (other shared widgets)
│   └── ... (maybe other shared UI components, e.g. layout helpers)
│
└── utils/
    ├── constants/
    │   ├── colors.dart
    │   ├── enums.dart
    │   ├── image_strings.dart
    │   ├── texts.dart
    │   ├── sizes.dart
    │   └── api_constants.dart
    ├── device/
    │   └── device_utils.dart
    ├── formatters/
    │   └── date_formatter.dart
    ├── helpers/
    │   └── math_helper.dart
    ├── http/
    │   └── http_client.dart
    ├── local_storage/
    │   └── local_storage_helper.dart
    ├── logging/
    │   └── logger.dart
    ├── theme/
    │   ├── app_theme.dart
    │   └── theme_extensions.dart
    └── validators/
        └── input_validator.dart

