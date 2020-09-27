import 'package:copper_customer/event/record/AddRecord.dart';
import 'package:copper_customer/event/record/DeleteRecord.dart';
import 'package:copper_customer/event/record/RecordEvent.dart';
import 'package:copper_customer/event/record/SetRecord.dart';
import 'package:copper_customer/event/record/UpdateRecord.dart';
import 'package:copper_customer/model/Record.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordBloc extends Bloc<RecordEvent, List<Record>> {
  @override
  List<Record> get initialState => List<Record>();

  @override
  Stream<List<Record>> mapEventToState(RecordEvent event) async* {
    if (event is SetRecord) {
      yield event.recordList;
    } else if (event is AddRecord) {
      List<Record> newState = List.from(state);
      if (event.newRecord != null) {
        newState.add(event.newRecord);
      }
      yield newState;
    } else if (event is DeleteRecord) {
      List<Record> newState = List.from(state);
      newState.removeAt(event.recordId);
      yield newState;
    } else if (event is UpdateRecord) {
      List<Record> newState = List.from(state);
      newState[event.recordId] = event.newRecord;
      yield newState;
    }
  }
}