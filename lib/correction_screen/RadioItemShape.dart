import 'package:flutter/material.dart';
import 'RadioAnswerModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioItemShape extends StatelessWidget {
  final SubRadioModel _item;

  RadioItemShape(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(10),
        bottom: ScreenUtil().setHeight(10),
        left: ScreenUtil().setWidth(10),
        right: ScreenUtil().setWidth(10),
      ),
      child: Container(
        height: ScreenUtil.getInstance().setHeight(80),
        width: ScreenUtil.getInstance().setWidth(80),
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(10),
          bottom: ScreenUtil().setHeight(10),
          left: ScreenUtil().setWidth(10),
          right: ScreenUtil().setWidth(10),
        ),
        decoration: BoxDecoration(
          color: _item.isSelected ? Colors.blueAccent : Colors.transparent,
          border: Border.all(
            width: ScreenUtil.getInstance().setWidth(1),
            color: _item.isSelected ? Colors.blueAccent : Colors.black,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(90),
          ),
        ),
        child: Center(
          child: Text(
            _item.btnText,
            style: TextStyle(
              color: _item.isSelected ? Colors.white : Colors.black,
              fontSize: ScreenUtil.getInstance().setSp(50),
            ),
          ),
        ),
      ),
    );
  }
}
