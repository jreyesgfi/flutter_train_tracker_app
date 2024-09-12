import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_footer/bottom_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/header_footer/new_top_bar.dart';

class ScreenWrapper extends StatefulWidget {
  final Widget child;

  const ScreenWrapper({super.key, required this.child});

  @override
  State<ScreenWrapper> createState() => _ScreenWrapperState();
}

class _ScreenWrapperState extends State<ScreenWrapper> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          NewTopBar(controller: _scrollController),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child:widget.child
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
