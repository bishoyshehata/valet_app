enum RequestState { loading, loaded, error }
enum RequestStatess {initial, loading, loaded, error }

enum StoreOrderState { initial, loading, loaded, error }
enum UpdateOrderSpotState { initial, loading, loaded, error }

enum UpdateOrderState { initial, loading, loaded, error }

enum LogOutState { initial, loaded }

enum LoginStatus { initial, loading, success, error }

enum ReAuthStatus { initial, waitingForPassword, loading, success, error }

enum VehicleType { Car, Motorcycle, Truck, Bus }

enum ImageProcessingStatus { idle, picking, converting, loaded, error }

enum SpotStatus { Empty, Busy, OverFlowEmpty, OverFlowBusy, deleted }
enum Status {
  Active,
  DisActive,
  Busy,
}
extension StatusExtension on Status {
  String get displayName {
    switch (this) {
      case Status.Active:
        return 'متاح';
      case Status.DisActive:
        return 'غير متاح';
      case Status.Busy:
        return 'مشغول';
    }
  }

  int get value => index;

  static Status fromInt(int val) => Status.values[val];
}