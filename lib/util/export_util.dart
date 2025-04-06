import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:file_saver/file_saver.dart';

/// アイコンエクスポートユーティリティ
class ExportUtil {
  /// 指定されたキーのRepaintBoundaryからPNGイメージを生成してエクスポート
  /// プラットフォーム選択に関わらず、常に正方形でエクスポートします
  static Future<void> exportPng({
    required GlobalKey repaintKey,
    required String platform,
    required int size,
    required BuildContext context,
    void Function(String?)? onExportMessage,
    void Function(bool)? onExportStatus,
  }) async {
    try {
      if (onExportStatus != null) {
        onExportStatus(true);
      }
      if (onExportMessage != null) {
        onExportMessage('アイコンを生成中...');
      }

      // 選択されたRepaintBoundaryからRenderObjectを取得
      final RenderObject? renderObject =
          repaintKey.currentContext?.findRenderObject();
      if (renderObject == null) {
        throw Exception('RenderObject not found');
      }

      final RenderRepaintBoundary boundary =
          renderObject as RenderRepaintBoundary;

      // 高品質な画像をキャプチャ
      const double pixelRatio = 3.0; // 高解像度化のための倍率
      final ui.Image originalImage =
          await boundary.toImage(pixelRatio: pixelRatio);

      // 新しい正方形のキャンバスを作成
      final int exportSize = (size * pixelRatio).round(); // エクスポートサイズを倍率に合わせて調整
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      // 背景を描画（透明な背景を確保）
      final Paint backgroundPaint = Paint()..color = Colors.transparent;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, exportSize.toDouble(), exportSize.toDouble()),
        backgroundPaint,
      );

      // オリジナルの画像を中央に描画
      final double scale = exportSize / originalImage.width;
      canvas.scale(scale);
      canvas.drawImage(originalImage, Offset.zero, Paint());

      // 画像を生成
      final ui.Picture picture = recorder.endRecording();
      final ui.Image finalImage = await picture.toImage(exportSize, exportSize);

      // PNGバイトデータに変換
      final ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to get byte data from image');
      }

      // リソースの解放
      originalImage.dispose();
      finalImage.dispose();

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      // ファイル名を設定
      final String fileName =
          '${platform.toLowerCase()}_icon_${size}x$size.png';

      // ダウンロード実行
      await _downloadFile(pngBytes, fileName);

      // 成功メッセージ
      if (onExportMessage != null) {
        onExportMessage('アイコンを$fileNameとして保存しました。');
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading $fileName...')),
        );
      }
    } catch (e) {
      if (onExportMessage != null) {
        onExportMessage('エラーが発生しました: $e');
      }
      debugPrint('Error while exporting PNG: $e');
    } finally {
      if (onExportStatus != null) {
        onExportStatus(false);
      }
    }
  }

  /// ファイルダウンロード処理
  static Future<void> _downloadFile(List<int> bytes, String fileName) async {
    try {
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(bytes),
        mimeType: MimeType.png,
      );
    } catch (e) {
      debugPrint('Error while saving file: $e');
      rethrow;
    }
  }
}
