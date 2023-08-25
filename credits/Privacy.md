# 此处为Little Limbo Launcher中的隐私方法中的常量声明以及方法声明部分

## 以下为新建单元格式：

- 切记，此处所有常量与函数都可以为空，但是假如为空的话，你将无法使用这些量。

```pascal
unit PrivacyMethod

interface

implementation

end.
```
### 账号部分的Microsoft AZure Client ID【常量】

- 在interface和implementation之间，新建一个常量：

```pascal
const
	MS_CLIENT_ID = '<你的Microsoft AZure Client ID>';
```

- 此部分用于账号部分中的Microsoft OAuth验证流登录部分。
- **注意**，该量可以填入空值，但假如填入空值，你将无法使用OAuth登录。

### 游戏部分的CurseForge API Key【常量】

- 同上

```pascal
	CF_API_KEY = '<你的CurseForge API Key>';
```

- 此部分用于游戏部分的CurseForge下载源时使用。
- **注意**，该量可以填入空值，但假如填入空值，你将无法使用游戏部分的CurseForge模组下载。

### 主界面的解密游戏【函数】

- 在implementation上方写一个此函数的声明，然后在implementation下方写该函数的实现。

```pascal
function PuzzleGetWeb(days: Integer): String;
function PuzzleEnter(value: String; days: Integer): Boolean;
```
- 其中，days指的是当前天在一年的时间，假设现在是12月31日，就说明days填365，如果现在是1月1日，就说明days填1。
- PuzzleEnter中多了一个value，这个value填入你所写的答案，如果答案正确，则返回true，否则返回false。

- 此部分用于主界面中的解密游戏。

### 国际登录设置代码【常量】

```pascal
	NATIONAL_LOGIN_CODE = '<随便输入一个>'
```

- 此部分用于为你生成一个独立的国际代码，如果你身处的国家不是中国，则你需要登录一次微软之后，才能使用离线登录，否则你将无法导出启动参数，启动游戏的话，也只能通过试玩模式启动。
- 这个代码用于验证你是否已经登录过微软了。
- ps：你们当然可以填入空值，空值可以通过编译，无论填什么值都可以，但是即使使用了空值，或者无论你使用了任何一个值，你依旧需要登录一次正版账号。
- 该操作仅针对于国外玩家，对于中国玩家则无需管理。

#### 具体使用的位置可以自行查看源码！