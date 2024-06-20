import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedVitalsChart extends Cubit<Map<String, dynamic>> {
  SelectedVitalsChart() : super({});
  void updateData(Map<String, dynamic> careChartData) {
    emit(careChartData);
  }
}
