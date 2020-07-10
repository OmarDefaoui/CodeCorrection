import 'dart:convert';

import 'package:code_correction/models/model_serie.dart';
import 'package:code_correction/databases/db_series.dart';
import 'package:code_correction/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../models/model_question.dart';
import '../widgets/answers_box.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SerieCorrectionScreen extends StatefulWidget {
  final int id, length;
  final VoidCallback onClose;
  final List<ModelQuestion> answers;
  SerieCorrectionScreen({this.id, this.length, this.onClose, this.answers});

  @override
  State<StatefulWidget> createState() {
    return SerieCorrectionScreenState(length);
  }
}

class SerieCorrectionScreenState extends State<SerieCorrectionScreen> {
  List<ModelQuestion> modelQuestion = new List<ModelQuestion>();
  int totalMark = 40, length;
  var lang;

  SerieCorrectionScreenState(this.length);

  @override
  void initState() {
    super.initState();

    if (widget.answers.isEmpty)
      for (int i = 0; i < 40; i++) {
        modelQuestion
            .add(new ModelQuestion(index: i, isCorrect: true, items: []));
      }
    else
      modelQuestion = widget.answers;

    calculateTotal();
  }

  @override
  void deactivate() {
    try {
      widget.onClose();
    } catch (e) {
      print('error in widget.onClose()');
    }

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () => onBackPressed(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${lang.translate('total')}: $totalMark",
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveDataToDB();
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: 40,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: ScreenUtil.getInstance().setWidth(150),
                    height: ScreenUtil.getInstance().setHeight(150),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(
                        color: Colors.black,
                        width: ScreenUtil.getInstance().setWidth(2),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(180),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(60),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: ScreenUtil.getInstance().setWidth(60),
                    height: ScreenUtil.getInstance().setHeight(2),
                    color: Colors.black,
                  ),
                  Container(
                    width: ScreenUtil.getInstance().setWidth(490),
                    height: ScreenUtil.getInstance().setHeight(150),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(
                        color: Colors.black,
                        width: ScreenUtil.getInstance().setWidth(2),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(45),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        choiceOption(index, 0),
                        choiceOption(index, 1),
                        choiceOption(index, 2),
                        choiceOption(index, 3),
                      ],
                    ),
                  ),
                  Container(
                    width: ScreenUtil.getInstance().setWidth(60),
                    height: ScreenUtil.getInstance().setHeight(2),
                    color: Colors.black,
                  ),
                  Container(
                    width: ScreenUtil.getInstance().setWidth(260),
                    height: ScreenUtil.getInstance().setHeight(150),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(
                        color: Colors.black,
                        width: ScreenUtil.getInstance().setWidth(2),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(45),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: modelQuestion[index].isCorrect
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                modelQuestion[index].isCorrect =
                                    !modelQuestion[index].isCorrect;

                                calculateTotal();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Transform.rotate(
                              angle: 3.14 / 4,
                              child: Icon(
                                Icons.add_circle,
                                color: modelQuestion[index].isCorrect
                                    ? Colors.grey
                                    : Colors.red,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                modelQuestion[index].isCorrect =
                                    !modelQuestion[index].isCorrect;

                                calculateTotal();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget choiceOption(int index, int choice) => InkWell(
        splashColor: Colors.blueAccent,
        onTap: () {
          setState(() {
            if (modelQuestion[index].items.contains(choice))
              modelQuestion[index].items.remove(choice);
            else
              modelQuestion[index].items.add(choice);
          });
        },
        child: AnswersBox(
          choice: choice,
          isCorrect: modelQuestion[index].items.contains(choice),
        ),
      );

  void calculateTotal() {
    totalMark = 0;
    modelQuestion.forEach((s) {
      if (s.isCorrect) {
        setState(() {
          totalMark += 1;
        });
      }
    });
  }

  void saveDataToDB() async {
    DataBaseHelper dataBaseHelper = DataBaseHelper();

    String answers =
        jsonEncode(modelQuestion.map((item) => item.toJson()).toList());
    String date = DateFormat("EEE d MMM kk:mm", lang.languageCode)
        .format(DateTime.now())
        .toString();
    ModelSerie dbModel = ModelSerie(
        widget.id,
        "${lang.translate('serie')} ${length + 1}",
        totalMark.toString(),
        date,
        answers);

    int result;
    if (widget.answers.isEmpty)
      result = await dataBaseHelper.insertTest(dbModel);
    else
      result = await dataBaseHelper.updateTest(dbModel);

    if (result != 0) {
      print("saved");
      Navigator.pop(context);
    } else {
      print("Error during saving");
    }
  }

  //to allow go back return true, otherwise return false
  Future<bool> onBackPressed() async {
    print('on back pressed');

    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(lang.translate('confirmation')),
            content: Text(lang.translate('confirmation_message')),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(lang.translate('yes')),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(lang.translate('no')),
              ),
            ],
          ),
        ) ??
        false;
  }
}
