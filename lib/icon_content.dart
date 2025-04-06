import 'package:flutter/material.dart';

/// アイコンコンテンツウィジェット
/// アイコンをカスタマイズする場合は、このファイルのbuildメソッドを編集してください
class IconContent extends StatelessWidget {
  final double? size;

  const IconContent({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final availableSize = size ?? constraints.maxWidth;

        // ===== ここからアイコンデザインを編集 =====
        return Container(
          color: Colors.blue,
          child: Center(
            child: Container(
              // width: availableSize * 0.8,
              // height: availableSize * 0.8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flutter_dash,
                size: availableSize * 0.6,
                color: Colors.blue,
              ),
            ),
          ),
        );
        // ===== ここまでがアイコンデザイン =====
      },
    );
  }
}
