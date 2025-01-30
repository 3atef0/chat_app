import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.maxLines = 1,
    this.onSaved,
    this.onChange,
    this.controller,
    this.borderColor = Colors.grey,
    required this.labelText,
    this.prefixIcon,
    this.prefixIconColor,
    this.validator,
    this.isPassword = false,
  }); // Added borderColor parameter
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final int maxLines;
  final void Function(String?)? onSaved;
  final void Function(String)? onChange;
  final Color borderColor; // Added borderColor property
  final Icon? prefixIcon;
  final Color? prefixIconColor;
  final String? Function(String?)? validator;
  final bool isPassword;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    final defaultPadding = const EdgeInsets.symmetric(horizontal: 0);
    return Padding(
      padding: defaultPadding,
      child: TextFormField(
        obscureText: widget.isPassword ? _obscureText : false,
        controller: widget.controller,
        onChanged: widget.onChange,
        onSaved: widget.onSaved,
        validator: widget.validator,
        cursorColor: Colors.black,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: Colors.white,
          labelText: widget.labelText, // Hint integrated into the border
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black),
          border: buildBorder(widget.borderColor),
          enabledBorder: buildBorder(widget.borderColor),
          focusedBorder: buildBorder(const Color(0xFF478ecc)),
          prefixIcon: widget.prefixIcon,
          prefixIconColor: widget.prefixIconColor,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: color), // Use color parameter
    );
  }
}
