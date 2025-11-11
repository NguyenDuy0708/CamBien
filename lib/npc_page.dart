import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcPage extends StatefulWidget {
  const NfcPage({Key? key}) : super(key: key);

  @override
  _NfcPageState createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  String _scanResult = "Chưa có dữ liệu";
  bool _isScanning = false;

  void _startScan() {
    setState(() {
      _isScanning = true;
      _scanResult = "Đang chờ thẻ NFC...";
    });

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      try {
        // Cố gắng đọc dữ liệu NDEF từ thẻ
        Ndef? ndef = Ndef.from(tag);
        if (ndef == null) {
          setState(() {
            _scanResult = "Thẻ không hỗ trợ NDEF.";
          });
          NfcManager.instance.stopSession();
          return;
        }

        final NdefMessage message = await ndef.read();
        // Lấy bản ghi (record) đầu tiên và giải mã payload
        final record = message.records.first;
        final payload = String.fromCharCodes(record.payload).substring(3); // Bỏ 3 byte header

        setState(() {
          _scanResult = "Đọc thành công:\n$payload";
        });
      } catch (e) {
        setState(() {
          _scanResult = "Lỗi khi đọc thẻ: $e";
        });
      } finally {
        // Dừng session sau khi đọc xong hoặc có lỗi
        NfcManager.instance.stopSession();
        setState(() {
          _isScanning = false;
        });
      }
    });
  }

  void _stopScan() {
    NfcManager.instance.stopSession();
    setState(() {
      _isScanning = false;
      _scanResult = "Đã dừng quét.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đọc thẻ NFC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.nfc,
              size: 150,
              color: _isScanning ? Colors.blue : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              _scanResult,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isScanning ? _stopScan : _startScan,
              child: Text(_isScanning ? 'Dừng Quét' : 'Bắt đầu Quét'),
            )
          ],
        ),
      ),
    );
  }
}
