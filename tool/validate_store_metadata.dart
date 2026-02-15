import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final platform = _parsePlatform(args);
  final errors = <String>[];

  if (platform == _Platform.ios || platform == _Platform.all) {
    errors.addAll(_validateIosMetadata());
  }
  if (platform == _Platform.android || platform == _Platform.all) {
    errors.addAll(_validateAndroidMetadata());
  }

  if (errors.isNotEmpty) {
    stderr.writeln('Store metadata validation failed:');
    for (final error in errors) {
      stderr.writeln('- $error');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Store metadata validation passed.');
}

enum _Platform { ios, android, all }

_Platform _parsePlatform(List<String> args) {
  if (args.isEmpty) return _Platform.all;
  final raw = args.first.toLowerCase();
  switch (raw) {
    case '--platform=ios':
    case 'ios':
      return _Platform.ios;
    case '--platform=android':
    case 'android':
      return _Platform.android;
    case '--platform=all':
    case 'all':
      return _Platform.all;
    default:
      stderr.writeln(
        'Unknown argument: $raw. Use ios|android|all or --platform=...',
      );
      exit(2);
  }
}

List<String> _validateIosMetadata() {
  final errors = <String>[];
  final root = Directory('ios/fastlane/metadata');
  if (!root.existsSync()) {
    return errors;
  }

  final localeDirs = root
      .listSync()
      .whereType<Directory>()
      .where((d) => !d.path.endsWith('.git'))
      .toList();

  const limits = <String, int>{
    'name.txt': 30,
    'subtitle.txt': 30,
    'promotional_text.txt': 170,
    'description.txt': 4000,
    'keywords.txt': 100,
    'release_notes.txt': 4000,
  };
  const urlFields = <String>{
    'support_url.txt',
    'marketing_url.txt',
    'privacy_url.txt',
  };

  for (final localeDir in localeDirs) {
    final locale = _basename(localeDir.path);
    for (final entry in localeDir.listSync().whereType<File>()) {
      if (!entry.path.endsWith('.txt')) continue;
      final name = _basename(entry.path);
      final bytes = entry.readAsBytesSync();
      if (_hasUtf8Bom(bytes)) {
        errors.add('${entry.path}: contains UTF-8 BOM');
      }

      final rawText = utf8.decode(bytes, allowMalformed: false);
      final text = rawText.trim();

      final limit = limits[name];
      if (limit != null) {
        final length = text.runes.length;
        if (length > limit) {
          errors.add('${entry.path}: $length chars, max $limit');
        }
      }

      if (urlFields.contains(name)) {
        if (text.isEmpty) {
          errors.add('${entry.path}: URL is empty');
          continue;
        }
        final uri = Uri.tryParse(text);
        if (uri == null || !uri.isAbsolute || uri.scheme != 'https') {
          errors.add('${entry.path}: invalid URL, expected absolute https URL');
          continue;
        }
      }
    }

    for (final required in {...limits.keys, ...urlFields}) {
      final file = File('${localeDir.path}/$required');
      if (!file.existsSync()) {
        errors.add('${localeDir.path}/$required: missing required iOS field');
      }
    }

    if (locale.isEmpty) {
      errors.add('${localeDir.path}: invalid locale directory name');
    }
  }

  return errors;
}

List<String> _validateAndroidMetadata() {
  final errors = <String>[];
  final root = Directory('android/fastlane/metadata/android');
  if (!root.existsSync()) {
    return errors;
  }

  final localeDirs = root
      .listSync()
      .whereType<Directory>()
      .where((d) => _basename(d.path) != 'images')
      .toList();

  const limits = <String, int>{
    'title.txt': 30,
    'short_description.txt': 80,
    'full_description.txt': 4000,
  };

  for (final localeDir in localeDirs) {
    for (final required in limits.keys) {
      final file = File('${localeDir.path}/$required');
      if (!file.existsSync()) {
        errors.add('${file.path}: missing required Android field');
        continue;
      }
      final bytes = file.readAsBytesSync();
      if (_hasUtf8Bom(bytes)) {
        errors.add('${file.path}: contains UTF-8 BOM');
      }
      final text = utf8.decode(bytes, allowMalformed: false).trim();
      final length = text.runes.length;
      final limit = limits[required]!;
      if (length > limit) {
        errors.add('${file.path}: $length chars, max $limit');
      }
    }

    final changelogsDir = Directory('${localeDir.path}/changelogs');
    if (!changelogsDir.existsSync()) continue;
    for (final file in changelogsDir.listSync().whereType<File>()) {
      if (!file.path.endsWith('.txt')) continue;
      final bytes = file.readAsBytesSync();
      if (_hasUtf8Bom(bytes)) {
        errors.add('${file.path}: contains UTF-8 BOM');
      }
      final text = utf8.decode(bytes, allowMalformed: false).trim();
      final length = text.runes.length;
      if (length > 500) {
        errors.add('${file.path}: $length chars, max 500');
      }
    }
  }

  return errors;
}

bool _hasUtf8Bom(List<int> bytes) =>
    bytes.length >= 3 &&
    bytes[0] == 0xEF &&
    bytes[1] == 0xBB &&
    bytes[2] == 0xBF;

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final idx = normalized.lastIndexOf('/');
  if (idx == -1) return normalized;
  return normalized.substring(idx + 1);
}
