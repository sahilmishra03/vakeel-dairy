import 'package:flutter/foundation.dart';
import '../models/case_model.dart';
import '../services/hive_service.dart';

class CaseProvider extends ChangeNotifier {
  List<CaseModel> _allCases = [];
  List<CaseModel> _todayHearings = [];
  int _activeCasesCount = 0;

  // Getters
  List<CaseModel> get allCases => _allCases;
  List<CaseModel> get todayHearings => _todayHearings;
  int get activeCasesCount => _activeCasesCount;

  // Initialize and load data
  Future<void> initialize() async {
    await _loadData();
  }

  // Load all data
  Future<void> _loadData() async {
    _allCases = HiveService.getAllCases();
    _todayHearings = HiveService.getTodayHearings();
    _activeCasesCount = HiveService.getActiveCasesCount();
    notifyListeners();
  }

  // Add a new case
  Future<void> addCase(CaseModel caseModel) async {
    try {
      await HiveService.addCase(caseModel);
      await _loadData(); // Refresh all data
    } catch (e) {
      debugPrint('Error adding case: $e');
      rethrow;
    }
  }

  // Update a case
  Future<void> updateCase(CaseModel caseModel) async {
    try {
      await HiveService.updateCase(caseModel);
      await _loadData(); // Refresh all data
    } catch (e) {
      debugPrint('Error updating case: $e');
      rethrow;
    }
  }

  // Delete a case
  Future<void> deleteCase(String caseId) async {
    try {
      await HiveService.deleteCase(caseId);
      await _loadData(); // Refresh all data
    } catch (e) {
      debugPrint('Error deleting case: $e');
      rethrow;
    }
  }

  // Get case by ID
  CaseModel? getCaseById(String id) {
    return HiveService.getCaseById(id);
  }

  // Search cases
  List<CaseModel> searchCases(String query) {
    return HiveService.searchCases(query);
  }

  // Get cases by status
  List<CaseModel> getCasesByStatus(String status) {
    return HiveService.getCasesByStatus(status);
  }

  // Get cases by type
  List<CaseModel> getCasesByType(String caseType) {
    return HiveService.getCasesByType(caseType);
  }

  // Force refresh data
  Future<void> refresh() async {
    await _loadData();
  }
}
