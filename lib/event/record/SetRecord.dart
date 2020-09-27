import 'package:copper_customer/event/record/RecordEvent.dart';
import 'package:copper_customer/model/Record.dart';

class SetRecord extends RecordEvent {
  List<Record> recordList;

  SetRecord(List<Record> records) {
    recordList = records;
  }
}