import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  const TextFieldWidget({
    required this.text,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => controller.text = value ?? '',
      validator: (value) {
        if (value != null && value.isEmpty) {
          return 'Please write the ${text.toLowerCase()}!';
        }
        return null;
      },
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        hintText: text,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      minLines: 2,
      maxLines: 4,
    );
  }
}
