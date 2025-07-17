import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';
import 'shift_details_screen.dart';

class IncomeReportScreen extends StatefulWidget {
  const IncomeReportScreen({super.key});

  @override
  State<IncomeReportScreen> createState() => _IncomeReportScreenState();
}

class _IncomeReportScreenState extends State<IncomeReportScreen> {
  int _selectedTab = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.get('incomeReport')),
      ),
      body: Column(
        children: [
          // Tab selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildTabButton(
                  title: 'Overview',
                  index: 0,
                  icon: Icons.dashboard,
                ),
                _buildTabButton(
                  title: 'Monthly',
                  index: 1,
                  icon: Icons.calendar_month,
                ),
                _buildTabButton(
                  title: 'Members',
                  index: 2,
                  icon: Icons.people,
                ),
              ],
            ),
          ),
          
          // Main content based on selected tab
          Expanded(
            child: _selectedTab == 0
                ? _buildOverviewTab()
                : _selectedTab == 1
                    ? _buildMonthlyTab()
                    : _buildMembersTab(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTabButton({
    required String title,
    required int index,
    required IconData icon,
  }) {
    final isSelected = _selectedTab == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildOverviewTab() {
    final memberProvider = Provider.of<MemberProvider>(context);
    final currencyFormatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
      locale: 'en_IN',
    );
    
    // Calculate yearly projection based on current month
    final yearlyProjection = memberProvider.currentMonthIncome * 12;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Income summary card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Income',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormatter.format(memberProvider.totalIncome),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildIncomeStatItem(
                        title: 'This Month',
                        value: currencyFormatter.format(memberProvider.currentMonthIncome),
                        color: Colors.white,
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      _buildIncomeStatItem(
                        title: 'Yearly Projection',
                        value: currencyFormatter.format(yearlyProjection),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Statistics section
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                title: 'Total Members',
                value: memberProvider.members.length.toString(),
                icon: Icons.people,
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                title: 'Morning Shift',
                value: memberProvider.morningShiftMembers.length.toString(),
                icon: Icons.wb_sunny,
                color: AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                title: 'Night Shift',
                value: memberProvider.nightShiftMembers.length.toString(),
                icon: Icons.nightlight_round,
                color: AppColors.info,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                title: 'Expiring Soon',
                value: memberProvider.expiringSoonMembers.length.toString(),
                icon: Icons.warning_amber,
                color: AppColors.warning,
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Suggestions section
          const Text(
            'Suggestions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Suggestions based on data analysis
          _buildSuggestionCard(
            title: 'Membership Renewal',
            description: 'Send reminders to ${memberProvider.expiringSoonMembers.length} members whose subscriptions are ending soon.',
            actionText: 'View Members',
            icon: Icons.notification_important,
            color: AppColors.warning,
            onAction: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShiftDetailsScreen(title: 'Expiring Members'),
                ),
              );
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildSuggestionCard(
            title: 'Growth Opportunity',
            description: memberProvider.morningShiftMembers.length > memberProvider.nightShiftMembers.length * 1.5
                ? 'Night shift has significantly fewer members. Consider promotional offers to boost night shift membership.'
                : memberProvider.nightShiftMembers.length > memberProvider.morningShiftMembers.length * 1.5 
                    ? 'Morning shift has significantly fewer members. Consider promotional offers to boost morning shift membership.'
                    : 'Your morning and night shifts are well balanced. Consider an overall membership drive to grow your gym.',
            actionText: 'Plan Campaign',
            icon: Icons.trending_up,
            color: AppColors.success,
            onAction: () {
              // Show a dialog or navigate to campaign planning
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Campaign planning feature coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildMonthlyTab() {
    final memberProvider = Provider.of<MemberProvider>(context);
    final members = memberProvider.members;
    
    // Group members by joining month for monthly report
    final monthlyData = <String, double>{};
    
    for (final member in members) {
      final month = DateFormat('MMM yyyy').format(member.joiningDate);
      monthlyData[month] = (monthlyData[month] ?? 0) + member.amount;
    }
    
    // Sort months chronologically
    final sortedMonths = monthlyData.keys.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMM yyyy').parse(a);
        final dateB = DateFormat('MMM yyyy').parse(b);
        return dateB.compareTo(dateA); // Reverse to get newest first
      });
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMonths.length,
      itemBuilder: (context, index) {
        final month = sortedMonths[index];
        final amount = monthlyData[month]!;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              month,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Members: ${members.where((m) => DateFormat('MMM yyyy').format(m.joiningDate) == month).length}',
            ),
            trailing: Text(
              '₹${amount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildMembersTab() {
    final memberProvider = Provider.of<MemberProvider>(context);
    final members = memberProvider.members;
    
    // Sort members by amount (highest paying first)
    final sortedMembers = [...members]..sort((a, b) => b.amount.compareTo(a.amount));
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedMembers.length,
      itemBuilder: (context, index) {
        final member = sortedMembers[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            title: Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              member.isMorningShift 
                  ? AppStrings.get('morningShift')
                  : AppStrings.get('nightShift'),
            ),
            trailing: Text(
              '₹${member.amount.toStringAsFixed(0)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildIncomeStatItem({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSuggestionCard({
    required String title,
    required String description,
    required String actionText,
    required IconData icon,
    required Color color,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onAction,
              child: Text(
                actionText,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}