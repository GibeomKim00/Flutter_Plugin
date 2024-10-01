import 'package:animated_login/animated_login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedLogin(
          logo: Image.asset('assets/logo.png'), // 로고 이미지
          onLogin: (LoginData data) async {
            print('Login: ${data.email}, ${data.password}');
            return null; // 로그인 성공
          },
          onSignup: (SignUpData data) async {
            print('Signup: ${data.name}, ${data.email}, ${data.password}');
            return null;
          },
          onForgotPassword: (email) async {
            print('Forgot Password: $email');
            return null;
          },
          signUpMode: SignUpModes.both, // 회원가입 시 이름과 비밀번호 확인
          loginMobileTheme: LoginViewTheme(
            backgroundColor: Colors.indigo, // 배경 색상
            formFieldBackgroundColor: Colors.white,
            formFieldBorderRadius: BorderRadius.circular(15),
            textFormStyle: const TextStyle(color: Colors.black, fontSize: 18),
            focusedBorderColor: Colors.black, // 포커스 시 테두리 색
            errorTextStyle: const TextStyle(color: Colors.red),
            formWidthRatio: 50, // 폼의 너비 조정
            animationDuration: const Duration(milliseconds: 6), // 애니메이션 속도
            actionButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueAccent), // 버튼 색상
              foregroundColor: MaterialStateProperty.all(Colors.white), // 버튼 텍스트 색
            ),
          ),
          loginTexts: LoginTexts(
            login: '로그인',
            signUp: '회원가입',
            forgotPassword: '비밀번호를 잊으셨나요?',
          ),
        ),
      ),
    );
  }
}
