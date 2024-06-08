import 'package:flutter_bloc/flutter_bloc.dart';

class PatientsCubit extends Cubit<Map<String, dynamic>> {
  PatientsCubit() : super({});
  void updatePatients(Map<String, dynamic> newPatients) {
    emit(newPatients);
  }
}
