import 'package:flutter/material.dart';
import 'package:flutter_application_test1/models/exercise_results.dart';
import 'package:flutter_application_test1/models/session_info.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/roulette_numeric_input.dart';


class SessionForm extends StatefulWidget {
  final SessionInfoSchema initialData;
  final Function(SessionInfoSchema) onResultsChanged;

  const SessionForm({
    Key? key,
    required this.initialData,
    required this.onResultsChanged,
  }) : super(key: key);

  @override
  _SessionFormState createState() => _SessionFormState();
}

class _SessionFormState extends State<SessionForm> {
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

  void _handleFormSubmit() {
    final SessionInfoSchema results = SessionInfoSchema(
      maxWeight: double.parse(_maxWeightController.text),
      minWeight: double.parse(_minWeightController.text),
      maxReps: int.parse(_maxRepsController.text),
      minReps: int.parse(_minRepsController.text),

      exerciseName:widget.initialData.exerciseName,
      muscleGroup: widget.initialData.muscleGroup,
      timeSinceLastSession: widget.initialData.timeSinceLastSession
    );
    widget.onResultsChanged(results);
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
        ElevatedButton(
          onPressed: _handleFormSubmit,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
