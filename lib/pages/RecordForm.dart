import 'package:copper_customer/bloc/RecordBloc.dart';
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
  int _id;
  double _price;
  double _length;
  double _cooper_wire_size;
  double _gst_percentage;
  double _cgst_percentage;
  double _total_price;
  double _cgst_price = 0;
  double _gst_price = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  Widget _buildGSTPercentage() {
    return TextFormField(
      initialValue: _gst_percentage == null ? "" : _gst_percentage.toString(),
      decoration: InputDecoration(labelText: 'GST'),
      maxLength: 15,
      style: TextStyle(fontSize: 18),
        validator: (String value) {
          if(double.tryParse(value) == null) {
            return 'Enter Number';
          }
          return null;
        },
      onSaved: (String value) {
        if (value.isNotEmpty) {
          _gst_percentage = double.parse(value);
        }
      },
    );
  }

  Widget _buildCGSTPercentage() {
    return TextFormField(
      initialValue: _cgst_percentage == null ? "" : _cgst_percentage.toString(),
      decoration: InputDecoration(labelText: 'CGST'),
      maxLength: 15,
      style: TextStyle(fontSize: 18),
        validator: (String value) {
          if(double.tryParse(value) == null) {
            return 'Enter Number';
          }
          return null;
        },
      onSaved: (String value) {
        if (value.isNotEmpty) {
          _cgst_percentage = double.parse(value);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _customerName = widget.customer.name;
    }
    if (widget.record != null) {
      _id = widget.record.id;
      _price = widget.record.price;
      _gst_percentage = widget.record.gstPercentage;
      _cgst_percentage = widget.record.cgstPercentage;
      _cooper_wire_size = widget.record.copperWireSize;
      _length = widget.record.length;
      _total_price = widget.record.totalPrice;
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildCopperWireSize(),
              _buildLength(),
              _buildPrice(),
              _buildGSTPercentage(),
              _buildCGSTPercentage(),
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
                    if (_cgst_percentage != null)
                      _cgst_price += _total_price * _cgst_percentage / 100;
                    if (_gst_percentage != null)
                      _gst_price += _total_price * _gst_percentage / 100;
                    _total_price += _cgst_price + _gst_price;
                    Record record = Record(
                        copperWireSize: _cooper_wire_size,
                        cgstPercentage: _cgst_percentage,
                        gstPercentage: _gst_percentage,
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
                              if (_cgst_percentage != null)
                                _cgst_price += _total_price * _cgst_percentage / 100;
                              if (_gst_percentage != null)
                                _gst_price += _total_price * _gst_percentage / 100;
                              _total_price += _cgst_price + _gst_price;
                              Record record = Record(
                                  id: _id,
                                  copperWireSize: _cooper_wire_size,
                                  cgstPercentage: _cgst_percentage,
                                  gstPercentage: _gst_percentage,
                                  length: _length,
                                  price: _price,
                                  totalPrice: _total_price,
                                  customerId: widget.customer.id);
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
