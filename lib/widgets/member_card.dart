import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/member.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback onTap;

  const MemberCard({
    super.key,
    required this.member,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format dates
    final dateFormat = DateFormat('dd MMM yyyy');
    final joinDate = dateFormat.format(member.joiningDate);
    
    // Calculate expiry date
    final expiryDate = dateFormat.format(member.expiryDate);
    
    // Determine card color based on remaining days
    Color statusColor;
    if (member.isExpired) {
      statusColor = AppColors.error;
    } else if (member.isAboutToExpire) {
      statusColor = AppColors.warning;
    } else {
      statusColor = AppColors.success;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name and Status
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Name and subscription type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          member.subscriptionDays == 30 
                              ? AppStrings.get('monthlySubscription')
                              : AppStrings.get('quarterlySubscription'),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Status indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          member.isExpired
                              ? Icons.cancel
                              : member.isAboutToExpire
                                  ? Icons.warning
                                  : Icons.check_circle,
                          color: statusColor,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          member.isExpired
                              ? 'Expired'
                              : '${member.remainingDays} ${AppStrings.get('daysLeft')}',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Details row
              Row(
                children: [
                  // Join date
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.calendar_today,
                      title: AppStrings.get('joiningDate'),
                      value: joinDate,
                    ),
                  ),
                  
                  // Expiry date
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.event,
                      title: 'Expiry Date',
                      value: expiryDate,
                    ),
                  ),
                  
                  // Amount
                  Expanded(
                    child: _buildDetailItem(
                      icon: Icons.payments,
                      title: AppStrings.get('amount'),
                      value: '₹${member.amount.toStringAsFixed(0)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}