import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle, rootBundle;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class bulkUpload extends StatefulWidget {
  const bulkUpload({Key? key}) : super(key: key);

  @override
  State<bulkUpload> createState() => _bulkUploadState();
}

class _bulkUploadState extends State<bulkUpload> {
  List<List<dynamic>> _data = [];

  // This function is triggered when the  button is pressed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Colors.white,
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          title: const Text("Bulk Upload",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
        ),
        body: Column(
          children: [
            ElevatedButton(
              child: const Text("Upload FIle"),
              onPressed: () {
                pickFile();
              },
            ),
            ListView.builder(
              itemCount: _data.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return Card(
                  margin: const EdgeInsets.all(3),
                  color: index == 0 ? Colors.amber : Colors.white,
                  child: ListTile(
                    leading: Text(
                      _data[index][0].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: index == 0 ? 18 : 15,
                          fontWeight:
                              index == 0 ? FontWeight.bold : FontWeight.normal,
                          color: index == 0 ? Colors.red : Colors.black),
                    ),
                    title: Text(
                      _data[index][3],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: index == 0 ? 18 : 15,
                          fontWeight:
                              index == 0 ? FontWeight.bold : FontWeight.normal,
                          color: index == 0 ? Colors.red : Colors.black),
                    ),
                    trailing: Text(
                      _data[index][4].toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: index == 0 ? 18 : 15,
                          fontWeight:
                              index == 0 ? FontWeight.bold : FontWeight.normal,
                          color: index == 0 ? Colors.red : Colors.black),
                    ),
                  ),
                );
              },
            ),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  someFunction();
                },
                child: const Text("Iterate Data"),
              ),
            ),
          ],
        ));
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      final input = new File(file.path!).openRead();
      final fields = await input
          .transform(latin1.decoder) // Use latin1 decoder here
          .transform(new CsvToListConverter())
          .toList();

      print(fields);
    }
  }

  Future<List<FileSystemEntity>> _getAllcsvFiles() async {
    final String directory = (await getApplicationSupportDirectory()).path;
    final path = "$directory/";
    final myDir = Directory(path);
    List<FileSystemEntity> _csvFiles;
    _csvFiles = myDir.listSync(recursive: true, followLinks: false);
    _csvFiles.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    print(_csvFiles);
    return _csvFiles;
  }

// Usage:
  void someFunction() async {
    List<FileSystemEntity> csvFiles = await _getAllcsvFiles();
    // Use the csvFiles list here
    for (var file in csvFiles) {
      print(file.path);
    }
  }
}
