import 'dart:convert';

import 'package:http/http.dart';
import 'package:exomal_wallet/podo/GasFee.dart';
import 'package:exomal_wallet/podo/TokenTransaction.dart';

import '../podo/NFT.dart';
import '../podo/Token.dart';
import '../podo/User.dart';

const String mainUrl = "https://api.nuzai.network/api/v2/";
const String usersSubUrl = "users/";
const String balanceSubUrl = "balance/";

class RestClient {
  static Future<Response> auth(String email, String password) async {
    return await post(Uri.parse("http://134.209.240.201/api/v2/users/auth"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json"
        },
        body: json.encode({"email": email, "password": password}));
  }

  static Future<Response> getCode(String email) {
    return get(Uri.parse("http://134.209.240.201/api/v2/users/sendcode/$email"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
        });
  }

  static Future<Response> verifyCode(String email, String code) {
    return get(
        Uri.parse(
            "http://134.209.240.201/api/v2/users/verify/$email/code/$code"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
        });
  }

  static Future<Response> register(
      String email, String password, String fullname) async {
    return await post(Uri.parse("http://134.209.240.201/api/v2/users/register"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json"
        },
        body: json.encode(
            {"email": email, "password": password, "fullname": fullname}));
  }

  static Future<Response> registerSocial(String email, String password,
      String fullname, String socialNetwork) async {
    return await post(
        Uri.parse("http://134.209.240.201/api/v2/users/social_register"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json"
        },
        body: json.encode({
          "email": email,
          "password": password,
          "fullname": fullname,
          "socialId": socialNetwork
        }));
  }

  static Future<Response> sendTokens(
      String jwt, int id, String to, String amount, String ticker) async {
    return await post(
        Uri.parse("http://134.209.240.201/api/v2/balance/signtransaction/$id"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode({"to": to, "amount": amount, "ticker": ticker}));
  }

  static Future<List<Token>> loadTokens(String jwt, String wallet) async {
    var response = await get(
        Uri.parse("http://134.209.240.201/api/v2/balance/tokens/$wallet"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        });
    Iterable l = json.decode(response.body);
    return List<Token>.from(l.map((model) => Token.fromJson(model)));
  }

  static Future<GasFee> getGasFee() async {
    var response = await get(
        Uri.parse("http://134.209.240.201/api/v2/balance/getgasfee"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
        });
    return GasFee.fromJson(jsonDecode(response.body));
  }

  static Future<User> getUserById(int id, String jwt) async {
    var response = await get(
        Uri.parse("http://134.209.240.201/api/v2/users/getbyid/$id"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        });
    return User.fromJson(jsonDecode(response.body));
  }

  static Future<List<NFT>> loadNFTs(String jwt, String wallet) async {
    var response = await get(
        Uri.parse("http://134.209.240.201/api/v2/balance/nfts/$wallet"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        });
    Iterable l = json.decode(response.body);
    return List<NFT>.from(l.map((model) => NFT.fromJson(model)));
  }

  static Future<List<TokenTransaction>> loadTokenTransactions(
      String jwt, String wallet, String ticker) async {
    var response = await get(
        Uri.parse(
            "http://134.209.240.201/api/v2/balance/gettransactions/$wallet/ticker/$ticker"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        });
    Iterable l = json.decode(response.body);
    return List<TokenTransaction>.from(
        l.map((model) => TokenTransaction.fromJson(model)));
  }

  static Future<Response> editUser(
      String jwt, int id, String key, String value) async {
    return await put(Uri.parse("http://134.209.240.201//api/v2/users/edit/$id"),
        headers: {
          "accept": "text/plain",
          "Content-Type": "application/json-patch+json",
          'Authorization': 'Bearer $jwt',
        },
        body: json.encode({key: value}));
  }
}
