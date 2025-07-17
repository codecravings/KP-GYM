import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../models/member.dart';
import '../services/database_service.dart';

class MemberProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  
  List<Member> _members = [];
  List<Member> _morningShiftMembers = [];
  List<Member> _nightShiftMembers = [];
  List<Member> _expiringSoonMembers = [];
  double _currentMonthIncome = 0.0;
  double _totalIncome = 0.0;
  bool _isLoading = false;
  
  // Getters
  List<Member> get members => _members;
  List<Member> get morningShiftMembers => _morningShiftMembers;
  List<Member> get nightShiftMembers => _nightShiftMembers;
  List<Member> get expiringSoonMembers => _expiringSoonMembers;
  double get currentMonthIncome => _currentMonthIncome;
  double get totalIncome => _totalIncome;
  bool get isLoading => _isLoading;
  
  // Load all members
  Future<void> loadMembers() async {
    _setLoading(true);
    
    try {
      _members = await _databaseService.getMembers();
      _morningShiftMembers = await _databaseService.getMembers(isMorningShift: true);
      _nightShiftMembers = await _databaseService.getMembers(isMorningShift: false);
      _expiringSoonMembers = _members.where((member) => member.isAboutToExpire).toList();
      _currentMonthIncome = await _databaseService.getCurrentMonthIncome();
      _totalIncome = await _databaseService.getTotalIncome();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading members: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Add a new member
  Future<bool> addMember(Member member) async {
    _setLoading(true);
    
    try {
      await _databaseService.insertMember(member);
      await loadMembers();
      return true;
    } catch (e) {
      debugPrint('Error adding member: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Update an existing member
  Future<bool> updateMember(Member member) async {
    _setLoading(true);
    
    try {
      await _databaseService.updateMember(member);
      await loadMembers();
      return true;
    } catch (e) {
      debugPrint('Error updating member: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Delete a member
  Future<bool> deleteMember(int id) async {
    _setLoading(true);
    
    try {
      await _databaseService.deleteMember(id);
      await loadMembers();
      return true;
    } catch (e) {
      debugPrint('Error deleting member: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Check for expiring memberships
  Future<void> checkExpiringMemberships() async {
    try {
      final expiringMembers = await _databaseService.getMembersAboutToExpire();
      
      // Use WidgetsBinding to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _expiringSoonMembers = expiringMembers;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error checking expiring memberships: $e');
    }
  }
  
  // Helper method to set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}