import 'package:copper_customer/event/customer/CustomerEvent.dart';

class DeleteCustomer extends CustomerEvent {
  int customerId;

  DeleteCustomer(int index) {
    customerId = index;
  }
}