import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:exomal_wallet/podo/Token.dart';
import 'package:exomal_wallet/podo/User.dart';
import 'package:exomal_wallet/screens/TokenTransactionsScreen.dart';
import 'package:exomal_wallet/screens/home/widgets/EmptyListWidget.dart';
import 'package:exomal_wallet/service/RestClient.dart';
import 'package:exomal_wallet/widgets/CustomLoader.dart';

Widget tokensList(BuildContext context, User user) {
  List<Token> tokens = [];
  return FutureBuilder(
    future: RestClient.loadTokens(user.token!, user.wallet!),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        tokens = snapshot.data!;
      }
      Color tileColor = Theme.of(context).brightness == Brightness.light
          ? const Color.fromRGBO(245, 244, 248, 1)
          : const Color.fromRGBO(28, 46, 80, 1);
      if (snapshot.hasData) {
        return tokens.isNotEmpty
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        color: tileColor),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          tokens.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              tileColor: tileColor,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TokenTransactionsScreen(
                                              token: tokens[index],
                                              user: user,
                                            )));
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              leading: Image.network(
                                tokens[index].image!,
                                scale: 1.5,
                              ),
                              title: Text(tokens[index].ticker!),
                              subtitle: Text(tokens[index].name!),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(tokens[index].balance!),
                                  Text(
                                    double.parse(tokens[index].amountInUsd!)
                                        .toStringAsFixed(2),
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //     Container(
                          //   decoration: BoxDecoration(
                          //     color: tileColor,
                          //         borderRadius: BorderRadius.all(Radius.circular(8))
                          //   ),
                          //   child: Padding(
                          //         padding: const EdgeInsets.symmetric(vertical: 8.0),
                          //         child: GestureDetector(
                          //           onTap: () {
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         TokenTransactionsScreen(
                          //                           token: tokens[index],
                          //                           user: user,
                          //                         )));
                          //           },
                          //           child: Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Row(
                          //                 children: [
                          //                   Image.network(
                          //                     tokens[index].image!,
                          //                     scale: 1.5,
                          //                   ),
                          //                   Padding(
                          //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          //                     child: Column(
                          //                       mainAxisSize: MainAxisSize.min,
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment.start,
                          //                       children: [
                          //                         Text(tokens[index].ticker!),
                          //                         Text(tokens[index].name!),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                 ],
                          //               ),
                          //               Text(tokens[index].balance!)
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          // )
                        )),
                  ),
                ),
              )
            : emptyList("tokens", context);
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLoader(),
            const SizedBox(height: 16),
            const Text("loading").tr(),
          ],
        );
      }
    },
  );
}
