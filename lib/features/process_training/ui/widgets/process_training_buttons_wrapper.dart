import 'package:flutter/material.dart';
import 'package:gymini/presentation_layer/widgets/common/modals_snackbars/custom_modal.dart';
import 'package:gymini/presentation_layer/widgets/common/modals_snackbars/custom_snackbar.dart';
import 'package:gymini/common/widgets/buttons/session_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionButtonsWrapper extends ConsumerStatefulWidget {
  final int currentStage;
  final Function(int) onButtonClicked;
  final void Function()? cancelTraining;

  const SessionButtonsWrapper({
    super.key,
    required this.currentStage,
    required this.onButtonClicked,
    this.cancelTraining,
  });

  @override
  ConsumerState<SessionButtonsWrapper> createState() =>
      _SessionButtonsWrapperState();
}

class _SessionButtonsWrapperState extends ConsumerState<SessionButtonsWrapper> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _centerCurrentStage());
  }

  void _centerCurrentStage() {
    if (_scrollController.hasClients) {
      final buttonWidth = MediaQuery.of(context).size.width / 3;
      final offset = (widget.currentStage * buttonWidth) -
          (MediaQuery.of(context).size.width / 2) +
          (buttonWidth / 2);
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
    const numberOfRounds = 10;
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cancel Training Button with long press for "takeBack"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SessionButton(
              onTap: (){
                if (widget.currentStage == 0){
                  showWarningSnackbar(context: context, message: "Si desea finalizar el entrenamiento mantenga presionado el botón.");
                } else{ 
                  widget.onButtonClicked(widget.currentStage - 1);
                }   
              },
              // Long press decreases stage by one ("takeBack")
              onLongPressTakeBack: () => showCustomDialog(
                  context: context,
                  message: '¿Qué deseas hacer con tu entrenamiento?',
                  actionLabel: 'Finalizar',
                  dismissLabel: 'Seguir entrenando',
                  action: widget.cancelTraining),
                  
              stage: 1,
              color: theme.primaryColorDark,
              icon: (widget.currentStage == 0)
                  ? Icons.stop
                  : Icons.arrow_back_sharp,
            ),
          ),

          // Current Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SessionButton(
              onTap: () => widget.onButtonClicked(widget.currentStage + 1),
              stage: 0,
              color: (widget.currentStage % 2 == 1)
                  ? theme.primaryColor
                  : theme.primaryColorDark,
              label: (widget.currentStage == numberOfRounds - 1)
                  ? "¡Conseguido!"
                  : (widget.currentStage == 0)
                      ? "¿Comenzamos?"
                      : (widget.currentStage % 2 == 1)
                          ? "Entrenando"
                          : "Descansando",
            ),
          ),

          // Next Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SessionButton(
              onTap: () => widget.onButtonClicked(widget.currentStage + 1),
              stage: 1,
              color: theme.primaryColor,
              icon: (widget.currentStage % 2 == 0)
                  ? Icons.arrow_forward_ios
                  : Icons.check_rounded,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
