import 'package:flutter/material.dart';
import 'package:flutter_application_test1/common_layer/theme/app_theme.dart';
import 'package:flutter_application_test1/presentation_layer/widgets/common/buttons/custom_icon_button.dart';

class NextIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const NextIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onTap: onTap,
      icon: Icons.play_arrow,
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }
}


// import 'package:flutter/material.dart';

// class NextButton extends StatelessWidget {
//   final VoidCallback onTap;

//   const NextButton({super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       // Ensures the button is centered if it doesn't fill the parent
//       child: SizedBox(
//         width: 50, // Fixed width
//         height: 50, // Fixed height
//         child: Container(
//           decoration: BoxDecoration(
//             color: Theme.of(context).primaryColor, // Button color
//             borderRadius:
//                 BorderRadius.circular(10), // Rounded corners for square shape
//           ),
//           child: Material(
//             color: Colors
//                 .transparent, // Ensure that the Material widget is transparent
//             child: InkWell(
//               onTap: onTap,
//               borderRadius: BorderRadius.circular(
//                   10), // Match the container border radius
//               child: const Center(
//                 child: Icon(Icons.play_arrow,
//                     color: Colors.white, size: 24), // Play icon
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
