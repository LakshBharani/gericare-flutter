import 'package:flutter_bloc/flutter_bloc.dart';

class RemindersCubit extends Cubit<List<Map<String, dynamic>>> {
  RemindersCubit() : super([]);

  void updateReminders(List<Map<String, dynamic>> updatedReminders) {
    emit(updatedReminders);
  }
}
