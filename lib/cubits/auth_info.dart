import 'package:flutter_bloc/flutter_bloc.dart';

class AuthInfoCubit extends Cubit<Map<String, dynamic>> {
  AuthInfoCubit() : super({});
  void updateAuthInfo(Map<String, dynamic> newInfo) {
    emit(newInfo);
  }

  void updateAccessToken(String newAccessToken) {
    final Map<String, dynamic> currentState = state;
    currentState['access_token'] = newAccessToken;
    emit(currentState);
  }
}
