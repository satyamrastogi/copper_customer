import 'package:copper_customer/event/customer/CustomerEvent.dart';
import 'package:copper_customer/model/Customer.dart';

class UpdateCustomer extends CustomerEvent {
  Customer newCustomer;
  int customerId;

  UpdateCustomer(int index, Customer customer) {
    newCustomer = customer;
    customerId = index;
  }
}