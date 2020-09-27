import 'package:copper_customer/event/record/RecordEvent.dart';

class DeleteRecord extends RecordEvent {
  int recordId;

  DeleteRecord(int index) {
    recordId = index;
  }
}