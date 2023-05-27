
  import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import '../../podo/User.dart';
import '../../service/RestClient.dart';
import '../../widgets/CustomLoader.dart';

Future changeUserDialog(User user, String hint, String key, BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();

        switch (key) {
          case "fullname":
            controller.text = user.fullname!;
            break;
          case "email":
            controller.text = user.email!;
            break;
        }

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: hint),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (controller.text.isNotEmpty) {
                        if (key == "fullname" && !controller.text.contains(" "))
                          return;
                        showDialog(
                            // The user CANNOT close this dialog  by pressing outsite it
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              return const CustomLoader();
                            });
                        Response response = await RestClient.editUser(
                            user.token!, user.id!, key, controller.text);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(response.statusCode == 200
                                    ? "Success".tr()
                                    : "Error")
                                .tr()));
                        if (response.statusCode == 200) {
                          FlutterSecureStorage storage =
                              const FlutterSecureStorage();
                          switch (key) {
                            case "fullname":
                              user.fullname = controller.text;
                              storage.write(
                                  key: "user", value: jsonEncode(user));
                              break;
                            case "email":
                              user.email = controller.text;
                              storage.write(
                                  key: "user", value: jsonEncode(user));
                              break;
                            case "password":
                              storage.write(
                                  key: "password", value: controller.text);
                              break;
                          }
                        }
                      }
                    },
                    child: const Text("submit").tr())
              ],
            ),
          ),
        );
      });