import 'package:flutter/material.dart';
import 'package:gymini/features/process_training/entities/session_tile.dart';
import 'package:gymini/presentation_layer/widgets/common/inputs/roulette_numeric_input.dart';

class SessionForm extends StatefulWidget {
  final SessionTile initialData;
  final ValueChanged<SessionFormTile>? onChanged; // New callback

  const SessionForm({
    super.key,
    required this.initialData,
    this.onChanged,
  });

  @override
  SessionFormState createState() => SessionFormState();
}

class SessionFormState extends State<SessionForm> {
  late TextEditingController _maxWeightController;
  late TextEditingController _minWeightController;
  late TextEditingController _maxRepsController;
  late TextEditingController _minRepsController;

  @override
  void initState() {
    super.initState();
    _maxWeightController = TextEditingController(
        text: widget.initialData.maxWeight.toString());
    _minWeightController = TextEditingController(
        text: widget.initialData.minWeight.toString());
    _maxRepsController =
        TextEditingController(text: widget.initialData.maxReps.toString());
    _minRepsController =
        TextEditingController(text: widget.initialData.minReps.toString());

    // Add listeners to call the onChanged callback whenever a field is updated.
    _maxWeightController.addListener(_onFormChanged);
    _minWeightController.addListener(_onFormChanged);
    _maxRepsController.addListener(_onFormChanged);
    _minRepsController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _maxWeightController.removeListener(_onFormChanged);
    _minWeightController.removeListener(_onFormChanged);
    _maxRepsController.removeListener(_onFormChanged);
    _minRepsController.removeListener(_onFormChanged);
    _maxWeightController.dispose();
    _minWeightController.dispose();
    _maxRepsController.dispose();
    _minRepsController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    // Call the callback if it exists.
    if (widget.onChanged != null) {
      try {
        widget.onChanged!(getCurrentFormData());
      } catch (e) {
        // Optionally handle parse errors.
      }
    }
  }

  SessionFormTile getCurrentFormData() {
    return SessionFormTile(
      maxWeight: double.parse(_maxWeightController.text),
      minWeight: double.parse(_minWeightController.text),
      maxReps: int.parse(_maxRepsController.text),
      minReps: int.parse(_minRepsController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NumericRoulettePicker(
          controller: _maxWeightController,
          value: widget.initialData.maxWeight.toDouble(),
          label: "Max Weight",
          allowDecimal: true,
          minValue: 0,
          maxValue: 300,
          step: 0.5,
          vertical: false,
        ),
        const SizedBox(height: 8),
        NumericRoulettePicker(
          controller: _minWeightController,
          value: widget.initialData.minWeight.toDouble(),
          label: "Min Weight",
          allowDecimal: true,
          minValue: 0,
          maxValue: 300,
          step: 0.5,
        ),
        const SizedBox(height: 8),
        NumericRoulettePicker(
          controller: _maxRepsController,
          value: widget.initialData.maxReps.toDouble(),
          label: "Max Reps",
          allowDecimal: false,
          minValue: 0,
          maxValue: 100,
          step: 1,
        ),
        const SizedBox(height: 8),
        NumericRoulettePicker(
          controller: _minRepsController,
          value: widget.initialData.minReps.toDouble(),
          label: "Min Reps",
          allowDecimal: false,
          minValue: 0,
          maxValue: 100,
          step: 1,
        ),
      ],
    );
  }
}
