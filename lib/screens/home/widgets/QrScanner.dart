import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: MobileScanner(onDetect: (barcode, args){
        Navigator.pop(context, barcode.rawValue);
      },)
    );
  }
}
