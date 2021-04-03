import 'package:copper_customer/bloc/CustomerBloc.dart';
import 'package:copper_customer/bloc/RecordBloc.dart';
import 'package:copper_customer/pages/CustomerList.dart';
import 'package:copper_customer/service/ServiceLocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return BlocProvider<CustomerBloc>(
    create: (context) => CustomerBloc(),
    child : BlocProvider<RecordBloc>(
      create: (context) => RecordBloc(),
        child: MaterialApp(
          title: 'Customer Record',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: CustomerList(),
        )
    )
    ,
  );
}
}
