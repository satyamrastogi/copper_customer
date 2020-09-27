import 'package:copper_customer/event/customer/AddCustomer.dart';
import 'package:copper_customer/event/customer/CustomerEvent.dart';
import 'package:copper_customer/event/customer/DeleteCustomer.dart';
import 'package:copper_customer/event/customer/SetCustomer.dart';
import 'package:copper_customer/event/customer/UpdateCustomer.dart';
import 'package:copper_customer/model/Customer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerBloc extends Bloc<CustomerEvent, List<Customer>> {
  @override
  List<Customer> get initialState => List<Customer>();

  @override
  Stream<List<Customer>> mapEventToState(CustomerEvent event) async* {
    if (event is SetCustomer) {
      yield event.customerList;
    } else if (event is AddCustomer) {
      List<Customer> newState = List.from(state);
      if (event.newCustomer != null) {
        newState.add(event.newCustomer);
      }
      yield newState;
    } else if (event is DeleteCustomer) {
      List<Customer> newState = List.from(state);
      newState.removeAt(event.customerId);
      yield newState;
    } else if (event is UpdateCustomer) {
      List<Customer> newState = List.from(state);
      newState[event.customerId] = event.newCustomer;
      yield newState;
    }
  }
}