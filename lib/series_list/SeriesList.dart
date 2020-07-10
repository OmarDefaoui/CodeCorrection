import 'dart:convert';

import 'package:code_correction/correction_screen/CorrectionScreen.dart';
import 'package:code_correction/correction_screen/RadioAnswerModel.dart';
import 'package:code_correction/databases/DBModel.dart';
import 'package:flutter/material.dart';
import 'package:code_correction/databases/dbSeries.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeriesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SeriesListState();
  }
}

class SeriesListState extends State<SeriesList> {
  DataBaseHelper dataBaseHelper = DataBaseHelper();
  String deletedItemName;
  int seriesListLenght = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Series"),
        /*actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              setState(() {
                dataBaseHelper.deleteAll();
              });
            },
          )
        ],*/
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CorrectionScreen(
                length: seriesListLenght,
                onClose: () => setState(() {}),
                answers: [],
              ),
            ),
          );
        },
      ),
      body: Container(
        child: listViewData(),
      ),
    );
  }

  Widget listViewData() {
    return FutureBuilder<List<DBModel>>(
        future: getDataListFromDB(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data.length == 0) {
            return Center(
              child: Image.asset(
                'images/empty.png',
                alignment: Alignment.center,
              ),
            );
          }

          List<DBModel> seriesList = snapshot.data;
          return ListView.builder(
            itemCount: seriesList.length,
            itemBuilder: (context, index) {
              DBModel serie = seriesList[index];
              return Dismissible(
                // Show a red background as the item is swiped away.
                background: Container(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(20)),
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                key: UniqueKey(),
                onDismissed: (direction) {
                  seriesListLenght -= 1;
                  setState(() {
                    seriesList.removeAt(index);
                    dataBaseHelper.deleteTest(serie.id);
                    deletedItemName = serie.name;
                  });

                  Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text("$deletedItemName deleted")));
                },
                direction: DismissDirection.endToStart,
                child: ListTile(
                  title: Text(serie.name),
                  subtitle: Text(serie.date),
                  leading: Container(
                    width: ScreenUtil.getInstance().setWidth(150),
                    height: ScreenUtil.getInstance().setHeight(150),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: Border.all(
                        color: Colors.black,
                        width: ScreenUtil.getInstance().setWidth(2),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        serie.mark,
                        style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(50),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    if (serie.answers.isNotEmpty)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CorrectionScreen(
                            id: serie.id,
                            length: int.parse(serie.name.split(' ')[1]),
                            onClose: () => setState(() {}),
                            answers: (jsonDecode(serie.answers) as List)
                                .map((item) => ModelQuestion.fromMap(item))
                                .toList(),
                          ),
                        ),
                      );
                  },
                ),
              );
            },
          );
        });
  }

  Future<List<DBModel>> getDataListFromDB() async {
    await dataBaseHelper.initializeDB();
    List<DBModel> seriesList = await dataBaseHelper.getTestsList();
    seriesListLenght = seriesList.length;
    print('seriesList length: $seriesListLenght');

    return seriesList;
  }
}
