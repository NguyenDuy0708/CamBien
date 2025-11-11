import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({Key? key}) : super(key: key);

  @override
  _BiometricPageState createState() => _BiometricPageState();
}

class _BiometricPageState extends State<BiometricPage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isUnlocked = false;
  bool _isSupported = false;

  @override
  void initState() {
    super.initState();
    // Kiểm tra xem thiết bị có hỗ trợ sinh trắc học không
    _auth.isDeviceSupported().then((isSupported) {
      setState(() {
        _isSupported = isSupported;
      });
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Vui lòng xác thực để mở khóa',
        options: const AuthenticationOptions(
          stickyAuth: true, // Giữ hộp thoại xác thực mở khi app vào nền
        ),
      );
    } on PlatformException catch (e) {
      print("Lỗi xác thực: $e");
      // Có thể xử lý các lỗi cụ thể ở đây
      return;
    }
    if (!mounted) return;

    setState(() {
      _isUnlocked = authenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác thực Sinh trắc học'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isUnlocked ? Icons.lock_open : Icons.lock,
              size: 150,
              color: _isUnlocked ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              _isUnlocked ? 'Đã mở khóa' : 'Đã khóa',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: _isUnlocked ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            if (_isSupported)
              ElevatedButton.icon(
                onPressed: _authenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text('Xác thực'),
              )
            else
              const Text('Thiết bị không hỗ trợ sinh trắc học.'),
          ],
        ),
      ),
    );
  }
}
