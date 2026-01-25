// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'case_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CaseModelAdapter extends TypeAdapter<CaseModel> {
  @override
  final int typeId = 0;

  @override
  CaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CaseModel(
      id: fields[0] as String,
      caseNumber: fields[1] as String,
      caseType: fields[2] as String,
      courtName: fields[3] as String,
      clientName: fields[4] as String,
      opponentName: fields[5] as String,
      judgeName: fields[6] as String,
      previousHearing: fields[7] as String,
      nextHearing: fields[8] as String,
      status: fields[9] as String,
      isArchived: fields[10] as bool,
      createdAt: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CaseModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.caseNumber)
      ..writeByte(2)
      ..write(obj.caseType)
      ..writeByte(3)
      ..write(obj.courtName)
      ..writeByte(4)
      ..write(obj.clientName)
      ..writeByte(5)
      ..write(obj.opponentName)
      ..writeByte(6)
      ..write(obj.judgeName)
      ..writeByte(7)
      ..write(obj.previousHearing)
      ..writeByte(8)
      ..write(obj.nextHearing)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.isArchived)
      ..writeByte(11)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
