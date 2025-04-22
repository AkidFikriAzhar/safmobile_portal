import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({super.key});

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isScanned = false; // Tambah kat atas class

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (_isScanned) return; // Skip kalau dah scan

      final scannedUrl = scanData.code.toString();
      log('Scanned URL: $scannedUrl');

      final safmobileUrl = scannedUrl.contains('portal.safmobile.my');

      if (safmobileUrl) {
        try {
          final uri = Uri.parse(scannedUrl);
          String fragmentOrPath;

          if (uri.fragment.isNotEmpty) {
            fragmentOrPath = uri.fragment;
          } else {
            fragmentOrPath = uri.pathSegments.join('/');
          }

          final parts = fragmentOrPath.split('/');

          if (parts.length >= 4) {
            final locationRoute = parts[1];
            final uuid = parts[2];
            final ticketId = parts[3];

            _isScanned = true; // Set supaya tak scan semula

            if (!mounted) return;

            context.pushReplacementNamed(
              locationRoute,
              pathParameters: {
                'uid': uuid,
                'ticketId': ticketId,
              },
            );
          } else {
            log('URL format tidak lengkap');
          }
        } catch (e) {
          log('Gagal parse URL: $e');
        }
      } else {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Tidak dapat membuka URL'),
              content: const Text('URL tidak valid atau tidak didukung.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scan'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
