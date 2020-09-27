
import 'package:copper_customer/model/Record.dart';

import 'RecordEvent.dart';

class AddRecord extends RecordEvent {
  Record newRecord;

  AddRecord(Record record) {
    newRecord = record;
  }
}