# online_payment_app

北京交通大学《数据库系统原理》课程设计前端代码。
后端（应用服务器）[在这里](https://github.com/exhyy/online_payment_app_api)。

## 使用

### 安装Flutter开发环境

请参考[Flutter中文文档](https://flutter.cn/docs/get-started/install)。
简单来说，需要安装Flutter SDK和Android Studio，并在Android Studio中安装Android模拟器。

### 配置环境变量
在项目根目录手动新建文件`.env`（该文件会被git忽略），将BASE_URL的值设置为应用服务器的网址。
下面是一个示例：
```bash
BASE_URL = https://www.myexample.com
```

### 获取依赖
在终端运行以下命令
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```
`flutter pub run build_runner build --delete-conflicting-outputs`会根据`.env`生成`lib/env/env.g.dart`文件。如果更新了`.env`中的地址，则需要先执行`flutter clean`，再重新执行上面两条命令，以更新`env.g.dart`文件。需要注意的是，**请不要手动更新`env.g.dart`文件**。

### 调试
请参考[官方文档](https://flutter.cn/docs/get-started/editor)，在VSCode中使用Flutter插件或使用Android Studio。

### 构建APK
参考[官方稳定](https://flutter.cn/docs/deployment/android)中的“为APP签名”一节来配置APK签名文件。然后在终端执行`flutter build apk`即可。

