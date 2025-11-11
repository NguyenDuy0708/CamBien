import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({Key? key}) : super(key: key);

  @override
  _BluetoothPageState createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;

  @override
  void initState() {
    super.initState();
    // Lắng nghe trạng thái của adapter Bluetooth
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.off) {
        // Xử lý khi Bluetooth bị tắt
        _stopScan();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bluetooth đã bị tắt')));
      }
    });

    // Lắng nghe kết quả quét
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      // Cập nhật danh sách thiết bị, loại bỏ các thiết bị không có tên
      setState(() {
        _scanResults = results.where((r) => r.device.platformName.isNotEmpty).toList();
      });
    }, onError: (e) {
      print("Lỗi khi quét: $e");
    });
  }
  
  @override
  void dispose() {
    _stopScan();
    _scanResultsSubscription.cancel();
    _adapterStateSubscription.cancel();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
    });
    try {
      // Bắt đầu quét trong 5 giây
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    } catch (e) {
      print("Lỗi khi bắt đầu quét: $e");
    }
    // Dừng quét sau khi timeout
    if (mounted) {
       _stopScan();
    }
  }

  void _stopScan() {
    FlutterBluePlus.stopScan();
    setState(() {
      _isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét Bluetooth'),
      ),
      body: ListView.builder(
        itemCount: _scanResults.length,
        itemBuilder: (context, index) {
          final result = _scanResults[index];
          return ListTile(
            leading: const Icon(Icons.bluetooth),
            title: Text(result.device.platformName),
            subtitle: Text(result.device.remoteId.toString()),
            trailing: Text('${result.rssi} dBm'), // Hiển thị cường độ tín hiệu
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isScanning ? _stopScan : _startScan,
        child: Icon(_isScanning ? Icons.stop : Icons.search),
      ),
    );
  }
}
