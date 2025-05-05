import 'package:autis/core/errors/failures.dart';
import 'package:autis/src/common/models/user_model.dart';

import '../../../../core/types/either.dart';

abstract class RemoteDataSource {
  Future<Either<Failure, UserModel>> fetchPatient(String userId);
  Future<Either<Failure, UserModel>> fetchUserDataByEmail(String email);
  Future<Either<Failure, UserModel>> fetchUserDataById(String phone);
  Future<Either<Failure, UserModel>> addNewReport(String id, String reportId);
  Future<Either<Failure, UserModel>> deleteReport(String id, String reportId);
  Future<Either<Failure, UserModel>> updateReport(String id, String reportId);
  Future<Either<Failure, UserModel>> fetchReport(String id, String reportId);
  Future<Either<Failure, UserModel>> fetchAllReports(String id);
  Future<Either<Failure, UserModel>> fetchAllReportsById(String id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  @override
  Future<Either<Failure, UserModel>> addNewReport(String id, String reportId) {
    // TODO: implement addNewReport
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> deleteReport(String id, String reportId) {
    // TODO: implement deleteReport
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> fetchAllReports(String id) {
    // TODO: implement fetchAllReports
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> fetchAllReportsById(String id) {
    // TODO: implement fetchAllReportsById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> fetchPatient(String userId) {
    // TODO: implement fetchPatient
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> fetchReport(String id, String reportId) {
    // TODO: implement fetchReport
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> fetchUserDataByEmail(String email) {
    // TODO: implement fetchUserDataByEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> fetchUserDataById(String phone) {
    // TODO: implement fetchUserDataById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> updateReport(String id, String reportId) {
    // TODO: implement updateReport
    throw UnimplementedError();
  }
}
