import 'package:hive/hive.dart';

part 'case_model.g.dart';

@HiveType(typeId: 0)
class CaseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String caseNumber;

  @HiveField(2)
  final String caseType;

  @HiveField(3)
  final String courtName;

  @HiveField(4)
  final String clientName;

  @HiveField(5)
  final String opponentName;

  @HiveField(6)
  final String judgeName;

  @HiveField(7)
  final String previousHearing;

  @HiveField(8)
  final String nextHearing;

  @HiveField(9)
  final String status;

  @HiveField(10)
  final bool isArchived;

  @HiveField(11)
  final DateTime createdAt;

  CaseModel({
    required this.id,
    required this.caseNumber,
    required this.caseType,
    required this.courtName,
    required this.clientName,
    required this.opponentName,
    required this.judgeName,
    required this.previousHearing,
    required this.nextHearing,
    required this.status,
    this.isArchived = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Create a copyWith method for updates
  CaseModel copyWith({
    String? id,
    String? caseNumber,
    String? caseType,
    String? courtName,
    String? clientName,
    String? opponentName,
    String? judgeName,
    String? previousHearing,
    String? nextHearing,
    String? status,
    bool? isArchived,
    DateTime? createdAt,
  }) {
    return CaseModel(
      id: id ?? this.id,
      caseNumber: caseNumber ?? this.caseNumber,
      caseType: caseType ?? this.caseType,
      courtName: courtName ?? this.courtName,
      clientName: clientName ?? this.clientName,
      opponentName: opponentName ?? this.opponentName,
      judgeName: judgeName ?? this.judgeName,
      previousHearing: previousHearing ?? this.previousHearing,
      nextHearing: nextHearing ?? this.nextHearing,
      status: status ?? this.status,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'CaseModel(id: $id, caseNumber: $caseNumber, caseType: $caseType, clientName: $clientName, status: $status)';
  }
}
