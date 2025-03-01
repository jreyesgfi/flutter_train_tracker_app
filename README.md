# gymini

Your Training Tracker.

## Project Structure
lib/
├── bindings/
├── data/
│   ├── repositories/
│   │   ├── training_repository.dart
│   │   ├── exercise_repository.dart
│   │   └── ... (other repositories)
│   ├── services/
│   │   ├── training_service.dart
│   │   ├── exercise_service.dart
│   │   └── ... (other services)
│   └── models/
│       ├── training_model.dart
│       ├── exercise_model.dart
│       └── ... (other data models)
│
├── common/
│   ├── shared_data/
│   │   └── session_stream_provider.dart    // Global shared stream provider
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_card.dart
│       ├── animation/
│       │   └── entering_animation.dart
│       └── ... (other shared widgets)
│
├── features/
│   ├── create_training/
│   │   ├── presentation/
│   │   │   ├── create_training_view.dart
│   │   │   └── widgets/   // feature-specific widgets
│   │   └── provider/
│   │       ├── create_training_notifier.dart
│   │       ├── create_training_state.dart
│   │       └── create_training_provider.dart
│   │
│   ├── process_training/
│   │   ├── presentation/
│   │   │   ├── process_training_view.dart
│   │   │   └── widgets/   // feature-specific widgets
│   │   └── provider/
│   │       ├── process_training_notifier.dart
│   │       ├── process_training_state.dart
│   │       └── process_training_provider.dart
│   │
│   ├── save_results/
│   │   ├── presentation/
│   │   │   ├── save_results_view.dart
│   │   │   └── widgets/
│   │   └── provider/
│   │       ├── save_results_notifier.dart
│   │       ├── save_results_state.dart
│   │       └── save_results_provider.dart
│   │
│   ├── charts/
│   │   ├── presentation/
│   │   │   ├── charts_view.dart
│   │   │   └── widgets/
│   │   └── provider/
│   │       ├── charts_notifier.dart
│   │       ├── charts_state.dart
│   │       └── charts_provider.dart
│   │
│   └── settings/
│       ├── presentation/
│       │   ├── settings_view.dart
│       │   └── widgets/
│       └── provider/
│           ├── settings_notifier.dart
│           ├── settings_state.dart
│           └── settings_provider.dart
│
├── localization/
│   ├── en.json
│   ├── es.json
│   └── ... (other locales)
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
