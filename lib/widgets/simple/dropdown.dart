import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final List<String> options;
  final width;
  final Widget hint;
  final TextEditingController controller;
  final String selectedValue;
  DropDown({
    this.options,
    this.width,
    this.controller,
    this.hint,
    this.selectedValue,
  });

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _selectedValue;

  @override
  void initState() {
    if (widget.selectedValue != null && widget.selectedValue.isNotEmpty)
      _selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.selectedValue != null && widget.selectedValue.isNotEmpty) {
      setState(() {
        _selectedValue = widget.selectedValue;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //String dropdownValue = widget.options[0];
    if (widget.selectedValue != null && widget.selectedValue.isNotEmpty)
      _selectedValue = widget.selectedValue;
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      child: Container(
        width: widget.width,
        child: DropdownButton<String>(
          isExpanded: true,
          hint: widget.hint,
          value: _selectedValue,
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          underline: Container(
            height: 0,
            color: Colors.white,
          ),
          onChanged: (String newValue) {
            setState(() {
              print('selected value : $newValue');
              _selectedValue = newValue;
              widget.controller.text = newValue;
            });
          },
          items: widget.options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              //onTap: ,
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
