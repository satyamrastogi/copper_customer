import 'package:copper_customer/event/customer/CustomerEvent.dart';
import 'package:copper_customer/model/Customer.dart';

class AddCustomer extends CustomerEvent {
  Customer newCustomer;

  AddCustomer(Customer customer) {
    newCustomer = customer;
  }
}