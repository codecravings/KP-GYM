import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';
import '../providers/shift_provider.dart';
import '../services/whatsapp_service.dart';
import '../widgets/member_card.dart';
import 'member_form_screen.dart';

class ShiftDetailsScreen extends StatefulWidget {
  final String title;

  const ShiftDetailsScreen({
    super.key,
    required this.title,
  });

  @override
  State<ShiftDetailsScreen> createState() => _ShiftDetailsScreenState();
}

class _ShiftDetailsScreenState extends State<ShiftDetailsScreen> {
  String _searchQuery = '';
  
  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final shiftProvider = Provider.of<ShiftProvider>(context);
    
    // Get members for the current shift
    final members = shiftProvider.isMorningShift
        ? memberProvider.morningShiftMembers
        : memberProvider.nightShiftMembers;
    
    // Filter members based on search
    final filteredMembers = _searchQuery.isEmpty
        ? members
        : members
            .where((member) =>
                member.name.toLowerCase().contains(_searchQuery.toLowerCase()))
            .toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search field
                TextField(
                  decoration: InputDecoration(
                    hintText: AppStrings.get('search'),
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Stats row
                Row(
                  children: [
                    // Total members
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.people,
                        title: AppStrings.get('members'),
                        value: members.length.toString(),
                        color: AppColors.primary,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Expiring soon
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.warning_rounded,
                        title: AppStrings.get('subscriptionEnding'),
                        value: members
                            .where((m) => m.isAboutToExpire)
                            .length
                            .toString(),
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Members list
          Expanded(
            child: memberProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredMembers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_off,
                              size: 64,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No members found for this shift'
                                  : 'No members match your search',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredMembers.length,
                        itemBuilder: (context, index) {
                          final member = filteredMembers[index];
                          return MemberCard(
                            member: member,
                            onTap: () => _showMemberActions(context, member),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add member screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MemberFormScreen(
                isMorningShift: shiftProvider.isMorningShift,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
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
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showMemberActions(BuildContext context, Member member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Member info header
              ListTile(
                title: Text(
                  member.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  '${AppStrings.get('remainingDays')}: ${member.remainingDays}',
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              
              const Divider(),
              
              // Actions
              // Edit
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(AppStrings.get('edit')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MemberFormScreen(
                        member: member,
                        isMorningShift: member.isMorningShift,
                      ),
                    ),
                  );
                },
              ),
              
              // Share
              ListTile(
                leading: const Icon(Icons.share),
                title: Text(AppStrings.get('share')),
                onTap: () {
                  Navigator.pop(context);
                  _shareSubscriptionReminder(context, member);
                },
              ),
              
              // Delete
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: AppColors.error,
                ),
                title: Text(
                  AppStrings.get('delete'),
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDeleteMember(context, member);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _shareSubscriptionReminder(BuildContext context, Member member) async {
    try {
      final success = await WhatsAppService.shareSubscriptionReminder(
        member,
        context: context,
        language: 'mr', // Use Marathi language
      );
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.get('shareSuccess')),
            backgroundColor: AppColors.success,
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.get('shareError')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.get('shareError')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
  
  void _confirmDeleteMember(BuildContext context, Member member) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get('deleteMember')),
        content: Text(AppStrings.get('confirmDelete')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.get('cancel')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final memberProvider =
                  Provider.of<MemberProvider>(context, listen: false);
              final success = await memberProvider.deleteMember(member.id!);
              
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppStrings.get('memberDeleted')),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: Text(
              AppStrings.get('delete'),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}