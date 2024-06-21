import 'package:flutter_bloc/flutter_bloc.dart';

class ChartsInfoCubit extends Cubit<Map<String, Map<String, dynamic>>> {
  ChartsInfoCubit() : super({"care": {}, "vitals": {}, "emotion": {}});

  void updateCharts(String key, Map<String, dynamic> charts) {
    emit(state..addAll({key: charts}));
  }
}
