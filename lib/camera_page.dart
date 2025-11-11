import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // 1. Lấy danh sách các camera có sẵn
    final cameras = await availableCameras();
    // 2. Lấy camera đầu tiên (thường là camera sau)
    final firstCamera = cameras.first;

    // 3. Tạo và khởi tạo CameraController
    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller!.initialize();
    
    // Cập nhật lại UI sau khi khởi tạo xong
    if (mounted) {
      setState(() {});
    }
  }
  
  Future<void> _takePicture() async {
    // Đảm bảo controller đã được khởi tạo
    await _initializeControllerFuture;

    try {
      final image = await _controller!.takePicture();
      setState(() {
        _capturedImage = image;
      });
    } catch (e) {
      print("Lỗi khi chụp ảnh: $e");
    }
  }

  @override
  void dispose() {
    // Rất quan trọng: Hủy controller để giải phóng tài nguyên camera
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chụp Ảnh')),
      body: Column(
        children: [
          Expanded(
            child: _capturedImage != null
                ? Center(child: Image.file(File(_capturedImage!.path)))
                : FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // Nếu Future hoàn thành, hiển thị preview
                        return CameraPreview(_controller!);
                      } else {
                        // Ngược lại, hiển thị loading
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: FloatingActionButton(
                onPressed: _takePicture,
                child: const Icon(Icons.camera_alt),
              ),
            ),
          )
        ],
      ),
    );
  }
}
