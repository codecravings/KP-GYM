import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/member.dart';
import '../providers/member_provider.dart';

class MemberFormScreen extends StatefulWidget {
  final Member? member;
  final bool isMorningShift;

  const MemberFormScreen({
    super.key,
    this.member,
    required this.isMorningShift,
  });

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  DateTime _joiningDate = DateTime.now();
  int _subscriptionDays = 30; // Default to monthly
  double _amount = 500.0; // Default amount for monthly
  bool _isMorningShift = true;
  
  @override
  void initState() {
    super.initState();
    
    // If editing an existing member, populate the form
    if (widget.member != null) {
      _nameController.text = widget.member!.name;
      _joiningDate = widget.member!.joiningDate;
      _subscriptionDays = widget.member!.subscriptionDays;
      _amount = widget.member!.amount;
      _isMorningShift = widget.member!.isMorningShift;
    } else {
      _isMorningShift = widget.isMorningShift;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.member != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing
              ? AppStrings.get('editMember')
              : AppStrings.get('addMember'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Member name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: AppStrings.get('memberName'),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.get('nameRequired');
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Joining date
              _buildDatePicker(context),
              
              const SizedBox(height: 24),
              
              // Subscription type
              _buildSubscriptionTypeSelector(),
              
              const SizedBox(height: 24),
              
              // Amount
              TextFormField(
                initialValue: _amount.toString(),
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  prefixIcon: Icon(Icons.payments),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.get('invalidAmount');
                  }
                  try {
                    double.parse(value);
                    return null;
                  } catch (e) {
                    return AppStrings.get('invalidAmount');
                  }
                },
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    try {
                      setState(() {
                        _amount = double.parse(value);
                      });
                    } catch (e) {
                      // Invalid input, ignore
                    }
                  }
                },
              ),
              
              const SizedBox(height: 24),
              
              // Shift selection
              _buildShiftSelector(),
              
              const SizedBox(height: 32),
              
              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      isEditing
                          ? AppStrings.get('save')
                          : AppStrings.get('add'),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDatePicker(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('joiningDate'),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  dateFormat.format(_joiningDate),
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _joiningDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _joiningDate) {
      setState(() {
        _joiningDate = picked;
      });
    }
  }
  
  Widget _buildSubscriptionTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('subscriptionType'),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSubscriptionOption(
                title: AppStrings.get('monthlySubscription'),
                subtitle: '₹500',
                isSelected: _subscriptionDays == 30,
                onTap: () {
                  setState(() {
                    _subscriptionDays = 30;
                    _amount = 500.0;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSubscriptionOption(
                title: AppStrings.get('quarterlySubscription'),
                subtitle: '₹1200',
                isSelected: _subscriptionDays == 90,
                onTap: () {
                  setState(() {
                    _subscriptionDays = 90;
                    _amount = 1200.0;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSubscriptionOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textHint,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppColors.primary : AppColors.textHint,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildShiftSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get('selectShift'),
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Morning shift
            Expanded(
              child: _buildShiftOption(
                title: AppStrings.get('morningShift'),
                icon: Icons.wb_sunny,
                isSelected: _isMorningShift,
                onTap: () {
                  setState(() {
                    _isMorningShift = true;
                  });
                },
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Night shift
            Expanded(
              child: _buildShiftOption(
                title: AppStrings.get('nightShift'),
                icon: Icons.nightlight_round,
                isSelected: !_isMorningShift,
                onTap: () {
                  setState(() {
                    _isMorningShift = false;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildShiftOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.textHint,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textHint,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final memberProvider = Provider.of<MemberProvider>(context, listen: false);
      
      final member = Member(
        id: widget.member?.id,
        name: _nameController.text,
        joiningDate: _joiningDate,
        subscriptionDays: _subscriptionDays,
        amount: _amount,
        isMorningShift: _isMorningShift,
      );
      
      bool success;
      if (widget.member == null) {
        // Add new member
        success = await memberProvider.addMember(member);
      } else {
        // Update existing member
        success = await memberProvider.updateMember(member);
      }
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.member == null
                  ? AppStrings.get('memberAdded')
                  : AppStrings.get('memberUpdated'),
            ),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}