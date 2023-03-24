import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semosin/view/result.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

/// Desc : 콜백함수 원형 선언 (_showAccessDialog에서 300,300으로 설정)
/// Date : 2023.03.16
/// Author : youngjin
typedef ImageSizeCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);

class _ImageUploadState extends State<ImageUpload> {
  // 선택한 이미지
  XFile? _imageFile;
  // Image Picker
  final ImagePicker _picker = ImagePicker();
  // 이미지 선택 오류
  dynamic _pickImageError;
  String? _retrieveDataError;

  void _setImageFromFile(XFile? value) {
    _imageFile = (value);
  }

  // --------------------------------- FRONT -----------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  "이미지 선택",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              _handlePreview(),
            ],
          ),
        ),
      ),
    );
  }
  // --------------------------------------------------------------------- FRONT

  // --------------------------------- FUNCTIONS -------------------------------
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
        setState(() {
          _setImageFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          // _pickImageError = e;
          errorDialog();
        });
      }
    });
  }

  /// Desc : Photos / Camera 접근 전 Alert Dialog
  /// Date : 2023.03.16
  /// Authot : youngjin
  // Future<void> _showAccessDialog(
  //     BuildContext context, ImageSizeCallback imageSize) async {
  //   return showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('이미지 선택'),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('취소'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             TextButton(
  //                 child: const Text('선택'),
  //                 onPressed: () {
  //                   // imageSize(128, 128, null);
  //                   /// [수정] 우선 크게 보여주고 다음 화면에서 예측할 때 resize하는 것으로 변경
  //                   /// Date : 2023.03.16
  //                   imageSize(300, 300, null);
  //                   Navigator.of(context).pop();
  //                 }),
  //           ],
  //         );
  //       });
  // }

  // 바로 갤러리로 이동할 수 있게 밑에 있는 코드로 바꿔줌

  Future<void> _showAccessDialog(
      BuildContext context, ImageSizeCallback imageSize) async {
    return imageSize(300, 300, null);
  }

// 선택한 이미지로 인해 오류 시 다이어로그 띄워주기
  void errorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("이미지 오류"),
          content: const Text("다른 사진을 선택해주세요"),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 이미지 선택 바텀시트
  void imageBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        context: context,
        builder: (context) {
          return SizedBox(
            height: 300,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 14),
                  child: Column(
                    children: const [
                      Text(
                        "이미지 선택",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "이미지를 가져올 장소를 선택 해주세요",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
                const Divider(height: 1),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _onImageButtonPressed(ImageSource.gallery,
                          context: context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Text(
                        "갤러리",
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    )),
                const Divider(height: 1),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _onImageButtonPressed(ImageSource.camera,
                          context: context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(13.0),
                      child: Text(
                        "사진찍기",
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    )),
                const Divider(height: 1),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(13.0),
                    child: Text(
                      "취소",
                      style: TextStyle(color: Colors.red, fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

// ------------------------------------------------------------------- FUNCTIONS

// --------------------------------- WIDGETS -----------------------------------
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

    if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // _onImageButtonPressed(ImageSource.gallery, context: context);
              imageBottomSheet(context);
            },
            // 이미지 ------------------------------------------------------------
            child: Container(
              height: 320,
              width: 250,
              decoration: BoxDecoration(
                  border: _imageFile == null
                      ? Border.all(
                          color: const Color.fromARGB(129, 158, 158, 158),
                          width: 1,
                        )
                      : Border.all(
                          color: Colors.white10,
                          width: 0,
                        )),
              child: Center(
                child: _imageFile == null
                    ? const Icon(
                        Icons.add,
                        size: 50,
                        color: Color.fromARGB(129, 158, 158, 158),
                      )
                    : Semantics(
                        label: 'selected_image',
                        child: Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                _imageFile == null
                    ? const Text(
                        "이미지를 선택해주세요",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                          Text(
                            "이미지 클릭시 변경가능",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(height: 70),
                // 모델예측 버튼----------------------------------------------------
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _imageFile != null ? Colors.black : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(300, 50)),
                  onPressed: () {
                    if (_imageFile == null) {
                      // 선택한 사진이 없는 경우
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: SizedBox(
                            height: 40,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  '이미지를 선택해주세요',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                        dismissDirection: DismissDirection.up,
                        duration: const Duration(milliseconds: 500),
                      ));
                    } else {
                      // 선택한 사진이 있는 경우
                      // _saveSharedPreferences();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Result(image: _imageFile!)));
                    }
                  },
                  child: const Text(
                    '모델 예측하기',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
