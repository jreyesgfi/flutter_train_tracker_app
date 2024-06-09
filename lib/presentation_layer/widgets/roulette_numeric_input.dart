import 'package:flutter/material.dart';

class NumericRoulettePicker extends StatefulWidget {
  final TextEditingController controller;
  final bool allowDecimal;
  final double minValue;
  final double maxValue;
  final double step;
  final String label;
  final double value;
  

  NumericRoulettePicker({
    Key? key,
    required this.controller,
    this.value = 0,
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
    double initialValue = (widget.value ?? widget.minValue) / step;
    initialValue =
        initialValue.clamp(widget.minValue / step, widget.maxValue / step);
    _currentPage = initialValue.toInt();
    _pageController = PageController(
      viewportFraction: 0.33,
      initialPage: _currentPage,
    );
  }
  @override
void didUpdateWidget(NumericRoulettePicker oldWidget) {
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
          (clampedValue * step).toStringAsFixed(widget.allowDecimal ? 1 : 0);
    });

    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 500), // Adjust duration as needed
      curve: Curves.ease,
    );
  }



  @override
  Widget build(BuildContext context) {
    final PageScrollPhysics physics = widget.allowDecimal
        ? _EnhancedPageScrollPhysics()
        : const PageScrollPhysics();
    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Container(
                height: 60,
                child: PageView.builder(
                  controller: _pageController,
                  physics: physics,
                  onPageChanged: (index) {
                    setState(() {
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
                                : Theme.of(context).hintColor,
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
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EnhancedPageScrollPhysics extends PageScrollPhysics {
  const _EnhancedPageScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return super.applyPhysicsToUserOffset(position, offset * 2.0);
  }

  @override
  _EnhancedPageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _EnhancedPageScrollPhysics(parent: buildParent(ancestor));
  }
}
