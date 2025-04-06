import 'package:flutter/material.dart';
import 'package:app_icon_editor/icon_content.dart';

/// iOSアプリアイコンのプレビューウィジェット
class IOSPreview extends StatelessWidget {
  final GlobalKey repaintKey;
  final Widget iconContent;
  final double previewSize;
  final Map<String, dynamic> platformInfo;

  const IOSPreview({
    super.key,
    required this.repaintKey,
    required this.iconContent,
    required this.previewSize,
    required this.platformInfo,
  });

  @override
  Widget build(BuildContext context) {
    final cornerRadius = platformInfo['corner_radius'] as double;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'iOS App Icon (${platformInfo['size']}×${platformInfo['size']}px)',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // iOSアイコンプレビュー
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(previewSize * cornerRadius)),
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
                    // プレビュー表示用のクリップされたコンテナ
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(previewSize * cornerRadius),
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
                'App Store Icon: ${platformInfo['size']}×${platformInfo['size']}px',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
