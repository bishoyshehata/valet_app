
import 'package:get_it/get_it.dart';
import 'package:valet_app/valete/data/datasource/valet_data_source.dart';
import 'package:valet_app/valete/data/repository/repository.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';
import 'package:valet_app/valete/domain/usecases/login_use_case.dart';

final sl = GetIt.instance ;

class ServicesLocator {

  void onInit(){

    /// DataSources
    sl.registerLazySingleton<IValetDataSource>(() => ValetDataSource(),);
    /// Repository
    sl.registerLazySingleton<IValetRepository>(() => ValetRepository(sl()),);
    /// NowPlaying UseCases
    sl.registerLazySingleton(() => LoginUseCase(sl()),);
  }
}