import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class RemainingDaysBadge extends StatelessWidget {
  final int remainingDays;
  final double size;

  const RemainingDaysBadge({
    super.key,
    required this.remainingDays,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on remaining days
    Color badgeColor;
    IconData iconData;
    String message;

    if (remainingDays <= 0) {
      badgeColor = AppColors.error;
      iconData = Icons.cancel;
      message = 'Expired';
    } else if (remainingDays <= 5) {
      badgeColor = AppColors.warning;
      iconData = Icons.warning_amber_rounded;
      message = '${AppStrings.get('daysLeft')}';
    } else {
      badgeColor = AppColors.success;
      iconData = Icons.check_circle;
      message = '${AppStrings.get('daysLeft')}';
    }
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        border: Border.all(
          color: badgeColor.withOpacity(0.3),
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: badgeColor,
            size: size * 0.3,
          ),
          const SizedBox(height: 2),
          Text(
            '$remainingDays',
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.25,
            ),
          ),
          Text(
            message,
            style: TextStyle(
              color: badgeColor,
              fontSize: size * 0.14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// A smaller version that can be used as a status indicator
class RemainingDaysIndicator extends StatelessWidget {
  final int remainingDays;
  final double size;

  const RemainingDaysIndicator({
    super.key,
    required this.remainingDays,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on remaining days
    Color indicatorColor;
    IconData iconData;

    if (remainingDays <= 0) {
      indicatorColor = AppColors.error;
      iconData = Icons.cancel;
    } else if (remainingDays <= 5) {
      indicatorColor = AppColors.warning;
      iconData = Icons.warning_amber_rounded;
    } else {
      indicatorColor = AppColors.success;
      iconData = Icons.check_circle;
    }
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: indicatorColor.withOpacity(0.1),
        border: Border.all(
          color: indicatorColor,
          width: 1,
        ),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            iconData,
            color: indicatorColor,
            size: size * 0.5,
          ),
          if (remainingDays > 0 && remainingDays <= 10)
            Positioned(
              bottom: 2,
              child: Text(
                '$remainingDays',
                style: TextStyle(
                  color: indicatorColor,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}