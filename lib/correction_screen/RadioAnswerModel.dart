class RadioAnswerModel {
  int index;
  List<SubRadioModel> subRadioModel;

  RadioAnswerModel(this.index, this.subRadioModel);
}

class SubRadioModel {
  bool isSelected;
  final String btnText;

  SubRadioModel(this.isSelected, this.btnText);
}
