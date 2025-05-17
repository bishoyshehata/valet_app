import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:valet_app/valete/data/datasource/valet_data_source.dart';
import 'package:valet_app/valete/data/repository/repository.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import 'package:valet_app/valete/domain/usecases/login_use_case.dart';

import '../../valete/domain/usecases/my_garages_use_case.dart';
import '../../valete/domain/usecases/my_orders_use_case.dart';
import '../../valete/domain/usecases/store_order_use_case.dart';
import '../../valete/domain/usecases/update_order_status_use_case.dart';
import '../../valete/presentation/controllers/home/home_bloc.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void onInit() {
    /// Dio
    sl.registerLazySingleton<Dio>(() => Dio());

    /// HomeBloc
    sl.registerLazySingleton<HomeBloc>(
      () => HomeBloc(sl<MyGaragesUseCase>(), sl<MyOrdersUseCase>(),sl<UpdateOrderStatusUseCase>()),
    );

    /// DataSources
    sl.registerLazySingleton<IValetDataSource>(() => ValetDataSource(sl()));

    /// Repository
    sl.registerLazySingleton<IValetRepository>(() => ValetRepository(sl()));

    /// LoginUseCase
    sl.registerLazySingleton(() => LoginUseCase(sl()));

    /// CreateOrderUseCase
    sl.registerLazySingleton(() => CreateOrderUseCase(sl()));

    /// MyGaragesUseCase
    sl.registerLazySingleton(() => MyGaragesUseCase(sl()));

    /// StoreOrderUseCase
    sl.registerLazySingleton(() => StoreOrderUseCase(sl()));

    /// MYOrdersUseCase
    sl.registerLazySingleton(() => MyOrdersUseCase(sl()));
    /// UpdateOrderStatusUseCase
    sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));
  }
}
