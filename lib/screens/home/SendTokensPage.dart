import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:nuzai_wallet/podo/Token.dart';
import 'package:nuzai_wallet/podo/User.dart';
import 'package:nuzai_wallet/screens/home/widgets/QrScanner.dart';
import 'package:nuzai_wallet/service/RestClient.dart';
import 'package:nuzai_wallet/widgets/CustomLoader.dart';

class SendTokensPage extends StatefulWidget {
  final User user;

  const SendTokensPage({Key? key, required this.user}) : super(key: key);

  @override
  State<SendTokensPage> createState() => _SendTokensPageState();
}

class _SendTokensPageState extends State<SendTokensPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController walletAddressController = TextEditingController();
  String? walletAddressValidator;
  TextEditingController amountController = TextEditingController();
  String? amountValidator;
  String? selectedToken;

  List<Token> tokens = [];

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return FutureBuilder(
      future: RestClient.loadTokens(
          widget.user.token!, widget.user.defaultNetwork!, widget.user.wallet!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          tokens = snapshot.data!;
          // selectedToken ??= getDropdownItems(tokens)[0].value!;
        }

        return snapshot.hasData
            ? Scaffold(
                appBar: AppBar(
                  iconTheme: Theme.of(context).iconTheme,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: const Text("sendTokens").tr(),
                    titleTextStyle: _themeData.textTheme.headline5),
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              "to",
                              style: _themeData.textTheme.headline5
                                  ?.copyWith(color: Colors.blue),
                            ).tr(),
                            Expanded(
                                child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "walletEmptyError".tr();
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  hintText: "walletAddress".tr(),
                                  border: InputBorder.none),
                              controller: walletAddressController,
                            )),
                            IconButton(
                                onPressed: () async {
                                  String code =
                                      await _navigateAndDisplaySelection(
                                          context);
                                  walletAddressController.text = code;
                                },
                                icon: const Icon(Icons.qr_code_rounded))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: DropdownButtonFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "noSelectedToken".tr();
                            }
                            return null;
                          },
                          hint: const Text("selectToken").tr(),
                          value: selectedToken,
                          items: getDropdownItems(tokens),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedToken = newValue!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("amount").tr(),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  hintText: "0.0000123"
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.parse(value) <= 0) {
                                    return "pleaseEnterSomeAmount".tr();
                                  }

                                  // if (selectedToken != null &&
                                  //     double.parse(value) >
                                  //         double.parse(tokens
                                  //             .firstWhere((element) =>
                                  //                 element.ticker ==
                                  //                 selectedToken!)
                                  //             .balance!))
                                  //   return "dontHaveSuchAmount".tr();
                                  return null;
                                },
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]")),
                                  TextInputFormatter.withFunction(
                                      (oldValue, newValue) {
                                    try {
                                      final text = newValue.text;
                                      if (text.isNotEmpty) double.parse(text);
                                      return newValue;
                                    } catch (e) {
                                      print(e);
                                    }
                                    return oldValue;
                                  }),
                                ],
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            )),
                          ],
                        ),
                      ),
                      selectedToken != null && amountController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40.0, vertical: 20.0),
                              child: Center(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("estimatedGasFee".tr()),
                                        const Text(
                                          "0.0000032 BNB",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("total").tr(),
                                        Text(
                                          "${amountController.text} ${selectedToken!} +  0.0000032 BNB",
                                          style: const TextStyle(
                                              color: Colors.blue),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return const CustomLoader();
                                  });
                              Response response = await RestClient.sendTokens(
                                  widget.user.token!,
                                  widget.user.id!,
                                  walletAddressController.text,
                                  amountController.text,
                                  selectedToken!);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  getSnackBar(response.statusCode == 200
                                      ? "Sent".tr()
                                      : "Error".tr()));
                            }
                          },
                          child: const Text("send").tr())
                    ],
                  ),
                ),
              )
            : const Scaffold(
                body: CustomLoader(),
              );
      },
    );
  }

  Future<String> _navigateAndDisplaySelection(BuildContext context) async {
    final String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QrScanner()),
    );
    return result;
  }

  getSnackBar(String msg) => SnackBar(
        content: Text(msg),
      );

  List<DropdownMenuItem<String>> getDropdownItems(List<Token> tokens) {
    List<DropdownMenuItem<String>> menuItems = List.generate(
        tokens.length,
        (index) => DropdownMenuItem(
            value: tokens[index].ticker!,
            child: Text("${tokens[index].ticker!} ${tokens[index].balance!}")));
    return menuItems;
  }
}
