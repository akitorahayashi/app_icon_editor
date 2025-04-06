import 'package:flutter/material.dart';
import 'package:app_icon_editor/icon_content.dart';

/// Androidアプリアイコンのプレビューを表示するウィジェット
class AndroidPreview extends StatelessWidget {
  /// RepaintBoundaryのキー
  final GlobalKey repaintKey;

  /// アイコンのコンテンツ
  final Widget iconContent;

  /// プレビューのサイズ
  final double previewSize;

  /// プラットフォーム情報
  final Map<String, dynamic> platformInfo;

  const AndroidPreview({
    super.key,
    required this.repaintKey,
    required this.iconContent,
    required this.previewSize,
    required this.platformInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Android App Icon (${platformInfo['size']}×${platformInfo['size']}px)',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Androidアイコンプレビュー
            Card(
              elevation: 3,
              shape: const CircleBorder(),
              child: SizedBox(
                width: previewSize,
                height: previewSize,
                child: Stack(
                  children: [
                    // エクスポート用の正方形コンテナ
                    Positioned(
                      left: -9999, // 画面外に配置
                      child: RepaintBoundary(
                        key: repaintKey,
                        child: Container(
                          width: previewSize,
                          height: previewSize,
                          color: Colors.black.withOpacity(0.05),
                          child: iconContent is IconContent
                              ? IconContent(size: previewSize)
                              : iconContent,
                        ),
                      ),
                    ),
                    // プレビュー表示用の円形クリップコンテナ
                    ClipOval(
                      child: Container(
                        width: previewSize,
                        height: previewSize,
                        color: Colors.black.withOpacity(0.05),
                        child: iconContent is IconContent
                            ? IconContent(size: previewSize)
                            : iconContent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // サイズ情報
            Text(
              'Play Store Icon: ${platformInfo['size']}×${platformInfo['size']}px',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
