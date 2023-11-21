import 'package:medic/model/medicine_data.dart';
import 'package:medic/model/order_data.dart';
import 'package:medic/model/user_address.dart';

class OrderWithMedicines {
  OrderData orderData;
  List<MedicineData> medicines;
  UserAddress? address;

  OrderWithMedicines({
    required this.orderData,
    required this.medicines,
    this.address,
  });
}
