import 'package:flutter/material.dart';

class CustomDropdownFormField extends FormField<String> {
  final void Function(String?)? onChanged;

  CustomDropdownFormField({
    Key? key,
    this.onChanged,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    String? initialValue,
    required List<DropdownMenuItem<String>> items,
    required String hintText,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<String> state) {
            return ElevatedButton(
              onPressed: () {
                _showCustomDropdown(state.context, items, state, onChanged);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(state.value ?? hintText),
                  Icon(Icons.arrow_drop_down),
                ],
              ),
            );
          },
        );

  // Update the function signature to accept onChanged
  static void _showCustomDropdown(
    BuildContext context,
    List<DropdownMenuItem<String>> items,
    FormFieldState<String> state,
    void Function(String?)? onChanged, // Accept onChanged callback here
  ) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.zero,
          children: items.map((DropdownMenuItem<String> item) {
            return ListTile(
              title: Text(item.value!),
              onTap: () {
                state.didChange(item.value); // Update the form field's state
                if (onChanged != null) {
                  onChanged(item.value); // Invoke onChanged callback if it's not null
                }
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
