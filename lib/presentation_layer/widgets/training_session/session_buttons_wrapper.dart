import 'package:flutter/material.dart';
import 'package:flutter_application_test1/presentation_layer/providers/training_screen_provider.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/training_session/session_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class SessionButtonsWrapper extends ConsumerStatefulWidget {
  final int currentStage;
  final Function(int) onButtonClicked; // Accepts an index

  const SessionButtonsWrapper({
    Key? key,
    required this.currentStage,
    required this.onButtonClicked,
  }) : super(key: key);

  @override
  ConsumerState<SessionButtonsWrapper> createState() => _SessionButtonsWrapperState();
}

class _SessionButtonsWrapperState extends ConsumerState<SessionButtonsWrapper> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _centerCurrentStage());
  }

  void _centerCurrentStage() {
    if (_scrollController.hasClients) {
      final buttonWidth = MediaQuery.of(context).size.width / 3; // Adjust based on your button widths
      final offset = (widget.currentStage * buttonWidth) - (MediaQuery.of(context).size.width / 2) + (buttonWidth / 2);
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberOfButtons = 10;
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(numberOfButtons, (index) { // Assume you have 8 buttons
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add horizontal space between buttons
            child: SessionButton(
              onTap: () => widget.onButtonClicked(index),
              stage: index - widget.currentStage,
              color: (index % 2 == 1) ? theme.primaryColor : theme.primaryColorDark,
              label: 
                (index == numberOfButtons-1) ? "¡Conseguido!": 
                (index == 0) ? "¿Comenzamos?" :
                index-widget.currentStage!=0 ? null :
                (index % 2 == 1) ? "¡Entrena!" : "Descansa",
              icon:
                (index % 2 == 1) ? Icons.arrow_forward : Icons.double_arrow
            ),
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
