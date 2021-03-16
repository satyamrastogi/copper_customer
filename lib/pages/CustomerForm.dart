 import 'package:copper_customer/bloc/CustomerBloc.dart';
import 'package:copper_customer/db/DatabaseProviderCustomer.dart';
import 'package:copper_customer/event/customer/AddCustomer.dart';
import 'package:copper_customer/event/customer/SetCustomer.dart';
import 'package:copper_customer/event/customer/UpdateCustomer.dart';
import 'package:copper_customer/model/Customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerForm extends StatefulWidget {
  final Customer customer;
  final int customerIndex;

  CustomerForm({this.customer, this.customerIndex});

  @override
  State<StatefulWidget> createState() {
    return CustomerFormState();
  }
}

class CustomerFormState extends State<CustomerForm> {
  String _name;
  bool _isActive = true;
  int _id;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() {
    return TextFormField(
      initialValue: _name,
      decoration: InputDecoration(labelText: 'Name'),
      maxLength: 15,
      style: TextStyle(fontSize: 28),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  // Widget _buildCalories() {
  //   return TextFormField(
  //     initialValue: _calories,
  //     decoration: InputDecoration(labelText: 'Calories'),
  //     keyboardType: TextInputType.number,
  //     style: TextStyle(fontSize: 28),
  //     validator: (String value) {
  //       int calories = int.tryParse(value);
  //
  //       if (calories == null || calories <= 0) {
  //         return 'Calories must be greater than 0';
  //       }
  //
  //       return null;
  //     },
  //     onSaved: (String value) {
  //       _calories = value;
  //     },
  //   );
  // }

  Widget _buildIsActive() {
    return SwitchListTile(
      title: Text("Active?", style: TextStyle(fontSize: 20)),
      value: _isActive,
      onChanged: (bool newValue) => setState(() {
        _isActive = newValue;
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      _id = widget.customer.id;
      _name = widget.customer.name;
      _isActive = widget.customer.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Form")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              SizedBox(height: 16),
              _buildIsActive(),
              SizedBox(height: 20),
              if (widget.customer == null) RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }

                  _formKey.currentState.save();

                  Customer customer = Customer(
                    name: _name,
                    isActive: _isActive,
                  );

                  DatabaseProvider.db.insert(customer).then(
                        (storedCustomer) => BlocProvider.of<CustomerBloc>(context).add(
                      AddCustomer(storedCustomer),
                    ),
                  );
                  DatabaseProvider.db.getCustomer().then(
                        (customerList) {
                      BlocProvider.of<CustomerBloc>(context).add(SetCustomer(customerList));
                    },
                  );

                  Navigator.pop(context);
                },
              ) else Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        child: RaisedButton(
                          child: Text(
                            "Update",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              print("form");
                              return;
                            }

                            _formKey.currentState.save();

                            Customer customer = Customer(
                              id: _id,
                              name: _name,
                              isActive: _isActive,
                            );

                            DatabaseProvider.db.update(customer).then(
                                  (storedFood) => BlocProvider.of<CustomerBloc>(context).add(
                                UpdateCustomer(customer.id, customer)
                              ),
                            );
                            DatabaseProvider.db.getCustomer().then(
                                  (customerList) {
                                BlocProvider.of<CustomerBloc>(context).add(SetCustomer(customerList));
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
          ),
        ),
      ),
    );
  }
}