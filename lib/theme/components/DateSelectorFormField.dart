import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DateSelectionFormField extends FormField<DateTime> {
  final Function(DateTime) onDatePicked; // Callback for when a date is picked

  DateSelectionFormField({
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialDate,
    required BuildContext context,
    required this.onDatePicked, // Require the callback in the constructor
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialDate,
          builder: (FormFieldState<DateTime> state) {
            return ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: state.value ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                );
                if (picked != null) {
                  state.didChange(picked); // Updates the form field's state
                  onDatePicked(picked); // Updates the parent widget's state
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Rounded corners
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8),
                  Text(
                    state.value == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(state.value!),
                  ),
                ],
              ),
            );
          },
        );
}
