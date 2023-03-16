import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semosin/view/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

/// Desc : 콜백함수 원형 선언 (_showAccessDialog에서 300,300으로 설정, 변경 계획 없음)
/// Date : 2023.03.16
/// Author : youngjin
typedef ImageSizeCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class _ImageUploadState extends State<ImageUpload> {
  // 선택한 이미지
  XFile? _imageFile;
  // 선택한 이미지의 경로
  late String _imagePath = '';
  // Image Picker
  final ImagePicker _picker = ImagePicker();
  // 이미지 선택 오류
  dynamic _pickImageError;
  String? _retrieveDataError;

  void _setImageFromFile(XFile? value) {
    _imageFile = (value == null ? null : value);
  }

  // --------------------------------- FRONT ---------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _handlePreview(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          // --------------- 신발 모델 예측 버튼 ---------------
          child: ElevatedButton(
            onPressed: () {
              if (_imageFile == null) {
                // 선택한 사진이 없는 경우
              } else {
                // 선택한 사진이 있는 경우
                // _saveSharedPreferences();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Result(image: _imageFile!)));
              }
            },
            style: ElevatedButton.styleFrom(),
            child: const Text(
              '모델 예측하기',
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'Gallery',
              tooltip: '갤러리에서 이미지 선택',
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'Camera',
              tooltip: '카메라에서 이미지 촬영',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
  // ------------------------------------------------------------------ FRONT

  // --------------------------------- FUNCTIONS ---------------------------------
  /// Desc : Floating Action Button 클릭 시 Photos / Camera에 접근
  /// Date : 2023.03.16
  /// youngjin
  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    await _showAccessDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        print(source);
        setState(() {
          _setImageFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  /// Desc : Photos / Camera 접근 전 Alert Dialog
  /// Date : 2023.03.16
  /// Authot : youngjin
  Future<void> _showAccessDialog(
      BuildContext context, ImageSizeCallback imageSize) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('이미지 선택'),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('선택'),
                  onPressed: () {
                    // imageSize(128, 128, null);
                    /// [수정] 우선 크게 보여주고 다음 화면에서 예측할 때 resize하는 것으로 변경
                    /// Date : 2023.03.16
                    imageSize(300, 300, null);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
// ------------------------------------------------------------------ FUNCTIONS

// --------------------------------- WIDGETS ---------------------------------
  /// Desc : 선택한 이미지 보여주기 (Preview)
  /// Date : 2023.03.16
  /// Author : youngjin
  Widget _handlePreview() {
    return _previewImage();
  }

  Widget _previewImage() {
    // 오류 있을 시 Error 출력
    final Text? retrieveError = _getRetrieveError();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Semantics(
        label: 'selected_image',
        child: Container(
          height: 350,
          width: 350,
          child: GridView.builder(
            key: UniqueKey(),
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // 1개의 행에 보여줄 item 개수
              childAspectRatio: 1, // item 의 가로 1, 세로 1 의 비율 (1/1)
              mainAxisSpacing: 10, // 수평 Padding
              crossAxisSpacing: 10, // 수직 Padding
            ),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: 'selected_image',
                    child: kIsWeb
                        ? Image.network(_imageFile!.path)
                        : Image.file(File(_imageFile!.path)),
                  ),
                ],
              );
            },
            // 여러장 선택시 _imageFile(리스트)!.length
            itemCount: 1,
          ),
        ),
      );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        '우측 버튼을 눌러 사진을 업로드해주세요',
        textAlign: TextAlign.center,
      );
    }
  }

  /// Desc : 오류 발생 시 Text로 출력
  /// Date : 2023.03.16
  /// Authot : youngjin
  Text? _getRetrieveError() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  /// Desc : 이미지 업로드 후 '예측하기' 버튼 클릭시 Shared Preferences에 저장
  /// Date : 2023.03.16
  /// Author : youngjin
  // Future _saveSharedPreferences() async {
  //   final pref = await SharedPreferences.getInstance();
  //   pref.setString('imagePath', _imagePath);
  // }
// ------------------------------------------------------------------ WIDGETS
}
