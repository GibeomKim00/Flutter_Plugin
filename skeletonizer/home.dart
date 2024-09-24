import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skeletonizer Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[800],
          ),
        ),
        extensions: const [
          SkeletonizerConfigData(),  // 기본 테마에 Skeletonizer 설정
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[300],
          ),
        ),
        extensions: const [
          SkeletonizerConfigData.dark(),  // 다크 테마에 Skeletonizer 설정
        ],
      ),
      themeMode: ThemeMode.system,  // 시스템 설정에 따라 테마 전환
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;
  double num = 8;

  @override
  void initState() {
    super.initState();
    // 3초 후에 로딩 완료된 것으로 가정
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skeletonizer Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SkeletonizerConfig(
          data: SkeletonizerConfigData(
            effect: const ShimmerEffect(),  // 반짝이는 애니메이션
            justifyMultiLineText: true,  // 여러 줄 텍스트 정렬
            ignoreContainers: false,  // 컨테이너 포함 여부 설정
          ),
          child: _isLoading ? _buildSkeleton() : _buildContent(context),
        ),
      ),
    );
  }

  // 로딩 중에 표시될 뼈대 UI
  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 원형 아바타
        Skeletonizer(
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
          ),
        ),
        SizedBox(height: 20),
        // 제목 텍스트
        Skeletonizer(
          child: Container(
            height: 24,
            width: 200,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: 10),
        // 본문 텍스트 (여러 줄)
        Skeletonizer(
          child: Container(
            height: 16,
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: 10),
        Skeletonizer(
          child: Container(
            height: 16,
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: 20),
        // 버튼
        Skeletonizer(
          child: Container(
            height: 48,
            width: 150,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  // 로딩 완료 후 표시될 실제 콘텐츠
  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
        ),
        SizedBox(height: 20),
        Text(
          'Kim',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 10),
        Text(
          'This is the description of Kim.',
          style: Theme.of(context).textTheme.bodyMedium,  // bodyMedium 사용
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          child: Text('Follow'),
        ),
      ],
    );
  }
}
