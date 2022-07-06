import 'dart:io';

import 'package:ali_project_app/app/theme.dart';
import 'package:ali_project_app/services/firebase_api.dart';
import 'package:ali_project_app/services/video_player_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

class UploadVideoPage extends StatefulWidget {
  const UploadVideoPage({Key? key}) : super(key: key);

  @override
  State<UploadVideoPage> createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  File? file;
  UploadTask? task;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      file = File(path);
    });
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    /// untuk menyimpan url firebase storage to firebase firestore
    VideoPlayerService().saveVideo(urlDownload);
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final percentance = (progress * 100).toStringAsFixed(2);

          return Text(
            "$percentance %",
            style: kGreyTextStyle,
          );
        } else {
          return Container();
        }
      });

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No file selected';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 1,
        title: const Text(
          'Upload video',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: selectFile,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.file_present_outlined),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Pilih Video'),
                ],
              ),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              fileName,
              style: kGreyTextStyle,
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: uploadFile,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.file_upload_rounded),
                  SizedBox(
                    width: 8,
                  ),
                  Text('Upload Video'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            task != null ? buildUploadStatus(task!) : Container(),
          ],
        ),
      ),
    );
  }
}
