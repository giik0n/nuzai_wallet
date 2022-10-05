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
                    title: const Text("Send tokens"),
                    titleTextStyle: _themeData.textTheme.headline5),
                body: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "To: ",
                              style: _themeData.textTheme.headline5
                                  ?.copyWith(color: Colors.blue),
                            ),
                            Expanded(
                                child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some wallet address';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  hintText: "Wallet address",
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
                        padding: const EdgeInsets.symmetric(horizontal: 40.0),
                        child: DropdownButtonFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'No selected token';
                            }
                            return null;
                          },
                          hint: const Text("Select token"),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Amount: "),
                            Expanded(
                                child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.parse(value) <= 0) {
                                    return 'Please enter some amount';
                                  }

                                  // if (selectedToken != null &&
                                  //     double.parse(value) >
                                  //         double.parse(tokens
                                  //             .firstWhere((element) =>
                                  //                 element.ticker ==
                                  //                 selectedToken!)
                                  //             .balance!))
                                  //   return 'Don\'t have such amount';
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
                                    } catch (e) {}
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
                                      children: const [
                                        Text("Estimated gas fee"),
                                        Text(
                                          "0.0000032 BNB",
                                          style: TextStyle(color: Colors.blue),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Total"),
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
                                  // The user CANNOT close this dialog  by pressing outsite it
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) {
                                    return CustomLoader();
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
                                      ? "Sent"
                                      : "Error"));
                            }
                          },
                          child: const Text("Send"))
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
