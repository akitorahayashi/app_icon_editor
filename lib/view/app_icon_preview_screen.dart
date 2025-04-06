import 'package:flutter/material.dart';
import 'package:app_icon_editor/util/export_util.dart';
import 'package:app_icon_editor/icon_content.dart';
import 'package:app_icon_editor/view/component/platform_preview/ios_preview.dart';
import 'package:app_icon_editor/view/component/platform_preview/android_preview.dart';
import 'package:app_icon_editor/view/component/download_section.dart';

/// アイコンプレビューのメイン画面
class AppIconPreviewScreen extends StatefulWidget {
  const AppIconPreviewScreen({super.key});

  @override
  State<AppIconPreviewScreen> createState() => _AppIconPreviewScreenState();
}

class _AppIconPreviewScreenState extends State<AppIconPreviewScreen> {
  // RepaintBoundary用のキー
  final GlobalKey _iosIconKey = GlobalKey();
  final GlobalKey _androidIconKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  // プラットフォーム選択
  String selectedPlatform = 'iOS';
  bool _isScrolled = false;

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
  };

  // エクスポート状態
  bool isExporting = false;
  String? exportMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 0 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 0 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  // 現在のプラットフォームのキーを取得
  GlobalKey get _currentKey {
    switch (selectedPlatform) {
      case 'iOS':
        return _iosIconKey;
      case 'Android':
        return _androidIconKey;
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

  // プラットフォーム別のエクスポート説明文
  String _getExportDescription() {
    switch (selectedPlatform) {
      case 'iOS':
        return 'iOS App Store用のアプリアイコンをダウンロードします。\n'
            'サイズ: ${_currentSize}x${_currentSize}px';
      case 'Android':
        return 'Google Play Store用のアプリアイコンをダウンロードします。\n'
            'サイズ: ${_currentSize}x${_currentSize}px';
      default:
        return '';
    }
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
        title: const Text('App Icon Preview'),
        backgroundColor: Colors.transparent,
        elevation: _isScrolled ? 1 : 0,
        actions: [
          // プラットフォームを選択
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(value: 'iOS', label: Text('iOS')),
                ButtonSegment<String>(value: 'Android', label: Text('Android')),
              ],
              selected: {selectedPlatform},
              onSelectionChanged: (Set<String> selected) {
                setState(() {
                  selectedPlatform = selected.first;
                });
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            controller: _scrollController,
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

                  // エクスポートボタン
                  const SizedBox(height: 32),
                  DownloadSection(
                    selectedPlatform: selectedPlatform,
                    isExporting: isExporting,
                    exportMessage: exportMessage,
                    currentSize: _currentSize,
                    onExport: _exportIcon,
                    getExportDescription: _getExportDescription,
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
      ),
    );
  }

  // 現在選択中のプラットフォームに合わせたプレビューを表示
  Widget _buildCurrentPlatformPreview(double previewSize) {
    // IconContentインスタンスを作成
    final iconContent = IconContent(size: previewSize);

    switch (selectedPlatform) {
      case 'iOS':
        return IOSPreview(
          repaintKey: _iosIconKey,
          iconContent: iconContent,
          previewSize: previewSize,
          platformInfo: platformInfo['iOS']!,
        );
      case 'Android':
        return AndroidPreview(
          repaintKey: _androidIconKey,
          iconContent: iconContent,
          previewSize: previewSize,
          platformInfo: platformInfo['Android']!,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
