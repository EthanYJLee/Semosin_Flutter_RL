import 'package:flutter/material.dart';
import 'package:semosin/model/shoes_model.dart';
import 'package:semosin/services/shoestest_services.dart';

class ImageFromFirestore extends StatefulWidget {
  ImageFromFirestore({Key? key}) : super(key: key);

  @override
  _ImageFromFirestoreState createState() => _ImageFromFirestoreState();
}

class _ImageFromFirestoreState extends State<ImageFromFirestore> {
  late ViewModel _viewModel;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _viewModel = ViewModel(model: Model());
    _viewModel.getDocuments();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        print('_scrollController동작');
        _viewModel.getDocuments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<dynamic>>(
        stream: _viewModel.imagesStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final images = snapshot.data!;
          return ListView.builder(
            controller: _scrollController,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: Card(
                  child: Image.network(
                    images[index],
                    width: MediaQuery.of(context).size.width - 30,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
