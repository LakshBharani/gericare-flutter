import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentsListCubit extends Cubit<Map<String, dynamic>> {
  DocumentsListCubit() : super({});
  void updateData(Map<String, dynamic> documentList) {
    emit(documentList);
  }
}
