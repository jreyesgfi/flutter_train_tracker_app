import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_colors.dart';
import 'package:flutter_application_test1/common_layer/theme/app_text_styles.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onStartSignUp; // Callback to move to sign-up
  const WelcomeScreen({super.key, required this.onStartSignUp});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image':
          'assets/images/exercises/m1e1.webp', // Replace with actual image paths
      'title': 'Welcome to Gymini',
      'text': 'Track your workouts and achieve your goals efficiently.',
    },
    {
      'image':
          'assets/images/exercises/m1e2.webp', // Replace with actual image paths
      'title': 'Personalized Plans',
      'text': 'Create and follow personalized workout plans.',
    },
    {
      'image':
          'assets/images/exercises/m1e3.webp', // Replace with actual image paths
      'title': 'Progress Tracking',
      'text': 'Monitor your progress and stay motivated.',
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Image.asset(
                          _pages[index]['image']!,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _pages[index]['title']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _pages[index]['text']!,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // Only show the "¡Empecemos!" button on the last page
                      if (index == _pages.length - 1)
                        ElevatedButton(
                          onPressed:
                              widget.onStartSignUp, // Trigger sign-up process
                         
                          child: Text(
                            '¡Empecemos!',
                            style: AppTextStyles.miniTitle.copyWith(
                              color: AppColors
                                  .whiteColor, // Override color with primaryColor
                            ),
                          ),
                        )
                    ],
                  ),
                );
              },
            ),
          ),
          // Dots indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                width: _currentPage == index ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? AppColors.primaryColor : AppColors.lightGreyColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: GyminiTheme.leftOuterPadding *2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous button - hide if on first page
                if (_currentPage > 0)
                  IconButton(
                    onPressed: _prevPage,
                    icon: const Icon(Icons.arrow_back_ios),
                    color: AppColors.darkColor,
                  )
                else
                  const SizedBox.shrink(), // Hide if can't go back

                // Next button - hide if on last page
                if (_currentPage < _pages.length - 1)
                  IconButton(
                    onPressed: _nextPage,
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: AppColors.darkColor,
                  )
                else
                  const SizedBox.shrink(), // Hide if can't go forward
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
