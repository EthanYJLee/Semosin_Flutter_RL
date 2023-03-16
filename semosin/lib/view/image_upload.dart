import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload({super.key});

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  // 선택한 이미지 리스트
  List<XFile>? _imageFileList;
  // 선택한 이미지의 경로 리스트
  late List<String> _imagePathList = [];

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
        backgroundColor: const Color.fromARGB(255, 138, 143, 239),
      ),
      body: Center(
        child: _handlePreview(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              // 업로드 버튼 누르면 선택한 이미지 업로드하고 이전 화면으로 돌아간다.

              if (_imageFileList!.isEmpty) {
                // 선택한 사진이 없는 경우
                //**
                // NOTHING HAPPENS
                // */
              } else {
                // 선택한 사진이 있는 경우
                _saveSharedPreferences();
                showDialog(
                    context: context,
                    builder: ((context) {
                      return AlertDialog(
                        title: const Text('저장되었습니다'),
                        actions: [
                          ElevatedButton(
                            onPressed: (() {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }),
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    }));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 138, 143, 239),
            ),
            child: const Text(
              '업로드',
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              backgroundColor: const Color.fromARGB(255, 138, 143, 239),
              child: const Icon(Icons.photo),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(
                  ImageSource.camera,
                  context: context,
                );
              },
              heroTag: 'image2',
              tooltip: 'Take a Photo',
              backgroundColor: const Color.fromARGB(255, 138, 143, 239),
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Upload'),
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
                    onPick(null, 100, null);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final XFile? pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _setImageFileListFromFile(pickedFile);
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return Semantics(
        label: 'image_picker_example_picked_images',
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            key: UniqueKey(),
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Semantics(
                    label: 'image_picker_example_picked_image',
                    child: kIsWeb
                        ? Image.network(_imageFileList![index].path)
                        : Image.file(File(_imageFileList![index].path)),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              );
            },
            itemCount: _imageFileList!.length,
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
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _handlePreview() {
    return _previewImages();
  }

  // 사진을 선택한 후 '앨범에 추가' 버튼 클릭시 sp에 저장후 넘겨주기
  Future _saveSharedPreferences() async {
    final pref = await SharedPreferences.getInstance();
    for (int i = 0; i < _imageFileList!.length; i++) {
      _imagePathList.add(_imageFileList![i].path);
    }

    pref.setStringList('p_imagePathList', _imagePathList);
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
