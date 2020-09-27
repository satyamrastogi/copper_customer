import 'package:copper_customer/event/customer/CustomerEvent.dart';
import 'package:copper_customer/model/Customer.dart';

class SetCustomer extends CustomerEvent {
  List<Customer> customerList;

  SetCustomer(List<Customer> customers) {
    customerList = customers;
  }
}