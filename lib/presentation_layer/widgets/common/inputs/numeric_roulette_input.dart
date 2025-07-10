import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';

/// Scrollable “roulette” numeric picker with direct text entry.
///
/// •  Swiping uses the **default** `PageScrollPhysics` → natural, smooth feel.  
/// •  Typing a value jumps instantly (no glide).  
/// •  `onSubmitted` callback fires only when the user presses the keyboard
///   “done” / “enter” key.
class NumericRoulettePicker extends StatefulWidget {
  final TextEditingController controller;
  final double value;
  final bool allowDecimal;
  final double minValue;
  final double maxValue;
  final double step;
  final String label;
  final bool vertical;
  final VoidCallback? onSubmitted;

  const NumericRoulettePicker({
    super.key,
    required this.controller,
    this.value = 0,
    this.allowDecimal = false,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.step = 1.0,
    this.label = '',
    this.vertical = false,
    this.onSubmitted,
  });

  @override
  State<NumericRoulettePicker> createState() => _NumericRoulettePickerState();
}

class _NumericRoulettePickerState extends State<NumericRoulettePicker> {
  late final PageController _pageController;
  late int _currentPage;
  late final double _step;

  Axis get _axis => widget.vertical ? Axis.vertical : Axis.horizontal;

  @override
  void initState() {
    super.initState();
    _step = widget.allowDecimal ? widget.step / 2 : widget.step;
    final initialPage =
        ((widget.value - widget.minValue) / _step).clamp(0, double.infinity);
    _currentPage = initialPage.toInt();

    _pageController = PageController(
      viewportFraction: 0.25,
      initialPage: _currentPage,
    );

    widget.controller.text =
        widget.value.toStringAsFixed(widget.allowDecimal ? 1 : 0);
  }

  @override
  void didUpdateWidget(covariant NumericRoulettePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) _jumpToExternalValue();
  }

  // Keep wheel & text in sync if the parent forces a new value.
  void _jumpToExternalValue() {
    final newPage = ((widget.value - widget.minValue) / _step).round();
    _pageController.jumpToPage(newPage);
    widget.controller.text =
        widget.value.toStringAsFixed(widget.allowDecimal ? 1 : 0);
    _currentPage = newPage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Default physics → smooth drag feel.
    const physics = PageScrollPhysics();

    final roulette = PageView.builder(
      scrollDirection: _axis,
      controller: _pageController,
      physics: physics,
      onPageChanged: (index) {
        final newValue =
            (index * _step + widget.minValue).clamp(widget.minValue, widget.maxValue);

        setState(() {
          _currentPage = index;
          widget.controller.text =
              newValue.toStringAsFixed(widget.allowDecimal ? 1 : 0);
        });
      },
      itemBuilder: (_, index) {
        final pageValue = index * _step + widget.minValue;
        final display = pageValue.toStringAsFixed(widget.allowDecimal ? 1 : 0);
        final isCurrent = index == _currentPage;

        return Center(
          child: isCurrent
              ? _EditableNumber(
                  controller: widget.controller,
                  allowDecimal: widget.allowDecimal,
                  vertical: widget.vertical,
                  onSubmitted: (raw) {
                    final typed = double.tryParse(raw);
                    if (typed == null) return;

                    final normalised =
                        widget.allowDecimal ? typed : typed.roundToDouble();
                    final pageIndex =
                        ((normalised - widget.minValue) / _step).round();

                    // Instant jump so the wheel doesn’t glide when typing.
                    _pageController.jumpToPage(pageIndex);

                    setState(() {
                      _currentPage = pageIndex;
                      widget.controller.text = normalised
                          .toStringAsFixed(widget.allowDecimal ? 1 : 0);
                    });

                    widget.onSubmitted?.call();
                  },
                )
              : Text(
                  display,
                  style: TextStyle(
                    fontSize: widget.vertical ? 20 : 16,
                    color: AppColors.greyColor,
                  ),
                ),
        );
      },
    );

    final children = widget.vertical
        ? [Expanded(child: roulette), _Label(text: widget.label)]
        : [_Label(text: widget.label), Expanded(child: roulette)];

    return SizedBox(
      height: widget.vertical ? 200 : 80,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.vertical
            ? Row(children: children)
            : Column(children: children),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────

class _EditableNumber extends StatelessWidget {
  const _EditableNumber({
    required this.controller,
    required this.allowDecimal,
    required this.vertical,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final bool allowDecimal;
  final bool vertical;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: vertical ? 120 : 80,
      padding: vertical ? const EdgeInsets.symmetric(vertical: 4) : null,
      decoration: BoxDecoration(
        border: vertical
            ? Border(left: BorderSide(color: AppColors.greyColor, width: 2))
            : Border(bottom: BorderSide(color: AppColors.greyColor, width: 2)),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
        style: TextStyle(
          fontSize: vertical ? 36 : 28,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.greyColor),
          ),
        ),
      );
}
