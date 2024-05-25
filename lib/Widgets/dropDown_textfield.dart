import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final List<String> items;
  final Function(String?) onChanged;
  final String labelText;
  final IconData preIcon;
  final IconData postIcon;

  const DropdownField({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.labelText,
    required this.preIcon,
    this.postIcon = Icons.error_outline,
  }) : super(key: key);

  @override
  _DropdownFieldState createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  String? _selectedItem;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: Icon(
          widget.preIcon,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        suffixIcon: Icon(
          widget.postIcon,
          color: Color.fromARGB(255, 245, 245, 245),
        ),
        labelStyle: TextStyle(
          fontSize: 20,
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 255, 255, 255),
            width: 3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Color.fromRGBO(251, 109, 169, 1),
            width: 3,
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text('Select an item',style: TextStyle(color: Colors.white),),
          value: _selectedItem,
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue;
            });
            widget.onChanged(newValue);
          },
          items: widget.items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ),
    );
  }
}
