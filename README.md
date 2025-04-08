# gymini

Your Training Tracker.

## Project Structure
lib/
├── app/
│   ├── router/
│   │   ├── router.dart             
│   │   ├── router_provider.dart    
│   │   └── go_router_refresh_stream.dart 
│   └── main.dart                  
│
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
├── common/
│   ├── shared_data/
│   │   ├── session_stream_provider.dart   // or global_shared_streams.dart, etc.
│   │   └── current_session_provider.dart  // if you want a separate provider for session
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_card.dart
│       ├── animation/
│       │   └── entering_animation.dart
│       └── ... (other shared widgets)
│
├── features/
│   ├── select_training/
│   │   ├── adapter/
│   │   │   └── training_data_adapter.dart
│   │   ├── provider/
│   │   │   ├── select_training_notifier.dart
│   │   │   ├── select_training_state.dart
│   │   │   └── training_screen_provider.dart
│   │   └── ui/
│   │       ├── training_selection_view.dart
│   │       └── widgets/
│   │           └── ... (feature-specific widgets)
│
│   ├── process_training/
│   │   ├── adapter/
│   │   │   └── process_training_data_adapter.dart
│   │   ├── provider/
│   │   │   ├── process_training_notifier.dart
│   │   │   ├── process_training_state.dart
│   │   │   └── process_training_provider.dart
│   │   └── ui/
│   │       ├── process_training_view.dart
│   │       └── widgets/
│   │           └── ... (feature-specific widgets)
│   ├── report/
│   │   ├── adapter/
│   │   │   └── report_data_adapter.dart
│   │   ├── provider/
│   │   │   ├── report_state.dart
│   │   │   ├── report_notifier.dart
│   │   │   └── report_provider.dart
│   │   └── ui/
│   │       ├── report_screen.dart
│   │       └── widgets/
│   │           ├── training_count_bar_chart.dart
│   │           ├── max_min_line_chart.dart
│   │           └── other_report_widgets.dart
│   └── settings/
│       ├── adapter/
│       │   └── settings_data_adapter.dart
│       ├── provider/
│       │   ├── settings_notifier.dart
│       │   ├── settings_state.dart
│       │   └── settings_provider.dart
│       └── ui/
│           ├── settings_view.dart
│           └── widgets/
│               └── ...
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


## Navigation
### Specific inside feature
In the case whether to navigate to select_training or process_training layers, the decission is taken in the router depending on the value of the selectedExercise present in the global exercise stream.