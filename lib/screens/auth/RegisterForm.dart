import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

InputBorder inputBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: Colors.transparent,
    style: BorderStyle.none,
    width: 0,
  ),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

final GlobalKey<FormState> _form = GlobalKey<FormState>();


final TextEditingController emailController = TextEditingController();

final TextEditingController passController = TextEditingController();
final TextEditingController confirmPassController = TextEditingController();

Widget registerForm(){
  return Form(
    key: _form,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Fullname',
            fillColor: const Color.fromRGBO(245, 244, 248, 1),
            filled: true,
            enabledBorder: inputBorder,
            border: inputBorder,
            errorBorder: inputBorder,
            focusedBorder: inputBorder,
            focusedErrorBorder: inputBorder,
          ),
          validator: (value) =>
          value!.isNotEmpty ? null : "Name can't be empty",
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Email',
            fillColor: const Color.fromRGBO(245, 244, 248, 1),
            filled: true,
            enabledBorder: inputBorder,
            border: inputBorder,
            errorBorder: inputBorder,
            focusedBorder: inputBorder,
            focusedErrorBorder: inputBorder,
          ),
          validator: (value) => EmailValidator.validate(value!)
              ? null
              : "Please enter a valid email.",
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: true,
          controller: passController,
          decoration: InputDecoration(
            hintText: 'Password',
            fillColor: const Color.fromRGBO(245, 244, 248, 1),
            filled: true,
            enabledBorder: inputBorder,
            border: inputBorder,
            errorBorder: inputBorder,
            focusedBorder: inputBorder,
            focusedErrorBorder: inputBorder,
          ),
          validator: (value) =>
          value!.isNotEmpty ? null : "Password can't be empty",
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: true,
          controller: confirmPassController,
          decoration: InputDecoration(
            hintText: 'Repeat password',
            fillColor: const Color.fromRGBO(245, 244, 248, 1),
            filled: true,
            enabledBorder: inputBorder,
            border: inputBorder,
            errorBorder: inputBorder,
            focusedBorder: inputBorder,
            focusedErrorBorder: inputBorder,
          ),
          validator: (value) => value!.isNotEmpty
              ? value == passController.text
              ? null
              : "Not match"
              : "Password can't be empty",
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setBool("firstEnter", false);
              },
              child: Text("Sign Up"),
            )),
        const SizedBox(
          height: 8,
        ),
      ],
    ),
  );
}