import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:nuzai_wallet/podo/TokenTransaction.dart';

import '../podo/NFT.dart';
import '../podo/Token.dart';

const String mainUrl = "https://nuzaicore.herokuapp.com/api/v2/";
const String usersSubUrl = "users/";
const String balanceSubUrl = "balance/";

class RestClient {
  static Future<Response> auth(String email, String password) async {
    return await post(Uri.parse("https://nuzaicore.herokuapp.com/api/v2/users/auth"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json"
        },
        body: json.encode({"email": email, "password": password}));
  }

  static Future<List<Token>> loadTokens(String jwt, int defaultNetwork, String wallet) async{
    var response = await get(Uri.parse("https://nuzaicore.herokuapp.com/api/v2/balance/tokens/$defaultNetwork/wallet/$wallet"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        });
    Iterable l = json.decode(response.body);
    return List<Token>.from(l.map((model) => Token.fromJson(model)));
  }

  static Future<List<NFT>> loadNFTs(String jwt,String wallet) async{
    var response = await get(Uri.parse("https://nuzaicore.herokuapp.com/api/v2/balance/nfts/$wallet"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        });
    Iterable l = json.decode(response.body);
    return List<NFT>.from(l.map((model) => NFT.fromJson(model)));
  }

  static Future<List<TokenTransaction>> loadTokenTransactions(String jwt,String wallet, String ticker) async{
    var response = await get(Uri.parse("https://nuzaicore.herokuapp.com/api/v2/balance/gettransactions/$wallet/ticker/$ticker"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        });
    Iterable l = json.decode(response.body);
    return List<TokenTransaction>.from(l.map((model) => TokenTransaction.fromJson(model)));
  }
}
