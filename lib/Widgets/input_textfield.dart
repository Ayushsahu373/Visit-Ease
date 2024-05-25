import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final IconData Preicon; 
  final IconData Posticon;
  const TextInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    required this.Preicon,
    this.Posticon = Icons.error_outline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Color.fromARGB(255, 251, 251, 251)), // Set text color to white
      decoration: InputDecoration(
        
        labelText: labelText,
        prefixIcon: Icon(
          Preicon,
          color: Colors.white, // Set icon color to white
          
        ),
        labelStyle: const TextStyle(
          fontSize: 20,
          color:Colors.white, // Set label color to white
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.white, // Adjust border color
            width: 3, // Increase border width
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromRGBO(251, 109, 169, 1), // Adjust focused border color
            width: 3, // Increase border width
          ),
        ),
      ),
      obscureText: isObscure,
    );
  }
}
