class TopicModel {

  final String title;
  final List<SubTopic> subtopics;

  TopicModel({
    required this.title,
    required this.subtopics
});

  factory TopicModel.fromJson(Map<String, dynamic> json){
    return TopicModel(
        title: json['title'],
        subtopics: (json['subtopics'] as List)
            .map((e) => SubTopic.fromJson(e))
            .toList(),
    );
  }

}

class SubTopic {

  final String title;
  final String content;

  SubTopic({
    required this.title,
    required this.content
});

  factory SubTopic.fromJson(Map<String, dynamic> json){
    return SubTopic(
        title: json['title'],
        content: json['content'],
    );
  }

}