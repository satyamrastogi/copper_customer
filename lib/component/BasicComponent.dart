import 'package:copper_customer/event/default/CallTextMessage.dart';
import 'package:copper_customer/service/ServiceLocator.dart';
import 'package:flutter/material.dart';

class BasicComponent{
  static final CallsAndMessagesService _service = locator<CallsAndMessagesService>();

  static Divider getBasicDivider() {
    return Divider(
      height: 20,
      thickness: 2,
      indent: 20,
      endIndent: 20,
    );
  }

  static SizedBox boxWithText(String text){
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: Container(
        child: Text(text,style: TextStyle(fontSize: 18),),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  static SizedBox boxWithPhoneNumber(String number,){
    return SizedBox(
      width: double.infinity,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text("Phone Number: $number",
              style: TextStyle(fontSize: 18),),
            alignment: Alignment.centerLeft,
          ),
          Container(
              child:RaisedButton(
                child: Text("call"),
                  onPressed: () => BasicComponent._service.call(number)),
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

}