import 'package:exomal_wallet/service/RestClient.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:mnemonic/mnemonic.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/services.dart' show rootBundle;

final String key = "mnemonic";
final String apiUrl = "https://bsc-dataseed.binance.org/";

class RPCService {
  static Future<String> getMyAddressHex(String email) async {
    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    String? _mnemonic = await _storage.read(key: key + (email)) ?? "";

    Credentials credentials =
        EthPrivateKey.fromHex(mnemonicToEntropy(_mnemonic));
    return credentials.address.hex;
  }

  static Future<String> sendBNBTokens(
      String email, String to, double doubleAmount) async {
    final httpClient = Client();
    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    String? _mnemonic = await _storage.read(key: key + (email)) ?? "";

    Credentials credentials =
        EthPrivateKey.fromHex(mnemonicToEntropy(_mnemonic));
    var ethClient = Web3Client(apiUrl, httpClient);

    final amount = BigInt.from(1000000000000000000 * doubleAmount);

    final gasPrice = EtherAmount.inWei(BigInt.from(21 * 1000000000));

    final txHash = await ethClient.sendTransaction(
        credentials,
        Transaction(
          to: EthereumAddress.fromHex(to),
          gasPrice: gasPrice,
          maxGas: 50000,
          value: EtherAmount.inWei(amount),
        ),
        chainId: 56);
    return txHash;
  }

  static Future<String> loadAsset(String assetName) async {
    return await rootBundle.loadString('assets/' + assetName);
  }

  static Future<String> sendEXMLTokens(
      String email, String to, double doubleAmount) async {
    final httpClient = Client();
    final ethClient = Web3Client(apiUrl, httpClient);
    final FlutterSecureStorage _storage = const FlutterSecureStorage();
    String? _mnemonic = await _storage.read(key: key + (email)) ?? "";

    final contractABI = await loadAsset('abi/exomal-abi.json');
    final contractAddress =
        EthereumAddress.fromHex('0x248731d4d8583753C1CfcfCFC765b9A3b885513f');

    Credentials credentials =
        EthPrivateKey.fromHex(mnemonicToEntropy(_mnemonic));

    final contract = DeployedContract(
      ContractAbi.fromJson(contractABI, 'Exomal'),
      contractAddress,
    );

    final recipientAddress = EthereumAddress.fromHex(to);
    final gasPrice = EtherAmount.inWei(BigInt.from(21 * 1000000000));

    final amount =
        BigInt.from(1000000000000000000 * doubleAmount); // Amount in wei

    final function = contract.function('transfer');
    final transaction = Transaction.callContract(
      gasPrice: gasPrice,
      maxGas: 100000,
      contract: contract,
      function: function,
      parameters: [recipientAddress, amount],
    );
    print("Private address:" + credentials.address.hex);
    print(EthPrivateKey.fromHex(mnemonicToEntropy(_mnemonic)).privateKeyInt);
    print("seed" + _mnemonic);
    final txHash =
        await ethClient.sendTransaction(credentials, transaction, chainId: 56);
    return txHash;
  }
}
