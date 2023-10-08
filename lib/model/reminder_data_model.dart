import 'dart:convert';

class ReminderDataModel {
  String? id;
  String? medicineName;
  int? pillCount;
  int? dosageInMg;
  String? frequency;
  String? time;

  ReminderDataModel({
    this.id,
    this.medicineName,
    this.pillCount,
    this.dosageInMg,
    this.frequency,
    this.time,
  });

  ReminderDataModel copyWith({
    String? id,
    String? medicineName,
    int? pillCount,
    int? dosageInMg,
    String? frequency,
    String? time,
  }) {
    return ReminderDataModel(
      id: id ?? this.id,
      medicineName: medicineName ?? this.medicineName,
      pillCount: pillCount ?? this.pillCount,
      dosageInMg: dosageInMg ?? this.dosageInMg,
      frequency: frequency ?? this.frequency,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineName': medicineName,
      'pillCount': pillCount,
      'dosageInMg': dosageInMg,
      'frequency': frequency,
      'time': time,
    };
  }

  factory ReminderDataModel.fromMap(Map<String, dynamic> map) {
    return ReminderDataModel(
      id: map['id'],
      medicineName: map['medicineName'],
      pillCount: map['pillCount'],
      dosageInMg: map['dosageInMg'],
      frequency: map['frequency'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReminderDataModel.fromJson(String source) =>
      ReminderDataModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderDataModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
