import 'package:flutter/material.dart';

/// Androidアプリアイコンのプレビューウィジェット
class AndroidPreview extends StatelessWidget {
  final GlobalKey repaintKey;
  final Widget iconContent;
  final double previewSize;
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
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Androidアイコンプレビュー（円形）
            RepaintBoundary(
              key: repaintKey,
              child: ClipOval(
                child: SizedBox(
                  width: previewSize,
                  height: previewSize,
                  child: iconContent,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // サイズ情報
            Text(
                'Play Store Icon: ${platformInfo['size']}×${platformInfo['size']}px',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
