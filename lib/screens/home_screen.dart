import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/member_provider.dart';
import '../providers/shift_provider.dart';
import '../widgets/shift_card.dart';
import 'income_report_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MemberProvider>(context, listen: false)
          .checkExpiringMemberships();
    });
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('appName')),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const IncomeReportScreen(),
                ),
              );
            },
            tooltip: AppStrings.get('incomeReport'),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          image: DecorationImage(
            image: const AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.1),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.payments_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.get('currentMonthIncome'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${memberProvider.currentMonthIncome.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ₹${memberProvider.totalIncome.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  AppStrings.get('selectShift'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 16),

                // Shift cards row
                Row(
                  children: [
                    Expanded(
                      child: ShiftCard(
                        title: AppStrings.get('morningShift'),
                        icon: Icons.wb_sunny,
                        memberCount:
                            memberProvider.morningShiftMembers.length,
                        colors: AppColors.morningGradient,
                        onTap: () {
                          Provider.of<ShiftProvider>(context, listen: false)
                              .setShift(true);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ShiftCard(
                        title: AppStrings.get('nightShift'),
                        icon: Icons.nightlight_round,
                        memberCount:
                            memberProvider.nightShiftMembers.length,
                        colors: AppColors.nightGradient,
                        onTap: () {
                          Provider.of<ShiftProvider>(context, listen: false)
                              .setShift(false);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Expiring members section
                if (memberProvider.expiringSoonMembers.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${AppStrings.get('subscriptionEnding')} (${memberProvider.expiringSoonMembers.length})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...memberProvider.expiringSoonMembers
                            .take(3)
                            .map(
                              (member) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• ${member.name} - ${member.remainingDays} ${AppStrings.get('daysLeft')}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                        if (memberProvider.expiringSoonMembers.length > 3)
                          Text(
                            '+ ${memberProvider.expiringSoonMembers.length - 3} more...',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
