class QuestionModel {
  final int id;
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String difficulty;
  final String topic;

  QuestionModel({
    required this.id,
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.topic,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // Handle options: Check for list 'options' or fields 'optionA', 'optionB', etc.
    List<String> parsedOptions = [];
    if (json['options'] != null) {
      parsedOptions = List<String>.from(json['options']);
    } else if (json['optionA'] != null) {
      parsedOptions.add(json['optionA'].toString());
      if (json['optionB'] != null) parsedOptions.add(json['optionB'].toString());
      if (json['optionC'] != null) parsedOptions.add(json['optionC'].toString());
      if (json['optionD'] != null) parsedOptions.add(json['optionD'].toString());
    }

    return QuestionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      text: json['text'] ?? json['questionText'] ?? 'Unknown Question',
      options: parsedOptions,
      correctAnswer: json['correctAnswer'] ?? json['answer'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      topic: json['topic'] ?? 'General',
    );
  }
}
