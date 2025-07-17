import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
  text,
  success,
  warning,
  error,
}

enum ButtonSize {
  small,
  medium,
  large,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool disabled;
  final double? borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.disabled = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    // Define button styles based on type
    Color backgroundColor;
    Color textColor;
    Color borderColor;
    
    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppColors.primary;
        textColor = Colors.white;
        borderColor = AppColors.primary;
        break;
      case ButtonType.secondary:
        backgroundColor = AppColors.secondary;
        textColor = Colors.white;
        borderColor = AppColors.secondary;
        break;
      case ButtonType.outlined:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        borderColor = AppColors.primary;
        break;
      case ButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = AppColors.primary;
        borderColor = Colors.transparent;
        break;
      case ButtonType.success:
        backgroundColor = AppColors.success;
        textColor = Colors.white;
        borderColor = AppColors.success;
        break;
      case ButtonType.warning:
        backgroundColor = AppColors.warning;
        textColor = Colors.white;
        borderColor = AppColors.warning;
        break;
      case ButtonType.error:
        backgroundColor = AppColors.error;
        textColor = Colors.white;
        borderColor = AppColors.error;
        break;
    }
    
    // Apply opacity if disabled
    if (disabled) {
      backgroundColor = backgroundColor.withOpacity(0.6);
      textColor = textColor.withOpacity(0.6);
      borderColor = borderColor.withOpacity(0.6);
    }
    
    // Get padding based on size
    EdgeInsets padding;
    double fontSize;
    double iconSize;
    
    switch (size) {
      case ButtonSize.small:
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        fontSize = 12;
        iconSize = 16;
        break;
      case ButtonSize.medium:
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        fontSize = 14;
        iconSize = 18;
        break;
      case ButtonSize.large:
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
        fontSize = 16;
        iconSize = 20;
        break;
    }
    
    // Build the button content
    Widget buttonContent;
    
    if (isLoading) {
      buttonContent = SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    } else if (icon != null) {
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      buttonContent = Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    
    // Determine button radius
    final radius = borderRadius ?? (type == ButtonType.text ? 0 : 12);
    
    // Build the button wrapper
    Widget buttonWrapper;
    
    if (type == ButtonType.text) {
      // Text button doesn't need physical button styling
      buttonWrapper = TextButton(
        onPressed: disabled ? null : onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          foregroundColor: textColor,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: buttonContent,
      );
    } else {
      // For other button types
      buttonWrapper = ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: type == ButtonType.outlined
              ? BorderSide(color: borderColor)
              : null,
          elevation: type == ButtonType.outlined || type == ButtonType.text ? 0 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: buttonContent,
      );
    }
    
    // Apply full width if needed
    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: buttonWrapper,
      );
    }
    
    return buttonWrapper;
  }
}