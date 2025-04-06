import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Icon Export Tests', () {
    test('Export script exists and is executable', () {
      final scriptFile = File('export_icon.sh');
      expect(
        scriptFile.existsSync(),
        isTrue,
        reason: 'export_icon.sh script should exist',
      );

      // Check if script is executable on Unix systems
      if (!Platform.isWindows) {
        final result = Process.runSync(
            'test',
            [
              '-x',
              'export_icon.sh',
            ],
            runInShell: true);
        expect(
          result.exitCode,
          equals(0),
          reason: 'export_icon.sh should be executable',
        );
      }
    });

    test('Release directory is created if not exists', () {
      // Ensure release directory doesn't exist for this test
      final releaseDir = Directory('release');
      if (releaseDir.existsSync()) {
        releaseDir.deleteSync(recursive: true);
      }

      // Run script with minimal valid arguments to create directory
      final sampleData = base64Encode('test data'.codeUnits);
      Process.runSync(
          './export_icon.sh',
          [
            '-o',
            'test_icon.png',
            sampleData,
          ],
          runInShell: true);

      // Directory should now exist
      expect(
        releaseDir.existsSync(),
        isTrue,
        reason: 'Release directory should be created by script',
      );

      // Cleanup
      if (releaseDir.existsSync()) {
        releaseDir.deleteSync(recursive: true);
      }
    });

    test('Export creates a valid PNG file', () {
      // Create a 1x1 red pixel PNG as base64
      // This is a minimal valid PNG file for testing
      const samplePngBase64 =
          'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';

      // Run export script
      final result = Process.runSync(
          './export_icon.sh',
          [
            '-o',
            'test_export.png',
            samplePngBase64,
          ],
          runInShell: true);
      expect(
        result.exitCode,
        equals(0),
        reason: 'Export script should execute successfully',
      );

      // Verify file was created
      final outputFile = File('release/test_export.png');
      expect(
        outputFile.existsSync(),
        isTrue,
        reason: 'Output PNG file should exist',
      );

      // Check file has content
      final fileSize = outputFile.lengthSync();
      expect(
        fileSize,
        greaterThan(0),
        reason: 'Output PNG should have content',
      );

      // Cleanup
      outputFile.deleteSync();
    });
  });
}
