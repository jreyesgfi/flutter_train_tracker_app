import 'package:flutter/material.dart';
import 'package:flutter_application_test1/theme/custom_colors.dart';

class NumericRoulettePicker extends StatefulWidget {
  final TextEditingController controller;
  final bool allowDecimal;
  final double minValue;
  final double maxValue;
  final double step;
  final String label;

  NumericRoulettePicker({
    Key? key,
    required this.controller,
    this.allowDecimal = false,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.step = 1.0,
    this.label = '',
  }) : super(key: key);

  @override
  _NumericRoulettePickerState createState() => _NumericRoulettePickerState();
}

class _NumericRoulettePickerState extends State<NumericRoulettePicker> {
  late PageController _pageController;
  late int _currentPage;
  late double step;

  @override
  void initState() {
    super.initState();
    step = widget.allowDecimal ? widget.step / 2 : widget.step;
    // Calculate the initial page based on the controller's text value or min value.
    double initialPageValue =
        (double.tryParse(widget.controller.text) ?? widget.minValue) / step;
    // Ensure that initialPageValue is within the range of min and max values.
    initialPageValue =
        initialPageValue.clamp(widget.minValue / step, widget.maxValue / step);
    _currentPage = initialPageValue.toInt();
    _pageController = PageController(
      viewportFraction: 0.33,
      initialPage: _currentPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Custom ScrollPhysics to increase swipe strength for decimal values
    final PageScrollPhysics physics = widget.allowDecimal
        ? _EnhancedPageScrollPhysics()
        : const PageScrollPhysics();
    return Row(
      children: [
        // Label occupying half of the width
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        // Roulette picker occupying the remaining half
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              // Static colored square as a reference for the selected number
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // roulette picker
              Container(
                height: 60,
                child: PageView.builder(
                  controller: _pageController,
                  physics: physics,
                  onPageChanged: (index) {
                    setState(() {
                      // Use the adjusted step value from the state for calculations.
                      double newValue = (index * step)
                          .clamp(widget.minValue, widget.maxValue);
                      widget.controller.text =
                          newValue.toStringAsFixed(widget.allowDecimal ? 1 : 0);
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          (index * step)
                              .toStringAsFixed(widget.allowDecimal ? 1 : 0),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: index == _currentPage
                                ? Colors.white
                                : context.customColors.greyColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom ScrollPhysics to increase swipe strength
class _EnhancedPageScrollPhysics extends PageScrollPhysics {
  const _EnhancedPageScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // Increase the swipe strength by multiplying the offset
    return super.applyPhysicsToUserOffset(position, offset * 2.0);
  }

  @override
  _EnhancedPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _EnhancedPageScrollPhysics(parent: buildParent(ancestor));
  }
}
