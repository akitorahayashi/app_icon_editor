import 'package:flutter/material.dart';

/// アイコンのダウンロードセクションを表示するウィジェット
class DownloadSection extends StatelessWidget {
  /// 選択されているプラットフォーム
  final String selectedPlatform;

  /// エクスポート中かどうか
  final bool isExporting;

  /// エクスポートメッセージ
  final String? exportMessage;

  /// アイコンのサイズ
  final int currentSize;

  /// エクスポートボタンが押されたときの処理
  final VoidCallback onExport;

  /// プラットフォーム別のエクスポート説明文を取得する関数
  final String Function() getExportDescription;

  const DownloadSection({
    super.key,
    required this.selectedPlatform,
    required this.isExporting,
    required this.exportMessage,
    required this.currentSize,
    required this.onExport,
    required this.getExportDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$selectedPlatformアイコンをエクスポート',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // プラットフォーム別情報
            Text(
              getExportDescription(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('PNG形式でダウンロード'),
              onPressed: isExporting ? null : onExport,
            ),

            if (isExporting)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: LinearProgressIndicator(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      exportMessage ?? 'アイコンを生成中...',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
