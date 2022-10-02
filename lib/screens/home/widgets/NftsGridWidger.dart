import 'package:flutter/material.dart';
import 'package:nuzai_wallet/podo/NFT.dart';
import 'package:nuzai_wallet/podo/User.dart';
import 'package:nuzai_wallet/screens/NftScreen.dart';
import 'package:nuzai_wallet/screens/home/widgets/EmptyListWidget.dart';
import 'package:nuzai_wallet/service/RestClient.dart';
import 'package:nuzai_wallet/widgets/CustomLoader.dart';

Widget nftGrid(BuildContext context, User user) {
  List<NFT> tokens = [];
  return FutureBuilder(
    future: RestClient.loadNFTs(user.token!, user.wallet!),
    builder: (context, snapshot) {
      if (snapshot.hasData) tokens = snapshot.data!;
      return tokens.isNotEmpty
          ? GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 40,
                crossAxisSpacing: 24,
                childAspectRatio: 0.75,
              ),
              physics: const BouncingScrollPhysics(),
              children: List.generate(
                tokens.length,
                (index) => InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NftPage(nft: tokens[index])));
                  },
                  child: Image.network(tokens[index].image!),
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CustomLoader(),
                SizedBox(height: 16),
                Text("Loading..."),
              ],
            );
    },
  );
}
