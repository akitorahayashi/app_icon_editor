import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_icon_editor/view/component/download_section.dart';

void main() {
  group('ダウンロードセクションのテスト', () {
    testWidgets('プラットフォーム情報が正しく表示されること', (WidgetTester tester) async {
      // アプリをビルドしてフレームを更新
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DownloadSection(
              selectedPlatform: 'iOS',
              isExporting: false,
              exportMessage: null,
              currentSize: 1024,
              onExport: () {},
              getExportDescription: () => 'Test description',
            ),
          ),
        ),
      );

      // プラットフォームのタイトルが表示されていることを確認
      expect(find.text('iOSアイコンをエクスポート'), findsOneWidget);

      // 説明文が表示されていることを確認
      expect(find.text('Test description'), findsOneWidget);

      // ダウンロードボタンのテキストが表示されていることを確認
      expect(find.text('PNG形式でダウンロード'), findsOneWidget);
    });

    testWidgets('エクスポート中はローディング状態が表示されること', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DownloadSection(
              selectedPlatform: 'Android',
              isExporting: true,
              exportMessage: 'Exporting...',
              currentSize: 512,
              onExport: () {},
              getExportDescription: () => 'Test description',
            ),
          ),
        ),
      );

      // プラットフォームのタイトルが表示されていることを確認
      expect(find.text('Androidアイコンをエクスポート'), findsOneWidget);

      // ローディングインジケータが表示されていることを確認
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      // エクスポートメッセージが表示されていることを確認
      expect(find.text('Exporting...'), findsOneWidget);

      // ダウンロードボタンのテキストが表示されていることを確認
      expect(find.text('PNG形式でダウンロード'), findsOneWidget);
    });
  });
}
