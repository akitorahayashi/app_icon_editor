import 'package:flutter/material.dart';
import 'package:app_icon_editor/util/export_util.dart';
import 'package:app_icon_editor/icon_content.dart';
import 'package:app_icon_editor/preview/platform_preview/ios_preview.dart';
import 'package:app_icon_editor/preview/platform_preview/android_preview.dart';
import 'package:app_icon_editor/preview/platform_preview/web_preview.dart';

/// アイコンエディターのメイン画面
class IconEditorScreen extends StatefulWidget {
  const IconEditorScreen({super.key});

  @override
  State<IconEditorScreen> createState() => _IconEditorScreenState();
}

class _IconEditorScreenState extends State<IconEditorScreen> {
  // RepaintBoundary用のキー
  final GlobalKey _iosIconKey = GlobalKey();
  final GlobalKey _androidIconKey = GlobalKey();
  final GlobalKey _webIconKey = GlobalKey();

  // プラットフォーム選択
  String selectedPlatform = 'iOS';

  // アイコンサイズのプリセット
  final Map<String, Map<String, dynamic>> platformInfo = {
    'iOS': {
      'size': 1024,
      'shape': 'rounded_square',
      'corner_radius': 0.225, // iOSアイコンの丸み (比率)
    },
    'Android': {
      'size': 512,
      'shape': 'circle',
    },
    'Web': {
      'size': 192,
      'shape': 'square',
    },
  };

  // エクスポート状態
  bool isExporting = false;
  String? exportMessage;

  // 現在のプラットフォームのキーを取得
  GlobalKey get _currentKey {
    switch (selectedPlatform) {
      case 'iOS':
        return _iosIconKey;
      case 'Android':
        return _androidIconKey;
      case 'Web':
        return _webIconKey;
      default:
        return _iosIconKey;
    }
  }

  // 現在のプラットフォームのサイズを取得
  int get _currentSize => platformInfo[selectedPlatform]!['size'] as int;

  // アイコンをエクスポート
  Future<void> _exportIcon() async {
    await ExportUtil.exportPng(
      repaintKey: _currentKey,
      platform: selectedPlatform,
      size: _currentSize,
      context: context,
      onExportMessage: (message) {
        setState(() {
          exportMessage = message;
        });
      },
      onExportStatus: (status) {
        setState(() {
          isExporting = status;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 画面サイズに基づくレスポンシブなサイズ計算
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final maxPreviewSize =
        isLandscape ? screenSize.height * 0.6 : screenSize.width * 0.8;

    // 共通のプレビューサイズ
    final previewSize = maxPreviewSize * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Icon Editor'),
        actions: [
          // プラットフォーム選択セグメントコントロール
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(value: 'iOS', label: Text('iOS')),
                ButtonSegment<String>(value: 'Android', label: Text('Android')),
                ButtonSegment<String>(value: 'Web', label: Text('Web')),
              ],
              selected: {selectedPlatform},
              onSelectionChanged: (Set<String> selected) {
                setState(() {
                  selectedPlatform = selected.first;
                });
              },
            ),
          ),

          // エクスポートボタン
          IconButton(
            onPressed: isExporting ? null : _exportIcon,
            icon: isExporting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  )
                : const Icon(Icons.download),
            tooltip: 'Export as PNG',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 説明テキスト
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Flutterのウィジェットを配置してアイコンを作成し、エクスポートできます。\n'
                    'lib/icon_content.dartを編集してアイコンをカスタマイズしてください。',
                    textAlign: TextAlign.center,
                  ),
                ),

                // アイコンプレビュー
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentPlatformPreview(previewSize),
                ),

                // エクスポートメッセージ
                if (exportMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(exportMessage!),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 現在選択中のプラットフォームに合わせたプレビューを表示
  Widget _buildCurrentPlatformPreview(double previewSize) {
    switch (selectedPlatform) {
      case 'iOS':
        return IOSPreview(
          repaintKey: _iosIconKey,
          iconContent: const IconContent(),
          previewSize: previewSize,
          platformInfo: platformInfo[selectedPlatform]!,
        );
      case 'Android':
        return AndroidPreview(
          repaintKey: _androidIconKey,
          iconContent: const IconContent(),
          previewSize: previewSize,
          platformInfo: platformInfo[selectedPlatform]!,
        );
      case 'Web':
        return WebPreview(
          repaintKey: _webIconKey,
          iconContent: const IconContent(),
          previewSize: previewSize,
          platformInfo: platformInfo[selectedPlatform]!,
        );
      default:
        return IOSPreview(
          repaintKey: _iosIconKey,
          iconContent: const IconContent(),
          previewSize: previewSize,
          platformInfo: platformInfo['iOS']!,
        );
    }
  }
}
