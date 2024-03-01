import 'package:flutter/material.dart';

class CustomDropdownFormField extends FormField<String> {
  CustomDropdownFormField({
    Key? key,
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
                // The context from the builder can be used here
                _showCustomDropdown(state.context, items, state);
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

  // Moved the _showCustomDropdown function outside the constructor
  static void _showCustomDropdown(
    BuildContext context,
    List<DropdownMenuItem<String>> items,
    FormFieldState<String> state,
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
                state.didChange(item.value);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }
}
