import 'package:flutter/material.dart';

Widget myTextField({
  required Key key,
  required String labelText,
  required IconData prefixIcon,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required TextInputAction textInputAction,
  required Function(String?) validator,
  bool obscureText = false,
  bool isPassword = false,
  Function()? suffix,
}) {
  return Container(
    height: 70,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
      key: key,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        border: InputBorder.none,
        suffix: suffix != null
            ? IconButton(
                onPressed: suffix,
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) => validator(value),
      controller: controller,
    ),
  );
}
