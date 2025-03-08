import 'package:flutter/material.dart';
import 'package:gymini/common_layer/theme/app_colors.dart';

class NumericRoulettePicker extends StatefulWidget {
  final TextEditingController controller;
  final bool allowDecimal;
  final double minValue;
  final double maxValue;
  final double step;
  final String label;
  final double value;
  final bool vertical;

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
  });

  @override
  NumericRoulettePickerState createState() => NumericRoulettePickerState();
}

class NumericRoulettePickerState extends State<NumericRoulettePicker> {
  late PageController _pageController;
  late int _currentPage;
  late double step;

  Axis get scrollDirection => widget.vertical ? Axis.vertical : Axis.horizontal;
  double get itemHeight => widget.vertical ? 200.0 : 60.0;

  @override
  void initState() {
    super.initState();
    step = widget.allowDecimal ? widget.step / 2 : widget.step;
    double initialPage = ((widget.value - widget.minValue) / step)
        .clamp(widget.minValue / step, widget.maxValue / step);
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
    if (widget.value != oldWidget.value) {
      _controllerValueChanged();
    }
  }

  void _controllerValueChanged() {
    final value = widget.value;
    int pageIndex = ((value - widget.minValue) / step).toInt();
    setState(() {
      double clampedValue = value.clamp(widget.minValue, widget.maxValue);
      widget.controller.text =
          clampedValue.toStringAsFixed(widget.allowDecimal ? 1 : 0);
    });
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final physics = widget.allowDecimal
        ? const _EnhancedPageScrollPhysics()
        : const PageScrollPhysics();

    Widget roulette = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: PageView.builder(
        scrollDirection: scrollDirection,
        controller: _pageController,
        physics: physics,
        onPageChanged: (index) {
          setState(() {
            double newValue = (index * step + widget.minValue)
                .clamp(widget.minValue, widget.maxValue);
            widget.controller.text =
                newValue.toStringAsFixed(widget.allowDecimal ? 1 : 0);
            _currentPage = index;
          });
        },
        itemBuilder: (context, index) {
          final computedValue = index * step + widget.minValue;
          final displayValue =
              computedValue.toStringAsFixed(widget.allowDecimal ? 1 : 0);
          if (index == _currentPage) {
            return Center(
              child: Container(
                width: widget.vertical ? 120 : 80,
                padding: widget.vertical
                    ? const EdgeInsets.symmetric(vertical: 4)
                    : null,
                decoration: BoxDecoration(
                  border: widget.vertical
                      ? Border(
                          left:
                              BorderSide(color: AppColors.greyColor, width: 2))
                      : Border(
                          bottom:
                              BorderSide(color: AppColors.greyColor, width: 2)),
                ),
                child: TextField(
                  controller: widget.controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: widget.allowDecimal),
                  style: TextStyle(
                    fontSize: widget.vertical ? 36 : 28,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onSubmitted: (value) {
                    final parsed = double.tryParse(value);
                    if (parsed != null) {
                      final newValue =
                          widget.allowDecimal ? parsed : parsed.roundToDouble();
                      int pageIndex =
                          ((newValue - widget.minValue) / step).toInt();
                      _pageController.animateToPage(
                        pageIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
              ),
            );
          } else {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: widget.vertical ? 120 : 40,
                  minHeight: widget.vertical
                      ? 120
                      : 60, // adjust these values as needed
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    displayValue,
                    style: TextStyle(
                      fontSize: widget.vertical ? 20 : 16,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );

    // Use a Stack to overlay a label on top of the roulette.
    final rouletteWidget = Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: roulette,
      ),
    );

    final labelWidget = Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 16.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.label,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.greyColor),
        ),
      ),
    );

    final children = widget.vertical
        ? [rouletteWidget, labelWidget]
        : [labelWidget, rouletteWidget];

    return SizedBox(
      height: widget.vertical ? 200 : 80,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: widget.vertical
            ? Row(children: children)
            : Column(children: children),
      ),
    );
  }
}

class _EnhancedPageScrollPhysics extends PageScrollPhysics {
  const _EnhancedPageScrollPhysics({super.parent});

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * 2.0);
  }

  @override
  _EnhancedPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _EnhancedPageScrollPhysics(parent: buildParent(ancestor));
  }
}
