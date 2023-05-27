  import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../podo/User.dart';
import '../../service/RestClient.dart';
import '../../widgets/CustomLoader.dart';

Future selectNetworkDialog(User user, BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        Map<String, int> supportedNetworks = HashMap();
        supportedNetworks.putIfAbsent("BSC TestNet", () => 1);
        supportedNetworks.putIfAbsent("BSC MainNet", () => 2);
        FlutterSecureStorage storage = const FlutterSecureStorage();
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                supportedNetworks.length,
                (index) => ListTile(
                  leading: user.defaultNetwork ==
                          supportedNetworks.values.toList()[index]
                      ? const Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : const SizedBox.shrink(),
                  onTap: () async {
                    user.defaultNetwork =
                        (supportedNetworks.values.toList()[index]);
                    showDialog(
                        // The user CANNOT close this dialog  by pressing outsite it
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          return const CustomLoader();
                        });
                    await RestClient.editUser(user.token!, user.id!,
                        "defaultNetwork", user.defaultNetwork.toString());
                    user = await RestClient.getUserById(user.id!, user.token!);
                    user.token = await storage.read(key: "token");
                    print(user.toJson());
                    await storage.write(key: "user", value: jsonEncode(user));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  title: Text(supportedNetworks.keys.toList()[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }