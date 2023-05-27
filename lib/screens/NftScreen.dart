import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:exomal_wallet/podo/NFT.dart';
import 'package:exomal_wallet/screens/ar/ArCoreViewScreen.dart';
import 'package:exomal_wallet/widgets/CustomLoader.dart';

class NftScreen extends StatefulWidget {
  final NFT nft;

  const NftScreen({Key? key, required this.nft}) : super(key: key);

  @override
  State<NftScreen> createState() => _NftScreenState();
}

class _NftScreenState extends State<NftScreen> {
  @override
  Widget build(BuildContext context) {
    NFT nft = widget.nft;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      nft.image!,
                      height: 250,
                      width: 175,
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
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: buttonStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ArCoreViewScreen(
                                    nft.fileExtension == "glb"
                                        ? nft.ipfsUlrl
                                        : null)),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Image.asset("assets/icons/eye_icon.png",
                                  height: 10, width: 16),
                            ),
                            const Text(
                              "See in AR",
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).listTileTheme.tileColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                nft.title![0],
                                style: textTheme.headline4!.copyWith(
                                    color: Color.fromRGBO(55, 135, 254, 1)),
                              ),
                              Text(
                                nft.title!.substring(1, nft.title!.length),
                                style: textTheme.headline4,
                              ),
                            ],
                          ),
                          Text(
                            nft.description!.isEmpty
                                ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Metus aliquam eleifend mi in nulla posuere. Ut etiam sit amet nisl purus. "
                                : nft.description!,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: buttonStyle,
                            onPressed: () {},
                            child: const Text(
                              "send",
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            style: buttonStyle,
                            onPressed: () {},
                            child: const Text(
                              "Sell",
                              style: TextStyle(color: Colors.white),
                            ).tr(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor:
          const MaterialStatePropertyAll(Color.fromRGBO(55, 135, 254, 0.9)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      )));
}
