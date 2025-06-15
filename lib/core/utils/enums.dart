import 'package:flutter/material.dart';

import '../l10n/app_locale.dart';

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
  String displayName(BuildContext context) {
    switch (this) {
      case Status.Active:
        return AppLocalizations.of(context)!.active;
      case Status.DisActive:
        return AppLocalizations.of(context)!.disActive;
      case Status.Busy:
        return AppLocalizations.of(context)!.busy;
    }
  }

  int get value => index;

  static Status fromInt(int val) => Status.values[val];
}
