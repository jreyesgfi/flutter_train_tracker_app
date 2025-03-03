import 'package:flutter/material.dart';
import 'package:gymini/features/process_training/entities/session_tile.dart';
import 'package:gymini/presentation_layer/widgets/common/inputs/roulette_numeric_input.dart';


class SessionForm extends StatefulWidget {
  final SessionTile initialData;
  // final Function(SessionInfoSchema) onResultsChanged;

  const SessionForm({
    super.key,
    required this.initialData,
    // required this.onResultsChanged,
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
    _maxWeightController = TextEditingController(text: widget.initialData.maxWeight.toString());
    _minWeightController = TextEditingController(text: widget.initialData.minWeight.toString());
    _maxRepsController = TextEditingController(text: widget.initialData.maxReps.toString());
    _minRepsController = TextEditingController(text: widget.initialData.minReps.toString());
  }

  @override
  void dispose() {
    _maxWeightController.dispose();
    _minWeightController.dispose();
    _maxRepsController.dispose();
    _minRepsController.dispose();
    super.dispose();
  }

  SessionFormTile getCurrentFormData() {
    return SessionFormTile(
      maxWeight: double.parse(_maxWeightController.text),
      minWeight: double.parse(_minWeightController.text),
      maxReps: int.parse(_maxRepsController.text),
      minReps: int.parse(_minRepsController.text),
    );
  }

  // void _handleFormSubmit() {
  //   final SessionInfoSchema results = SessionInfoSchema(
  //     maxWeight: double.parse(_maxWeightController.text),
  //     minWeight: double.parse(_minWeightController.text),
  //     maxReps: int.parse(_maxRepsController.text),
  //     minReps: int.parse(_minRepsController.text),

  //     exerciseName:widget.initialData.exerciseName,
  //     muscleGroup: widget.initialData.muscleGroup,
  //     timeSinceLastSession: widget.initialData.timeSinceLastSession
  //   );
  //   widget.onResultsChanged(results);
  // }

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
        ),
        NumericRoulettePicker(
          controller: _minWeightController,
          value: widget.initialData.minWeight.toDouble(),
          label: "Min Weight",
          allowDecimal: true,
          minValue: 0,
          maxValue: 300,
          step: 0.5,
        ),
        NumericRoulettePicker(
          controller: _maxRepsController,
          value: widget.initialData.maxReps.toDouble(),
          label: "Max Reps",
          allowDecimal: false,
          minValue: 0,
          maxValue: 100,
          step: 1,
        ),
        NumericRoulettePicker(
          controller: _minRepsController,
          value: widget.initialData.minReps.toDouble(),
          label: "Min Reps",
          allowDecimal: false,
          minValue: 0,
          maxValue: 100,
          step: 1,
        ),
        // ElevatedButton(
        //   onPressed: _handleFormSubmit,
        //   child: Text('Submit'),
        // ),
      ],
    );
  }
}
