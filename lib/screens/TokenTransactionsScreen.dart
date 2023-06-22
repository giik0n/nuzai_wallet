import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:exomal_wallet/podo/Token.dart';
import 'package:exomal_wallet/podo/TokenTransaction.dart';
import 'package:exomal_wallet/podo/User.dart';
import 'package:exomal_wallet/screens/home/widgets/TransactionButtons.dart';
import 'package:exomal_wallet/service/RestClient.dart';
import 'package:exomal_wallet/widgets/CustomLoader.dart';

class TokenTransactionsScreen extends StatefulWidget {
  final Token token;
  final User user;

  const TokenTransactionsScreen(
      {Key? key, required this.token, required this.user})
      : super(key: key);

  @override
  State<TokenTransactionsScreen> createState() =>
      _TokenTransactionsScreenState();
}

class _TokenTransactionsScreenState extends State<TokenTransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    Token token = widget.token;
    User user = widget.user;
    List<TokenTransaction> transactions = [];
    ThemeData themeData = Theme.of(context);
    return FutureBuilder(
      future: RestClient.loadTokenTransactions(
          user.token!, user.wallet!, token.ticker!),
      builder: (context, snapshot) {
        if (snapshot.hasData) transactions = snapshot.data!;
        return Scaffold(
          appBar: AppBar(
            iconTheme: Theme.of(context).iconTheme,
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.network(token.image!),
                const SizedBox(height: 16),
                Text(
                  "${token.balance!} ${token.ticker!}",
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(token.amountInUsd!, style: themeData.textTheme.bodySmall),
                const SizedBox(height: 16),
                headerTransactionButtons(context, user),
                transactions.isEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CustomLoader(),
                            const SizedBox(height: 16),
                            const Text("noTransactionsYet").tr()
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: List.generate(
                            transactions.length,
                            (index) {
                              TokenTransaction transaction =
                                  transactions[index];
                              bool isReceived = transaction.to! == user.wallet!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(transaction.transactionTime!),
                                  ),
                                  ListTile(
                                      leading: Image.asset(
                                          isReceived
                                              ? "assets/icons/received_transaction.png"
                                              : "assets/icons/sent_transaction.png",
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              ?.color),
                                      title: Text(
                                          "${isReceived ? "Received".tr() : "Sent".tr()} ${transaction.ticker!}"),
                                      subtitle: Text(
                                        transaction.status! > 12
                                            ? "Confirmed"
                                            : "Pending",
                                        style: const TextStyle(
                                            color: Colors.green),
                                      ).tr(),
                                      trailing: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              "${transaction.amount!} ${transaction.ticker!}"),
                                          Text(
                                            "\$${transaction.amount!}",
                                            style:
                                                themeData.textTheme.bodySmall,
                                          )
                                        ],
                                      ),
                                      tileColor: Colors.transparent),
                                ],
                              );
                            },
                          ),
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
