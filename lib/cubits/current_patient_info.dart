import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentPatientInfo extends Cubit<Map<String, dynamic>> {
  CurrentPatientInfo() : super({});
  void updateData(Map<String, dynamic> patientData) {
    emit(patientData);
  }

  void reset() {
    emit({});
  }
}
