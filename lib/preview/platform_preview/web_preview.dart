import 'package:flutter/material.dart';

/// Webアプリアイコンのプレビューウィジェット
class WebPreview extends StatelessWidget {
  final GlobalKey repaintKey;
  final Widget iconContent;
  final double previewSize;
  final Map<String, dynamic> platformInfo;

  const WebPreview({
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
                'Web App Icon (${platformInfo['size']}×${platformInfo['size']}px)',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            // Webアイコンプレビュー（正方形）
            RepaintBoundary(
              key: repaintKey,
              child: SizedBox(
                width: previewSize,
                height: previewSize,
                child: iconContent,
              ),
            ),
            const SizedBox(height: 16),

            // サイズ情報
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'PWA Icon: ${platformInfo['size']}×${platformInfo['size']}px',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 16),
                const Text('Favicon: 32×32px',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
