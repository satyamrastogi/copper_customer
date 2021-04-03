import 'package:copper_customer/bloc/RecordBloc.dart';
import 'package:copper_customer/component/BasicComponent.dart';
import 'package:copper_customer/db/DatabaseProviderRecord.dart';
import 'package:copper_customer/event/record/AddRecord.dart';
import 'package:copper_customer/event/record/SetRecord.dart';
import 'package:copper_customer/event/record/UpdateRecord.dart';
import 'package:copper_customer/model/Customer.dart';
import 'package:copper_customer/model/Record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecordForm extends StatefulWidget {
  final Customer customer;
  final Record record;
  final int recordIndex;

  RecordForm({this.customer, this.record, this.recordIndex});

  @override
  State<StatefulWidget> createState() {
    return RecordFormState();
  }
}

class RecordFormState extends State<RecordForm> {
  String _customerName;
  String _customerGstNumber;
  String _customerPhoneNumber;
  int _id;
  double _price;
  double _length;
  double _cooper_wire_size;
  double _total_price;
  DateTime selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void>  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
  Widget _buildPrice() {
    return TextFormField(
      initialValue: _price == null ? "" : _price.toString(),
      decoration: InputDecoration(labelText: 'Price ₹'),
      maxLength: 15,
      style: TextStyle(fontSize: 18),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Price is Required';
        }
        if(double.tryParse(value) == null) {
          return 'Enter Number';
        }
        return null;
      },
      onSaved: (String value) {
        _price = double.parse(value);
      },
    );
  }

  Widget _buildLength() {
    return TextFormField(
      initialValue: _length == null ? "" : _length.toString(),
      decoration: InputDecoration(labelText: 'Length  M'),
      maxLength: 15,
      style: TextStyle(fontSize: 18),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Length is Required';
        }
        if(double.tryParse(value) == null) {
          return 'Enter Number';
        }
        return null;
      },
      onSaved: (String value) {
        _length = double.parse(value);
      },
    );
  }

  Widget _buildCopperWireSize() {
    return TextFormField(
      initialValue:
          _cooper_wire_size == null ? "" : _cooper_wire_size.toString(),
      decoration: InputDecoration(labelText: 'Wire size  MM'),
      maxLength: 15,
      style: TextStyle(fontSize: 18),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Size is Required';
        }
        if(double.tryParse(value) == null) {
          return 'Enter Number';
        }
        return null;
      },
      onSaved: (String value) {
        _cooper_wire_size = double.parse(value);
      },
    );
  }

  Widget _buildCustomerDetail() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        BasicComponent.boxWithText("Name: $_customerName"),
        BasicComponent.getBasicDivider(),
        BasicComponent.boxWithPhoneNumber(_customerPhoneNumber),
        BasicComponent.getBasicDivider(),
        BasicComponent.boxWithText("GST Number: $_customerGstNumber"),
        BasicComponent.getBasicDivider(),
        SizedBox(height: 50.0,)
      ],
    );
  }
  //
  // Widget _buildCGSTPercentage() {
  //   return TextFormField(
  //     initialValue: _cgst_percentage == null ? "" : _cgst_percentage.toString(),
  //     decoration: InputDecoration(labelText: 'CGST'),
  //     maxLength: 15,
  //     style: TextStyle(fontSize: 18),
  //       validator: (String value) {
  //         if(double.tryParse(value) == null) {
  //           return 'Enter Number';
  //         }
  //         return null;
  //       },
  //     onSaved: (String value) {
  //       if (value.isNotEmpty) {
  //         _cgst_percentage = double.parse(value);
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _customerName = widget.customer.name;
      _customerGstNumber = widget.customer.gstNumber == null ? "NA" : widget.customer.gstNumber;
      _customerPhoneNumber = widget.customer.phoneNumber ==  null ? "NA" : widget.customer.phoneNumber;
    }
    if (widget.record != null) {
      _id = widget.record.id;
      _price = widget.record.price;
      _cooper_wire_size = widget.record.copperWireSize;
      _length = widget.record.length;
      _total_price = widget.record.totalPrice;
      if (widget.record.recordDate != null)
        selectedDate = DateTime.parse(widget.record.recordDate);
      else
        selectedDate = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Record Form")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: new SingleChildScrollView(
              child: Column(
            children: <Widget>[
              _buildCustomerDetail(),
              _buildCopperWireSize(),
              _buildLength(),
              _buildPrice(),
              Text("${selectedDate.toLocal()}".split(' ')[0]),
              SizedBox(height: 20.0,),
              RaisedButton(
                child: Text(
                  'Select date',
                  style: TextStyle(color: Colors.blue, fontSize: 10),
                ),
                onPressed: () => _selectDate(context),
              ),
              SizedBox(height: 10),
              if (widget.record == null)
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 10),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();
                    _total_price = _cooper_wire_size * _length * _price;
                    DateTime createdAt = DateTime.now().toLocal();
                    DateTime recordDate = selectedDate.toLocal();
                    Record record = Record(
                        copperWireSize: _cooper_wire_size,
                        createdAt: "$createdAt".split(' ')[0],
                        recordDate: "$recordDate".split(' ')[0],
                        length: _length,
                        price: _price,
                        totalPrice: _total_price,
                        customerId: widget.customer.id);
                    DatabaseProviderRecord.db.insert(record).then(
                          (storedRecord) =>
                              BlocProvider.of<RecordBloc>(context).add(
                            AddRecord(storedRecord),
                          ),
                        );
                    DatabaseProviderRecord.db.getRecord(widget.customer.id).then(
                          (recordList) {
                        BlocProvider.of<RecordBloc>(context).add(SetRecord(recordList));
                      },
                    );

                    Navigator.pop(context);
                  },
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          child: RaisedButton(
                            child: Text(
                              "Update",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                            onPressed: () {
                              if (!_formKey.currentState.validate()) {
                                print("form");
                                return;
                              }

                              _formKey.currentState.save();
                              _total_price = _cooper_wire_size * _length * _price;
                              DateTime recordDate = selectedDate.toLocal();
                              Record record = Record(
                                  id: _id,
                                  copperWireSize: _cooper_wire_size,
                                  length: _length,
                                  price: _price,
                                  totalPrice: _total_price,
                                  customerId: widget.customer.id,
                                  recordDate: "$recordDate".split(' ')[0]);
                              DatabaseProviderRecord.db
                                  .update(record)
                                  .then(
                                    (storedRecord) =>
                                        BlocProvider.of<RecordBloc>(context)
                                            .add(
                                      UpdateRecord(
                                          record.id, record),
                                    ),
                                  );
                              DatabaseProviderRecord.db.getRecord(widget.customer.id).then(
                                    (recordList) {
                                  BlocProvider.of<RecordBloc>(context).add(SetRecord(recordList));
                                },
                              );

                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
            ],
          )),
        ),
      ),
    );
  }
}
