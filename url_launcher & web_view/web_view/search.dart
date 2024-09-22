import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS/macOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class Search extends StatefulWidget {
  late String input;

  Search(this.input);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // 플랫폼에 따라 WebViewController 생성 시 파라미터를 다르게 설정
    late final PlatformWebViewControllerCreationParams params;

    // iOS 및 macOS의 경우 WebKitWebViewControllerCreationParams
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        // 웹 페이지 내에서 인라인으로 미디어가 재생될 수 있는지 여부를 결정, true인 경우 비디오를 전체 화면 모드로 전환되지 않고 지정된 위치에서 인라인으로 재생
        allowsInlineMediaPlayback: true,
        // 어떤 미디어 타입들이 사용자 상호작용(제스처 등)을 필요로 하는지를 결정, {}에 넣는 값에 따라 웹이 재생되자마자 비디오가 바로 재생되지 않게 할 수 있음
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else { // 안드로이드일 경우 PlatformWebViewControllerCreationParams
      params = const PlatformWebViewControllerCreationParams();
    }

    // 실행되는 플랫폼에 따라 WebViewController가 생성
    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);

    // controller 객체의 여러 메소드를 체인(..)으로 연결해 한 번에 적용
    controller
    // JavaScript 사용 모드 설정, unrestricted을 통해  JavaScript가 제한 없이 실행 이를 통해 동적 웹 콘텐츠를 처리할 수 있다.
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
    // WebView 배경색 설정
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          // 페이지 로딩 진행 상태를 표시
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          // 페이지 로딩이 시작될 때 호출
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          // 페이지 로딩이 완료되었을 때 호출
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          // 페이지 로딩 중 오류가 발생했을 때 처리
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
            Page resource error:
            code: ${error.errorCode}
            description: ${error.description}
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
           ''');
          },
          // WebView에서 새 페이지로 이동하려고 할 때 호출
          onNavigationRequest: (NavigationRequest request) {
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate; // url 로드 허용
          },
        ),
      )
    // JavaScript 코드와 Flutter 앱 간의 통신을 가능하게 함
      ..addJavaScriptChannel(
        'Toaster',  // 채널 이름
        // 콜백 함수로 자바스크립트로부터 메시지를 받았을 때 호출
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
    // 웹 페이지 로드
      ..loadRequest(Uri.parse('https://ko.wikipedia.org/wiki/${widget.input}'));

    // 플랫폼이 안드로이드일 경우 WebView의 특정 기능 설정
    if (controller.platform is AndroidWebViewController) {
      // WebView 디버깅 활성화
      AndroidWebViewController.enableDebugging(true);
      // 미디어 자동 재생 허용, 사용자가 명시적으로 동작(클릭)을 하지 않아도 비디오나 오디오가 바로 재생
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace),
        ),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}