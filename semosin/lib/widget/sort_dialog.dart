import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowSortDialog extends StatefulWidget {
  List<Color?> sortColors;
  List<String> sortButtonTexts;
  List<bool> sortSelectList;
  String sortValues;
  StreamController<String> streamController;

  ShowSortDialog({
    super.key,
    required this.sortColors,
    required this.sortButtonTexts,
    required this.sortSelectList,
    required this.sortValues,
    required this.streamController,
  });

  @override
  State<ShowSortDialog> createState() => _ShowSortDialogState();
}

class _ShowSortDialogState extends State<ShowSortDialog> {
  Color selectColor = const Color.fromARGB(150, 199, 198, 198);
  Color unselectColor = Colors.white;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var padding = MediaQuery.of(context).size.height * 0.006;
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.075,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        '정렬방법',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.5,
                  top: MediaQuery.of(context).size.height * 0.01,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.06,
                    height: MediaQuery.of(context).size.width * 0.06,
                    child: RawMaterialButton(
                      onPressed: () => Navigator.pop(context),
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: Colors.black45,
                        size: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(2, padding, 2, padding),
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () => changeSortValue(0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: widget.sortColors[0],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.sortButtonTexts[0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(2, padding, 2, padding),
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () => changeSortValue(1),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: widget.sortColors[1],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.sortButtonTexts[1],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(2, padding, 2, padding),
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () => changeSortValue(2),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color: widget.sortColors[2],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            widget.sortButtonTexts[2],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeSortValue(int index) {
    for (var i = 0; i < 3; i++) {
      if (index == i) {
        setState(
          () {
            widget.sortColors[i] = selectColor;
            widget.sortSelectList[i] = true;
            widget.sortValues = widget.sortButtonTexts[i];
          },
        );
      } else {
        setState(
          () {
            widget.sortColors[i] = unselectColor;
            widget.sortSelectList[i] = false;
          },
        );
      }
    }

    widget.streamController.add(widget.sortValues);
  }
}
