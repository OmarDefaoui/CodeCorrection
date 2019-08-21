import 'package:code_correction/correction_screen/CorrectionScreen.dart';
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
  List<DBModel> dbModel = List();
  String deletedItemName;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Séries"),
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
              builder: (context) => CorrectionScreen(dbModel.length),
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
    getDataListFromDB();
    return ListView.builder(
      itemCount: dbModel.length,
      itemBuilder: (context, index) {
        return Dismissible(
          // Show a red background as the item is swiped away.
          background: Container(
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          key: Key(dbModel[index].id.toString()),
          onDismissed: (direction) {
            setState(() {
              deletedItemName = dbModel[index].name;
              dataBaseHelper.deleteTest(dbModel[index].id);
              dbModel.removeAt(index);
            });

            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("$deletedItemName supprimée")));
          },
          direction: DismissDirection.endToStart,
          child: ListTile(
            title: Text(dbModel[index].name),
            subtitle: Text(dbModel[index].date),
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
                  dbModel[index].mark,
                  style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(50),
                  ),
                ),
              ),
            ),
            onTap: () {
              print("${dbModel[index].id}");
            },
          ),
        );
      },
    );
  }

  void getDataListFromDB() {
    Future dbFuture = dataBaseHelper.initializeDB();
    dbFuture.then((database) {
      Future noteListFuture = dataBaseHelper.getTestsList();
      noteListFuture.then((data) {
        setState(() {
          dbModel = data;
        });
      });
    });
  }
}
