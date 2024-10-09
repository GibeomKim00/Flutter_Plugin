import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: PermissionHome(),
    );
  }
}

class PermissionHome extends StatefulWidget {
  @override
  _PermissionHomeState createState() => _PermissionHomeState();
}

class _PermissionHomeState extends State<PermissionHome> {
  Future<void> _requestCameraPermission(BuildContext context) async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      if (await Permission.camera.request().isGranted) {
        _showSnackBar(context, '카메라 권한이 허용되었습니다.');
      } else {
        _showSnackBar(context, '카메라 권한이 거부되었습니다.');
      }
    } else {
      _showSnackBar(context, '카메라 권한이 이미 허용되어 있습니다.');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.indigo,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Handler Demo'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _requestCameraPermission(context),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            '카메라 권한 요청',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
