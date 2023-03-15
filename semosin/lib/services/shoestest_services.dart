import 'package:semosin/model/shoes_model.dart';

class ViewModel {
  final Model _model;
  late Stream<List<dynamic>> imagesStream;

  ViewModel({required Model model}) : _model = model {
    imagesStream = _model.imagesStream;
  }

  void getDocuments() {
    _model.getDocuments();
  }
}
