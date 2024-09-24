# skeletonizer 

* 화명 로딩 시 사용자의 경험을 향상시켜주는 플로그인이다.

### 사용 방법
1. 가짜 데이터 만들기
    * users가 비어있으면 layout이 없기에 skeletonize가 할게 없다.
    ```
    Skeletonizer(
        enabled: _loading,
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                        title: Text(users[index].name),
                        subtitle: Text(users[index].jobTitle),
                        leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(users[index].avatar),
                        ),
                    ),
                );
            },
        ),
    )
    ```

    * 따라서 실제 데이터가 오기 전까지 가짜 데이터를 만들어서 보여준다.
    ```
    if (_loading) {
        final fakeUsers = List.filled(7, User(
                name: 'User name',
                jobTitle: 'Developer',
                avatar: ''
            ),
        );
        return Skeletonizer(
            child: UserList(users: fakeUsers),
        );
    } else {
        return UserList(users: realUsers);
    }  
    ```

    * 또는 Skeletonizer의 enabled 속성을 이용할 수도 있다. _loading이 참일 경우 7개의 가짜 User를 보여준다.
    ```
    final users = _loading ? List.filled(
        7, const User(
        name: 'User name',
        jobTitle: 'Developer',
        avatar: ''
    ) : realUsers;
    );
    return Skeletonizer(
        enabled: _loading,
        child: UserList(users: users),
    );
    ```

    * BoneMock를 이용하여 가짜 데이터를 쉽게 생성할 수도 있다.
    ```
    final fakeUsers = List.filled(7, User(
        name: BoneMock.name,
        jobTitle: BoneMock.words(2),
        email: BoneMock.email,
        createdAt: BoneMock.date, 
      ),
    );
    ```

2. run 시 발생하는 오류 고치기
    * fake avatar url이 비어있는 string이기에 다음과 같은 오류가 발생한다("an invalid url was passed to **NetworkImage**"). skeleton annotation인 **Skeleton.replace**을 이용하여 skeletonizer가 이용 가능할 때 NetworkImage가 Widget tree에 없도록 해야 한다.

    * _loading이 true이면 가짜 뼈대를 false이면 실제 데이터를 보여준다.

    * 'Skeleton.replace': 로딩 중일 때 아바타 대신 표시할 대체 View이다.

    * 'child: CircleAvatar': 실제 로딩이 끝났을 때 사용자 아바타 이미지가 표시되는 곳이다.

    * 'NetworkImage(users[index].avatar)': 각 사용자의 아바타 이미지를 네트워크에서 불러옵니다.
    ```
    Skeletonizer(
        enabled: _loading,
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                    title: Text(users[index].name),
                    subtitle: Text(users[index].jobTitle),
                    leading: Skeleton.replace(
                        width: 48, // width of replacement
                        height: 48, // height of replacement
                        child: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(users[index].avatar),
                        ),
                    ),
                ),
            );
            },
        ),
    )
    ```

    * 또는 아래와 같이 할 수도 있다.
    ```
    Skeletonizer(
        enabled: _loading,
        child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
                return Card(
                    child: ListTile(
                        title: Text(users[index].name),
                        subtitle: Text(users[index].jobTitle),
                        leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: _loading ? null : NetworkImage(users[index].avatar),
                        ),
                    ),
                );
            },
        ),
    )
    ```

※ 하위 위젯에서 다음 코드를 통해 skeletonizer가 활성화되어 있는지 확인할 수 있다.
```
Skeletonizer.of(context).enabled;
```

### Annotations
* annotations를 이용하여 일부 위젯의 skeletonize하는 방법을 바꿀 수 있다. 단, 실제 레이아웃에는 영향을 주지 않는다.

1. Skeleton.ignore
    * 위 코드로 표시된 위젯은 skeletonize 되지 않는다.
    ```
    Card(
        child: ListTile(
            title: Text('The title goes here'),
            subtitle: Text('Subtitle here'),
            trailing: Skeleton.ignore( // the icon will not be skeletonized
                child: Icon(Icons.ac_unit, size: 40),
            ),
        ),
    )
    ```

2. Skeleton.lead
    *  leafs are painted using the shader paint.
    ```
    Skeleton.leaf(
        child : Card(
            child: ListTile(
                title: Text('The title goes here'),
                subtitle: Text('Subtitle here'),
                trailing: Icon(Icons.ac_unit, size: 40),
            ),
        )
    )
    ```

3. Skeleton.keep
    * skeletonize 되지 않고 다음과 같이 paint된다.
    ```
    Card(
        child: ListTile(
            title: Text('The title goes here'),
            subtitle: Text('Subtitle here'),
            trailing: Skeleton.keep( // the icon will be painted as is
            child: Icon(Icons.ac_unit, size: 40),
            ),
        ),
    )
    ```

4. Skeleton.shade
    * skeletonize 되지 않고 다음과 같이 만들어 진다.
    ```
    Card(
        child: ListTile(
            title: Text('The title goes here'),
            subtitle: Text('Subtitle here'),
            trailing: Skeleton.shade( // the icon will be shaded by shader mask
            child: Icon(Icons.ac_unit, size: 40),
            ),
        ),
    )
    ```

5. Skeleton.replace
    * skeletionizer가 사용 가능해질 때 대체된다.

    * Image.network와 같이 render가 되지 않는 위젯에 사용하기 좋다.
    ```
    Card(
        child: ListTile(
            title: Text('The title goes here'),
            subtitle: Text('Subtitle here'),
            trailing: Skeleton.replace( // the icon will be replaced when skeletonizer is enabled
                width: 50, // the width of the replacement
                height: 50, // the height of the replacement
                replacement: // defaults to a DecoratedBox
                child: Icon(Icons.ac_unit, size: 40),
            ),
        )
    )
    ```

6. Skeleton.unite
    * 작은 bone들이 여러 개 붙어 있고 그것을 하나의 bone으로 만들고 싶을 때 유용하다.
    ```
    Card(
        child: ListTile(
            title: Text('Item number 1 as title'),
            subtitle: Text('Subtitle here'),
            trailing: Skeleton.unite(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        Icon(Icons.ac_unit, size: 32),
                        SizedBox(width: 8),
                        Icon(Icons.access_alarm, size: 32),
                    ],
                ),
            ),
        ),
    )
    ```

7. Skeleton.ignorePointers
    * skeletonizer가 사용 가능할 때 pointer event를 무시한다.


### Creating Skeletons manually
* Bone 위젯을 이용하여 skeleton을 만들 수 있다.

* Bone.button()과 Bone.iconButton() 또한 존재한다.

* Bone Widget만 음영 처리가 되고 cards, containers 등과 같은 다른 색상의 위젯을 음영 처리 걱정 없이 포장할 수 있다.

* Card의 내용이 로딩 상태일 때 Bone으로 감싸진 요소들이 뼈대 형태로 나타난다.
```
Skeletonizer.zone(
    child: Card(
      child: ListTile(
        leading: Bone.circle(size: 48),  
        title: Bone.text(words: 2),
        subtitle: Bone.text(),
        trailing: Bone.icon(), 
      ),
    ),
 );
```

### Customization 
* Skeletonizer 위젯의 effect 속성을 통해 애니메이션 효과를 바꿀 수 있다. 

* child 속성에는 로딩 중일 보여질 뼈대 UI 위젯을 설정한다.
```
Skeletonizer(
  effect: const ShimmerEffect(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    duration: Duration(seconds: 1),
  ),
  child: ...
)
```

* 'enableSwitchAnimation' true를 통해 skeleton과 content간의 전환을 애니메이션화할 수 있다.

* animation은 'SwitchAnimationConfig'을 통해 customize할 수 있다.
```
SwitchAnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.reverseDuration,
}); 
```

* 'SkeletonizerConfigData'를 이용해 모든 skeletonizer widget에 기본 설정을 제공할 수 있다. 또는 'SkeletonizerConfig'을 이용해 하위 Skeletonizer widget한테 줄 수 있다.
```
MaterialApp(
  theme: ThemeData(
    extensions: const [
      SkeletonizerConfigData(), // default constructor has light theme config
    ],
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    extensions: const [
      SkeletonizerConfigData.dark(), // dark theme config
    ],
  ),
  ...
)
```
```
SkeletonizerConfig(
    data: SkeletonizerConfigData(
      effect: const ShimmerEffect(),
      justifyMultiLineText: true,
      textBorderRadius: TextBoneBorderRadius(..),
      ignoreContainers: false,
    ),
    .....
)
```
=====> TextBoneBprderRadius ?? 




## 몰랐던 코드
1. final users = _loading ? A : B;
    * 삼항 연산자로 _loading이 참일 경우 users에 A를 대입

2. List.filled(int length, E fill, {bool growable = false})
    * 특정 크기의 list를 생성하는 코드 
    
    * 첫 번째 매개변수로는 생성할 리스트의 크기 값을, 두 번째 매개변수에는 리스트에 넣을 동일한 요소를 넣는다. 마지막 매개변수는 true일 경우 생성된 list에 요소를 추가하거나 제거할 수 있게한다.

3. ListView.builder
    * itemCount 속성에 지정된 값만큼 리스트 아이템을 동적으로 생성한다.

    * itemBuilder 속성은 각 인덱스에 맞는 위젯을 반환한다.

4. ListTile
    * 하나의 리스트 항목에 대해 간단하게 아이콘, 제목, 부제목 등의 레이아웃을 설정할 수 있다.

    * leading 속성: 리스트 항목의 시작 부분에 위치하는 위젯
 
    * title 속성: 큰 텍스트 또는 중요한 정보 표시, Text 위젯을 주로 사용

    * subtitle 속성: 부제목이나 추가 설명을 나타내는 텍스트

    * trailing 속성: 리스트 항목의 끝 부분에 위치하는 위젯

    * onTap 속성: ListTile이 클릭되었을 때 실행될 동작을 정의하는 콜백 함수