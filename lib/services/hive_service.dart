import 'package:hive/hive.dart';
import '../models/case_model.dart';

class HiveService {
  static const String _caseBoxName = 'cases';
  static Box<CaseModel>? _caseBox;

  // Initialize Hive
  static Future<void> init() async {
    // Register adapters
    Hive.registerAdapter(CaseModelAdapter());

    // Open boxes
    _caseBox = await Hive.openBox<CaseModel>(_caseBoxName);
  }

  // Get the case box
  static Box<CaseModel> get caseBox {
    if (_caseBox == null) {
      throw Exception('Hive not initialized. Call init() first.');
    }
    return _caseBox!;
  }

  // Add a new case
  static Future<void> addCase(CaseModel caseModel) async {
    await caseBox.put(caseModel.id, caseModel);
  }

  // Get all cases
  static List<CaseModel> getAllCases() {
    return caseBox.values.toList();
  }

  // Get case by ID
  static CaseModel? getCaseById(String id) {
    return caseBox.get(id);
  }

  // Update a case
  static Future<void> updateCase(CaseModel caseModel) async {
    await caseBox.put(caseModel.id, caseModel);
  }

  // Delete a case
  static Future<void> deleteCase(String id) async {
    await caseBox.delete(id);
  }

  // Get cases by status
  static List<CaseModel> getCasesByStatus(String status) {
    return caseBox.values
        .where((caseModel) => caseModel.status == status)
        .toList();
  }

  // Get cases by type
  static List<CaseModel> getCasesByType(String caseType) {
    return caseBox.values
        .where((caseModel) => caseModel.caseType == caseType)
        .toList();
  }

  // Get active cases count
  static int getActiveCasesCount() {
    return caseBox.values
        .where(
          (caseModel) =>
              caseModel.status == 'Active' &&
              !caseModel.isArchived &&
              caseModel.status != 'Closed',
        )
        .length;
  }

  // Get today's hearings (cases with next hearing date today)
  static List<CaseModel> getTodayHearings() {
    final now = DateTime.now();
    final today = "${now.day}-${now.month}-${now.year}";

    return caseBox.values
        .where(
          (caseModel) =>
              caseModel.nextHearing == today &&
              caseModel.status == 'Active' &&
              !caseModel.isArchived &&
              caseModel.status != 'Closed',
        )
        .toList();
  }

  // Search cases by client name or case number
  static List<CaseModel> searchCases(String query) {
    final lowerQuery = query.toLowerCase();
    return caseBox.values
        .where(
          (caseModel) =>
              caseModel.clientName.toLowerCase().contains(lowerQuery) ||
              caseModel.caseNumber.toLowerCase().contains(lowerQuery) ||
              caseModel.opponentName.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  // Clear all cases (for testing)
  static Future<void> clearAllCases() async {
    await caseBox.clear();
  }

  // Close Hive
  static Future<void> close() async {
    await Hive.close();
  }
}
