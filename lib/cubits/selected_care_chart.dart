import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedCareChart extends Cubit<Map<String, dynamic>> {
  SelectedCareChart() : super({});
  void updateData(Map<String, dynamic> careChartData) {
    emit(careChartData);
  }
}
