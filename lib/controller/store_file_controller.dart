import 'dart:io';
import 'dart:typed_data';

import 'package:aspirevue/controller/common_controller.dart';

import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class StoreFile {
  Future<File> loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes, url.split(Platform.pathSeparator).last);
  }

  Future<File> _storeFile(String url, List<int> bytes, String fileName) async {
    Directory? dir;
    try {
      if (CommonController.getIsIOS()) {
        var dir1 = await getApplicationDocumentsDirectory();
        dir = Directory(dir1.path);
        if (!dir.existsSync()) {
          dir.createSync(recursive: true);
        }
      } else {
        // if (await PermissionUtils.takePermission(
        //     Permission.manageExternalStorage)) {
        // var downloadDir = Directory('/storage/emulated/0/Download');

        var downloadDir = await getExternalStorageDirectory();

        if (downloadDir != null) {
          dir = Directory(downloadDir.path);
          if (!dir.existsSync()) {
            dir.createSync(recursive: true);
          }
        }
      }
      if (dir != null) {
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        return file;
      } else {
        throw "Something went wrong";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Uint8List>?> getImageToUint8List(List<String> urls) async {
    try {
      List<Uint8List> localUint = [];
      for (var url in urls) {
        final response = await http.get(Uri.parse(url));
        localUint.add(response.bodyBytes);
      }

      return localUint;
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
    return null;
  }
}
