import 'package:flutter/material.dart';
import '../common/color_extension.dart';

enum RoundButtonType { bgPrimary, textPrimary }

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final RoundButtonType type;
  final double fontSize;
  final Widget? icon;

  const RoundButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.fontSize = 18, // Increased default font size for Windows
    this.type = RoundButtonType.bgPrimary,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click, // Adds hover effect
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 64, // Increased height for desktop
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24), // Add padding
          decoration: BoxDecoration(
            border: type == RoundButtonType.bgPrimary
                ? null
                : Border.all(color: TColor.primary, width: 2), // Adjust border
            color: type == RoundButtonType.bgPrimary
                ? TColor.primary
                : TColor.white,
            borderRadius:
                BorderRadius.circular(32), // Adjust radius for desktop
            boxShadow: [
              if (type ==
                  RoundButtonType.bgPrimary) // Add shadow for raised buttons
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 12), // More space between icon and text
              ],
              Text(
                title,
                style: TextStyle(
                  color: type == RoundButtonType.bgPrimary
                      ? TColor.white
                      : TColor.primary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold, // Use bold for better visibility
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
