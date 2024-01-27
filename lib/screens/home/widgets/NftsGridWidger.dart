import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:exomal_wallet/podo/NFT.dart';
import 'package:exomal_wallet/podo/User.dart';
import 'package:exomal_wallet/screens/NftScreen.dart';
import 'package:exomal_wallet/service/RestClient.dart';
import 'package:exomal_wallet/widgets/CustomLoader.dart';

Widget nftGrid(BuildContext context, User user) {
  List<NFT> tokens = [];
  return FutureBuilder(
    future: RestClient.loadNFTs(user.token!, user.wallet!),
    builder: (context, snapshot) {
      if (snapshot.hasData) tokens = snapshot.data!;
      tokens.add(new NFT(
          description: "Let's go Duck!",
          title: 'Rubber Duck',
          image:
              "https://i.pinimg.com/736x/6d/d9/31/6dd931bfb3d368e4ab25090aefcc3c54.jpg",
          model:
              "https://github.com/KhronosGroup/glTF-Sample-Models/raw/main/2.0/Duck/glTF-Binary/Duck.glb",
          extension: "glb"));
      tokens.add(new NFT(
          description: "Test!",
          title: 'Test',
          image:
              "https://cdna.artstation.com/p/assets/images/images/023/547/606/large/shawna-ray-tiger-perspective.jpg?1579565062",
          model:
              "https://github.com/giik0n/nuzai_wallet/raw/main/assets/models/ImageToStl.com_tiger_body_textured.glb",
          extension: "glb"));
      //https://github.com/giik0n/nuzai_wallet/raw/main/assets/models/ImageToStl.com_tiger_body_textured.glb
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
                                  NftScreen(nft: tokens[index])));
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
              children: [
                const CustomLoader(),
                const SizedBox(height: 16),
                const Text("loading").tr(),
              ],
            );
    },
  );
}
