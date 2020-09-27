import 'package:copper_customer/bloc/CustomerBloc.dart';
import 'package:copper_customer/db/DatabaseProviderCustomer.dart';
import 'package:copper_customer/event/customer/DeleteCustomer.dart';
import 'package:copper_customer/event/customer/SetCustomer.dart';
import 'package:copper_customer/model/Customer.dart';
import 'package:copper_customer/pages/CustomerForm.dart';
import 'package:copper_customer/pages/RecordsList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getCustomer().then(
      (customerList) {
        BlocProvider.of<CustomerBloc>(context).add(SetCustomer(customerList));
      },
    );
  }

  showCustomerDialog(BuildContext context, Customer customer, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer.name),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CustomerForm(customer: customer, customerIndex: index),
              ),
            ),
            child: Text("Update"),
          ),
          FlatButton(
            onPressed: () => DatabaseProvider.db.delete(customer.id).then((_) {
              BlocProvider.of<CustomerBloc>(context).add(
                DeleteCustomer(index),
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
    print("Building entire Customer list scaffold");
    return Scaffold(
      appBar: AppBar(title: Text("Customer List")),
      body: Container(
        child: BlocConsumer<CustomerBloc, List<Customer>>(
          builder: (context, customerList) {
            return ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                print("CustomerList: $customerList");
                Customer customer = customerList[index];
                return ListTile(
                    title: Text(customer.name, style: TextStyle(fontSize: 30)),
                    onLongPress: () =>
                        showCustomerDialog(context, customer, index),
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RecordsList(customer: customer)),
                        ));
              },
              itemCount: customerList.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: Colors.black),
            );
          },
          listener: (BuildContext context, foodList) {},
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => CustomerForm()),
        ),
      ),
    );
  }
}
