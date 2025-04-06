# App Icon Editor

## Features

- iOS, Android に対応
  - iOS (1024×1024px)
  - Android (512×512px)
- リアルタイムプレビュー
  - ホットリロード
  - プラットフォームごとの形状に合わせたプレビュー
- PNGエクスポート
  - プラットフォームごとに最適なサイズで高解像度の1枚分出力
  - 背景色を含む完全な正方形での出力

## Project Structure

```
lib/
├── main.dart                   
├── icon_content.dart           # アイコンを制作する画面
├── view/
│   ├── app_icon_preview_screen.dart    
│   └── platform_preview/            
│       ├── ios_preview.dart
│       └── android_preview.dart
└── util/
    └── export_util.dart        # アイコンをエクスポートする機能

```

## Getting Started

1. アイコンのカスタマイズ
   - `lib/icon_content.dart` を編集してアイコンのデザインを変更
   - Flutterのウィジェットを使用して自由にデザイン可能

2. プレビュー
   - 画面上部のセグメントコントロールでプラットフォームを切り替え
   - 各プラットフォームの形状（iOS: 角丸正方形、Android: 円形）で即時プレビュー

3. エクスポート
   - 「PNG形式でダウンロード」ボタンをクリック
   - プラットフォームごとに適切なサイズでPNGファイルが生成
   - ファイル名は `{platform}_icon_{size}x{size}.png` の形式

## Customization Guide

`lib/icon_content.dart` を編集してアイコンをカスタマイズできます。

```dart
class IconContent extends StatelessWidget {
  final double? size;
  
  const IconContent({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Icon(
          Icons.star,
          size: (size ?? 100) * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}
```

## Development Environment

- Flutter: 3.29.2
- Dart: 3.3.2
- プラットフォーム: Web
