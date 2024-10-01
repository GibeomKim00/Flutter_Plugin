# Animated-login

### AnimatedLogin 위젯
* onLogin: login button이 눌렸을 때, callback될 LoginCallback 함수를 만들어서 전달한다. 이때 LoginCallback 함수의 매개변수로 LoginData를 주며 이를 통해 사용자가 입력한 email, password 값을 받을 수 있다.

* onSignup: signup button을 눌렀을 때, callback될 SignupCallback 함수를 만들어서 전달한다. 이때 SignupCallback 함수의 매개변수로 SignUpData를 주며 이를 통해 사용자가 입력한 name, email, password, confirmPassword를 받을 수 있다.

* onForgotPassword: callback될 함수 만들어서 전달

* socialLogins: List\<SocialLogin>, 이 속성을 통해 사옹자에게 Google, Facebook 등 다양한 소셜 플랫폼을 이용한 로그인 옵션을 제공할 수 있다.

* logo: Widget, 화면 상단에 이미지 및 로고를 추가할 수 있다.

* signUpMode: SignUpModes(name, confirmPassword, both), 기본적으로 필요한 정보(Email, Password)를 제외하고 받을 정보를 추가로 설정할 수 있다.

* loginMobileTheme(loginDesktopTheme): LoginViewTheme, 모바일/컴퓨터를 통해 보이는 글자 색/배경 색/오류 색 등등을 customizing할 수 있음

* loginTexts: LoginTexts, LoginTexts에는 login(로그인 버튼의 텍스트), signUp(회원가입 버튼의 텍스트), nameHint/emailHint/passwordHint(각 입력 필드에 표시될 힌트 텍스트), forgotPassword(비밀번호 찾기 옵션의 텍스트)등 다양한 속성들이 있다..

* languageOptions: List\<LanguageOption>, 사용자가 앱에서 사용할 언어를 선택할 수 있게 해준다. LanguageOption은 value(언어의 이름), code(언어의 코드), iconPath(해당 언어에 대한 아이콘 경로)의 속성이 있다.

* selectedLanguage: LanguageOption, 사용자가 선택한 언어를 저장한다.

* changeLanguageCallback: ChangeLanguageCallback, 사용자가 새로운 언어를 선택하면 이 콜백 함수가 실행된다. 이 함수는 LanguageOption 객체를 인자로 받는다.

* initialMode: 초기 인증 모드를 설정하는 속성으로 회원가입 모드로 시작할지, 로그인 모드로 시작할지를 지정할 수 있다(AuthMode.login, AuthMode.signup).

* onAuthModeChange: 인증 모드가 변경될 때 호출되는 콜백 함수이다. 즉, 사용자가 로그인 모드에서 회원가입 모드로, 또는 회원가입 모드에서 로그인 모드로 전환할 때 이 콜백 함수가 실행된다. 변경된 모드를 매개변수로 받아 처리할 수 있다.