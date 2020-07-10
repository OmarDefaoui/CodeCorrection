class ModelQuestion {
  int index;
  bool isCorrect;
  List<int> items;

  ModelQuestion({this.index, this.isCorrect, this.items});

  ModelQuestion.fromMap(Map<String, dynamic> json)
      : index = json['index'],
        isCorrect = json['isCorrect'],
        items = json['items'].cast<int>();

  Map<String, dynamic> toJson() => {
        'index': index,
        'isCorrect': isCorrect,
        'items': items,
      };
}
