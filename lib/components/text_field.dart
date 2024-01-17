import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon icon;
  final double width;
  final double height;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    this.width = double.infinity, // Set default width to infinity
    this.height = 65.0, // Set default height to 65.0
  }) : super(key: key);

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = false; // Default to false, not obscuring

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText && _obscureText,
        style: TextStyle(
          color: Color(0xFF207D4A), // Set the text color
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD7E5DC)),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(20.0),
          ),
          fillColor: Color(0xFFD7E5DC),
          prefixIcon: widget.icon,
          prefixIconColor: Color(0xFF207D4A),
          suffixIcon: widget.obscureText
              ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Color(0xFF207D4A),
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          )
              : null,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Color(0xFF207D4A),
          ),
        ),
      ),
    );
  }
}
