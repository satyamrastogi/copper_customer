
import 'package:copper_customer/db/DatabaseProviderCustomer.dart';

class Customer{
  int id;
  String name;
  bool isActive;


  Customer({this.id,this.name, this.isActive});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.NAME: name,
      DatabaseProvider.IS_ACTIVE: isActive ? 1 : 0
    };

    if (id != null) {
      map[DatabaseProvider.CUSTOMER_ID] = id;
    }

    return map;
  }

  Customer.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.CUSTOMER_ID];
    name = map[DatabaseProvider.NAME];
    isActive = map[DatabaseProvider.IS_ACTIVE] == 1;
  }
}