import 'package:easy_localization/easy_localization.dart';
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
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                physics: const BouncingScrollPhysics(),
                children: List.generate(
                  tokens.length,
                  (index) => InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NftPage(nft: tokens[index])));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        height: 250,
                        width: 175,
                        tokens[index].image!,
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return const Center(
                            child: CustomLoader(),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                const CustomLoader(),
                const SizedBox(height: 16),
                const Text("loading").tr(),
              ],
            );
    },
  );
}
