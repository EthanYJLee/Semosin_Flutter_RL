// import 'dart:async';

// import 'package:flutter/material.dart';

// class TextFormFieldWidget extends StatefulWidget {
//   final StreamController controller;

//   final Stream<String> stream;

//   const TextFormFieldWidget(
//       {super.key, required this.controller, required this.stream});

//   @override
//   State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
// }

// class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: TextFormField(
//         onChanged: (value) {
//           widget.controller.add(value);

//           widget.stream.listen((event) {
//             // action
//           });
//         },
//       ),
//     );
//   }
// }

// class MyTextFormField {
//   textFormField(controller, readOnly, keyboardType, label, onChanged) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextFormField(
//         controller: controller,
//         readOnly: readOnly,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(
//           label: Text(label),
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 1,
//               color: Colors.grey,
//             ),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               width: 1,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         onChanged: (value) {
//           onChanged;
//         },
//       ),
//     );
//   }
// }
