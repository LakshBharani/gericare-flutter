import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedEmotionChart extends Cubit<Map<String, dynamic>> {
  SelectedEmotionChart() : super({});
  void updateData(Map<String, dynamic> careChartData) {
    emit(careChartData);
  }
}
