import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(ContactApp());

class ContactApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactHomePage(),
    );
  }
}

class ContactHomePage extends StatefulWidget {
  @override
  _ContactHomePageState createState() => _ContactHomePageState();
}

class _ContactHomePageState extends State<ContactHomePage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();

  // 전화 걸기
  _launchPhone(String phoneNumber) async {
    // 전화 권한 요청
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      // 권한 요청
      if (await Permission.phone.request().isGranted) {
        // 권한이 허용되면 전화 걸기
        final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
        if (await canLaunchUrl(phoneUri)) {
          await launchUrl(phoneUri);
        } else {
          throw 'Could not launch $phoneNumber';
        }
      } else {
        // 권한 거부 시
        throw 'Phone permission not granted';
      }
    } else {
      // 권한이 이미 허용되어 있으면 바로 전화 걸기
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    }
  }

  // 이메일 보내기
  _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      // 수신자 주소
      path: email,
      query: 'subject=Hello&body=How are you?',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $email';
    }
  }

  // 웹사이트 열기
  _launchURL(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';  // 기본적으로 https:// 추가
    }

    final Uri webUri = Uri.parse(url);

    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 전화번호 입력
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchPhone(_phoneController.text),
              child: Text('Call Phone'),
            ),
            SizedBox(height: 20),

            // 이메일 입력
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Enter Email Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchEmail(_emailController.text),
              child: Text('Send Email'),
            ),
            SizedBox(height: 20),

            // URL 입력
            TextField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                labelText: 'Enter Website URL',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL(_urlController.text),
              child: Text('Open Website'),
            ),
          ],
        ),
      ),
    );
  }
}
