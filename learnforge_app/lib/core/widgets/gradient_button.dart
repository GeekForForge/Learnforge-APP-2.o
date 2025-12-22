import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final double? width; // Changed to nullable
  final double height;
  final bool disabled;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool isLoading;
  final EdgeInsetsGeometry? padding; // Made optional and nullable

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.width, // Now nullable, no default infinite width
    this.height = 50.0,
    this.disabled = false,
    this.borderRadius = 12.0, // Reduced from 25.0 for better fit
    this.textStyle,
    this.isLoading = false,
    this.padding, // Made optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Can be null now, allowing intrinsic width
      height: height,
      decoration: BoxDecoration(
        gradient: disabled
            ? const LinearGradient(colors: [Colors.grey, Colors.grey])
            : gradient ?? _defaultGradient(),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: disabled
            ? []
            : [
                BoxShadow(
                  color: AppColors.neonPurple.withOpacity(
                    0.5,
                  ), // Better neon glow
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: disabled ? null : onPressed,
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      text,
                      style:
                          textStyle ??
                          TextStyles.inter(
                            // Using your TextStyles
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Gradient _defaultGradient() {
    return const LinearGradient(
      colors: [AppColors.neonPurple, AppColors.neonBlue],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
  }
}
