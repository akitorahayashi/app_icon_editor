import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_icon_editor/view/component/download_section.dart';

void main() {
  group('ダウンロードセクションのテスト', () {
    testWidgets('通常状態での表示と操作が正しく動作すること', (WidgetTester tester) async {
      bool exportCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DownloadSection(
              selectedPlatform: 'iOS',
              isExporting: false,
              exportMessage: null,
              currentSize: 1024,
              onExport: () => exportCalled = true,
              getExportDescription: () => 'iOSアプリ用のアイコンをエクスポートします',
            ),
          ),
        ),
      );

      // 基本的なUIの表示を確認
      expect(find.text('iOSアイコンをエクスポート'), findsOneWidget);
      expect(find.text('iOSアプリ用のアイコンをエクスポートします'), findsOneWidget);
      expect(find.text('PNG形式でダウンロード'), findsOneWidget);

      // プログレスバーが表示されていないことを確認
      expect(find.byType(LinearProgressIndicator), findsNothing);

      // ボタンをタップしてonExportが呼ばれることを確認
      await tester.tap(find.text('PNG形式でダウンロード'));
      expect(exportCalled, isTrue);
    });

    testWidgets('エクスポート中は適切に状態が制御されること', (WidgetTester tester) async {
      bool exportCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DownloadSection(
              selectedPlatform: 'Android',
              isExporting: true,
              exportMessage: 'エクスポート中...',
              currentSize: 512,
              onExport: () => exportCalled = true,
              getExportDescription: () => 'Androidアプリ用のアイコンをエクスポートします',
            ),
          ),
        ),
      );

      // 基本的なUIの表示を確認
      expect(find.text('Androidアイコンをエクスポート'), findsOneWidget);
      expect(find.text('Androidアプリ用のアイコンをエクスポートします'), findsOneWidget);
      expect(find.text('PNG形式でダウンロード'), findsOneWidget);

      // エクスポート中の状態表示を確認
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('エクスポート中...'), findsOneWidget);

      // エクスポート中はボタンをタップしてもonExportが呼ばれないことを確認
      await tester.tap(find.text('PNG形式でダウンロード'), warnIfMissed: false);
      expect(exportCalled, isFalse);
    });

    testWidgets('プラットフォーム切り替えで表示が更新されること', (WidgetTester tester) async {
      String currentPlatform = 'iOS';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DownloadSection(
              selectedPlatform: currentPlatform,
              isExporting: false,
              exportMessage: null,
              currentSize: 1024,
              onExport: () {},
              getExportDescription: () => '$currentPlatformアプリ用のアイコンをエクスポートします',
            ),
          ),
        ),
      );

      // iOS用の表示を確認
      expect(find.text('iOSアイコンをエクスポート'), findsOneWidget);
      expect(find.text('iOSアプリ用のアイコンをエクスポートします'), findsOneWidget);

      // Androidに切り替え
      currentPlatform = 'Android';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DownloadSection(
              selectedPlatform: currentPlatform,
              isExporting: false,
              exportMessage: null,
              currentSize: 512,
              onExport: () {},
              getExportDescription: () => '$currentPlatformアプリ用のアイコンをエクスポートします',
            ),
          ),
        ),
      );
      await tester.pump();

      // Android用の表示に更新されていることを確認
      expect(find.text('Androidアイコンをエクスポート'), findsOneWidget);
      expect(find.text('Androidアプリ用のアイコンをエクスポートします'), findsOneWidget);
    });
  });
}
