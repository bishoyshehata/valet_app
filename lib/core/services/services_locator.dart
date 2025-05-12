
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:valet_app/valete/data/datasource/valet_data_source.dart';
import 'package:valet_app/valete/data/repository/repository.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';
import 'package:valet_app/valete/domain/usecases/create_order_use_case.dart';
import 'package:valet_app/valete/domain/usecases/login_use_case.dart';

import '../../valete/domain/usecases/my_garages_use_case.dart';

final sl = GetIt.instance ;

class ServicesLocator {

  void onInit(){

    /// Dio
    sl.registerLazySingleton<Dio>(() => Dio());
    /// DataSources
    sl.registerLazySingleton<IValetDataSource>(() => ValetDataSource(sl()),);
    /// Repository
    sl.registerLazySingleton<IValetRepository>(() => ValetRepository(sl()),);
    /// LoginUseCase
    sl.registerLazySingleton(() => LoginUseCase(sl()),);
    /// CreateOrderUseCase
    sl.registerLazySingleton(() => CreateOrderUseCase(sl()),);
    /// MyGaragesUseCase
    sl.registerLazySingleton(() => MyGaragesUseCase(sl()),);
  }
}