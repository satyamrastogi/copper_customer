import 'package:copper_customer/event/record/RecordEvent.dart';
import 'package:copper_customer/model/Record.dart';

class UpdateRecord extends RecordEvent {
  Record newRecord;
  int recordId;

  UpdateRecord(int index, Record record) {
    newRecord = record;
    recordId = index;
  }
}