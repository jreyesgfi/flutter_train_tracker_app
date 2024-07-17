import 'package:flutter/material.dart';

class CustomDropdownFormField extends FormField<String> {
  final void Function(String?)? onChanged;
  final List<CustomDropdownItem> items;

  CustomDropdownFormField({
    Key? key,
    this.onChanged,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
    String? initialValue,
    required this.items,
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

  static void _showCustomDropdown(
    BuildContext context,
    List<CustomDropdownItem> items,
    FormFieldState<String> state,
    void Function(String?)? onChanged,
  ) {
    // Sort items alphabetically by their value
    items.sort((a, b) => a.value.compareTo(b.value));

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              margin: EdgeInsets.only(left: 32.0, top: 24.0, bottom: 24.0), // Adjusted margin
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).primaryColorDark, width: 4)), // Left border
              ),
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 4.0), // Padding
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: item.value.substring(0, 1), // First letter, larger size
                        style: TextStyle(
                          fontSize: 48, // Larger font size for the first letter
                          color: item.available ? Theme.of(context).primaryColorDark : Colors.grey, // Color based on availability
                        ),
                      ),
                      TextSpan(
                        text: item.value.substring(1), // Rest of the text
                        style: TextStyle(
                          fontSize: 16, // Rest of the text font size
                          color: item.available ? Theme.of(context).primaryColorDark : Colors.grey, // Color based on availability
                          decoration: item.available ? TextDecoration.none : TextDecoration.lineThrough, // Cross out if not available
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: item.available ? () {
                  state.didChange(item.value);
                  if (onChanged != null) {
                    onChanged(item.value);
                  }
                  Navigator.pop(context);
                } : null, // Disable onTap if not available
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 2), // Gap between items
        );
      },
    );
  }
}

class CustomDropdownItem {
  final String value;
  final bool available;

  CustomDropdownItem({required this.value, this.available = true});
}
