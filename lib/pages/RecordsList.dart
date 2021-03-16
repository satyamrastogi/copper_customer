import 'package:copper_customer/bloc/RecordBloc.dart';
import 'package:copper_customer/db/DatabaseProviderRecord.dart';
import 'package:copper_customer/event/record/DeleteRecord.dart';
import 'package:copper_customer/event/record/SetRecord.dart';
import 'package:copper_customer/model/Customer.dart';
import 'package:copper_customer/model/Record.dart';
import 'package:copper_customer/pages/RecordForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordsList extends StatefulWidget {
  final Customer customer;

  const RecordsList({Key key, @required this.customer}) : super(key: key);

  @override
  _RecordListState createState() => _RecordListState(customer);
}

class _RecordListState extends State<RecordsList> {
  final Customer customer;

  _RecordListState(this.customer);

  @override
  void initState() {
    super.initState();
    DatabaseProviderRecord.db.getRecord(customer.id).then(
      (recordList) {
        BlocProvider.of<RecordBloc>(context).add(SetRecord(recordList));
      },
    );
  }

  showRecordDialog(
      BuildContext context, Customer customer, Record record, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer.name),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RecordForm(
                    customer: customer, record: record, recordIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () =>
                DatabaseProviderRecord.db.delete(record.id).then((_) {
              BlocProvider.of<RecordBloc>(context).add(
                DeleteRecord(index),
              );
              Navigator.pop(context);
            }),
            child: Text("Delete"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var customerName = customer.name;
    print("Building entire Record list scaffold");
    return Scaffold(
      appBar: AppBar(title: Text("Record List $customerName")),
      body: Container(
        child: BlocConsumer<RecordBloc, List<Record>>(
          builder: (context, recordList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("recordList: $recordList");
                Record record = recordList[index];
                return ListTile(
                    title: Text(
                        "Width : " +
                            record.copperWireSize.toString() +
                            ", Length : " +
                            record.length.toString() +
                            ", Price :" +
                            record.price.toString(),
                        style: TextStyle(fontSize: 18)),
                    subtitle: Text(" order date :" +
                        record.recordDate +
                        " Total Price : " +
                        record.totalPrice.toString()),
                    onLongPress: () =>
                        showRecordDialog(context, customer, record, record.id));
              },
              itemCount: recordList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, recordList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  RecordForm(customer: customer)),
        ),
      ),
    );
  }

  String _getZeroIfNull(double value) {
    if (value == null) return "0";
    return value.toString();
  }
}
