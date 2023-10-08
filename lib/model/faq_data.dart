import 'dart:convert';

class FaqData {
  String? id;
  int? sortNo;
  String? question;
  String? answer;

  FaqData({
    this.id,
    this.sortNo,
    this.question,
    this.answer,
  });

  FaqData copyWith({
    String? id,
    int? sortNo,
    String? question,
    String? answer,
  }) {
    return FaqData(
      id: id ?? this.id,
      sortNo: sortNo ?? this.sortNo,
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sortNo': sortNo,
      'question': question,
      'answer': answer,
    };
  }

  factory FaqData.fromMap(Map<String, dynamic> map) {
    return FaqData(
      id: map['id'],
      sortNo: map['sortNo'],
      question: map['question'],
      answer: map['answer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FaqData.fromJson(String source) =>
      FaqData.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqData && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
