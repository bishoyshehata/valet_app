import 'package:dartz/dartz.dart';
import 'package:valet_app/core/error/failure.dart';
import 'package:valet_app/valete/domain/entities/valet.dart';
import 'package:valet_app/valete/domain/repository/Repository.dart';

class LoginUseCase {
final IValetRepository repository ;
 LoginUseCase(this.repository);

 Future<Either<Failure , Valet>> login(String phone , String password)async{
return await repository.login(phone, password);
 }

}