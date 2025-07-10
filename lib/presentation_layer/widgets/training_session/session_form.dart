import 'package:flutter/material.dart';
import 'package:gymini/features/process_training/entities/session_tile.dart';
import 'package:gymini/presentation_layer/widgets/common/inputs/numeric_roulette_input.dart';

/// Four numeric pickers (max/min weight & reps) + public `getCurrentFormData()`.
class SessionForm extends StatefulWidget {
  final SessionTile initialData;
  final ValueChanged<SessionFormTile>? onChanged;

  const SessionForm({
    super.key,
    required this.initialData,
    this.onChanged,
  });

  @override
  State<SessionForm> createState() => SessionFormState();
}

class SessionFormState extends State<SessionForm> {
  late final TextEditingController _maxWeightCtl;
  late final TextEditingController _minWeightCtl;
  late final TextEditingController _maxRepsCtl;
  late final TextEditingController _minRepsCtl;

  @override
  void initState() {
    super.initState();
    _maxWeightCtl =
        TextEditingController(text: widget.initialData.maxWeight.toString());
    _minWeightCtl =
        TextEditingController(text: widget.initialData.minWeight.toString());
    _maxRepsCtl =
        TextEditingController(text: widget.initialData.maxReps.toString());
    _minRepsCtl =
        TextEditingController(text: widget.initialData.minReps.toString());
  }

  @override
  void dispose() {
    _maxWeightCtl.dispose();
    _minWeightCtl.dispose();
    _maxRepsCtl.dispose();
    _minRepsCtl.dispose();
    super.dispose();
  }

  /// ------------  PUBLIC API  ------------
  /// Your `ProcessTrainingView` calls this via a `GlobalKey`.
  SessionFormTile getCurrentFormData() => _collectFormData();
  /// --------------------------------------

  SessionFormTile _collectFormData() => SessionFormTile(
        maxWeight: double.parse(_maxWeightCtl.text),
        minWeight: double.parse(_minWeightCtl.text),
        maxReps: int.parse(_maxRepsCtl.text),
        minReps: int.parse(_minRepsCtl.text),
      );

  void _notifyParent() => widget.onChanged?.call(_collectFormData());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NumericRoulettePicker(
          controller: _maxWeightCtl,
          value: widget.initialData.maxWeight.toDouble(),
          label: 'Max Weight',
          allowDecimal: true,
          minValue: 0,
          maxValue: 300,
          step: 0.5,
          onSubmitted: _notifyParent,
        ),
        const SizedBox(height: 8),
        NumericRoulettePicker(
          controller: _minWeightCtl,
          value: widget.initialData.minWeight.toDouble(),
          label: 'Min Weight',
          allowDecimal: true,
          minValue: 0,
          maxValue: 300,
          step: 0.5,
          onSubmitted: _notifyParent,
        ),
        const SizedBox(height: 8),
        NumericRoulettePicker(
          controller: _maxRepsCtl,
          value: widget.initialData.maxReps.toDouble(),
          label: 'Max Reps',
          allowDecimal: false,
          minValue: 0,
          maxValue: 100,
          step: 1,
          onSubmitted: _notifyParent,
        ),
        const SizedBox(height: 8),
        NumericRoulettePicker(
          controller: _minRepsCtl,
          value: widget.initialData.minReps.toDouble(),
          label: 'Min Reps',
          allowDecimal: false,
          minValue: 0,
          maxValue: 100,
          step: 1,
          onSubmitted: _notifyParent,
        ),
      ],
    );
  }
}
