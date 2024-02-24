# 此处为Little Limbo Launcher中的隐私方法中的常量声明以及方法声明部分

## 以下为新建单元格式：

- 切记，此处所有常量与函数都可以为空，但是假如为空的话，你将无法使用这些量。

```pascal
unit PrivacyMethod

interface

const
  //在此处添加你的常量值！
  MS_CLIENT_ID = '<你的Microsoft AZure Client ID>';
  CF_API_KEY = '<你的CurseForge API Key>';

implementation

end.
```
### 账号部分的Microsoft AZure Client ID【常量】

- 此部分用于账号部分中的Microsoft OAuth验证流登录部分。
- **注意**，该量可以填入空值，但假如填入空值，你将无法使用OAuth登录。

### 游戏部分的CurseForge API Key【常量】

- 此部分用于游戏部分的CurseForge下载源时使用。
- **注意**，该量可以填入空值，但假如填入空值，你将无法使用游戏部分的CurseForge模组下载。

#### 具体使用的位置可以自行查看源码！