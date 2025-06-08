import 'dart:convert';

class Dream {
  final int? id;
  final String title;
  final String desc;
  final String date;
  final double progress;
  final List<String> steps;

  Dream({
    this.id,
    required this.title,
    required this.desc,
    required this.date,
    required this.progress,
    required this.steps,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'progress': progress,
      'steps': jsonEncode(steps),  // Encode list ke JSON string
    };
  }

  factory Dream.fromMap(Map<String, dynamic> map) {
    return Dream(
      id: map['id'],
      title: map['title'],
      desc: map['desc'],
      date: map['date'],
      progress: map['progress'],
      steps: List<String>.from(jsonDecode(map['steps'])),
    );
  }
}
