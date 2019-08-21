import 'package:code_correction/databases/DBModel.dart';
import 'package:code_correction/databases/dbSeries.dart';
import 'package:flutter/material.dart';
import 'RadioAnswerModel.dart';
import 'RadioItemShape.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CorrectionScreen extends StatefulWidget {
  int length;

  CorrectionScreen(this.length);

  @override
  State<StatefulWidget> createState() {
    return CorrectionScreenState(length);
  }
}

class CorrectionScreenState extends State<CorrectionScreen> {
  List<RadioAnswerModel> radioData = new List<RadioAnswerModel>();
  List<RadioAnswerModel> radioDataCorrection = new List<RadioAnswerModel>();
  int totalMark = 40, length;

  CorrectionScreenState(this.length);

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 40; i++) {
      List<SubRadioModel> subRadioModel = new List<SubRadioModel>();
      subRadioModel.add(new SubRadioModel(false, '1'));
      subRadioModel.add(new SubRadioModel(false, '2'));
      subRadioModel.add(new SubRadioModel(false, '3'));
      subRadioModel.add(new SubRadioModel(false, '4'));

      radioData.add(RadioAnswerModel(i, subRadioModel));
    }

    for (int i = 0; i < 40; i++) {
      List<SubRadioModel> subRadioModel = new List<SubRadioModel>();
      subRadioModel.add(new SubRadioModel(true, 'T'));
      subRadioModel.add(new SubRadioModel(false, 'F'));

      radioDataCorrection.add(RadioAnswerModel(i, subRadioModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Total: $totalMark",
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
      body: Container(
        child: ListView.builder(
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
                        InkWell(
                          splashColor: Colors.blueAccent,
                          onTap: () {
                            setState(() {
                              radioData[index].subRadioModel[0].isSelected =
                                  !radioData[index].subRadioModel[0].isSelected;
                            });
                          },
                          child:
                              RadioItemShape(radioData[index].subRadioModel[0]),
                        ),
                        InkWell(
                          splashColor: Colors.blueAccent,
                          onTap: () {
                            setState(() {
                              radioData[index].subRadioModel[1].isSelected =
                                  !radioData[index].subRadioModel[1].isSelected;
                            });
                          },
                          child:
                              RadioItemShape(radioData[index].subRadioModel[1]),
                        ),
                        InkWell(
                          splashColor: Colors.blueAccent,
                          onTap: () {
                            setState(() {
                              radioData[index].subRadioModel[2].isSelected =
                                  !radioData[index].subRadioModel[2].isSelected;
                            });
                          },
                          child:
                              RadioItemShape(radioData[index].subRadioModel[2]),
                        ),
                        InkWell(
                          splashColor: Colors.blueAccent,
                          onTap: () {
                            setState(() {
                              radioData[index].subRadioModel[3].isSelected =
                                  !radioData[index].subRadioModel[3].isSelected;
                            });
                          },
                          child:
                              RadioItemShape(radioData[index].subRadioModel[3]),
                        ),
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
                              color: radioDataCorrection[index]
                                      .subRadioModel[0]
                                      .isSelected
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                radioDataCorrection[index]
                                    .subRadioModel
                                    .forEach((subRadioModel) {
                                  subRadioModel.isSelected =
                                      !subRadioModel.isSelected;

                                  calculateTotal();
                                });
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
                                color: radioDataCorrection[index]
                                        .subRadioModel[1]
                                        .isSelected
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                radioDataCorrection[index]
                                    .subRadioModel
                                    .forEach((subRadioModel) {
                                  subRadioModel.isSelected =
                                      !subRadioModel.isSelected;

                                  calculateTotal();
                                });
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
          itemCount: 40,
        ),
      ),
    );
  }

  void calculateTotal() {
    totalMark = 0;
    radioDataCorrection.forEach((s) {
      if (s.subRadioModel[0].isSelected) {
        setState(() {
          totalMark += 1;
        });
      }
    });
  }

  void saveDataToDB() async {
    DataBaseHelper dataBaseHelper = DataBaseHelper();

    String date =
        DateFormat("EEE d MMM kk:mm").format(DateTime.now()).toString();
    DBModel dbModel =
        DBModel("Serie ${length + 1}", totalMark.toString(), date);

    int result = await dataBaseHelper.insertTest(dbModel);

    if (result != 0) {
      print("saved");
      Navigator.pop(context);
    } else {
      print("Error during saving");
    }
  }
}
