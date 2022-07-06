import 'dart:io';

import 'package:ali_project_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../app/theme.dart';
import '../../services/firebase_api.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  UserModel user;
  EditProfilePage(this.user, {Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<EditProfilePage> {
  File? file;
  UploadTask? task;

  final TextEditingController _dateCtl = TextEditingController();
  final TextEditingController _nameCtl = TextEditingController();
  final TextEditingController _emailCtl = TextEditingController();
  final TextEditingController _passwordCtl = TextEditingController();
  final TextEditingController _addressCtl = TextEditingController();
  final TextEditingController _nomorHpCtl = TextEditingController();
  final TextEditingController _hobbyCtl = TextEditingController();

  @override
  void dispose() {
    _dateCtl.dispose();
    _nameCtl.dispose();
    _emailCtl.dispose();
    _passwordCtl.dispose();
    _addressCtl.dispose();
    _nomorHpCtl.dispose();
    _hobbyCtl.dispose();
    super.dispose();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() {
      file = File(path);
    });
  }

  Future uploadPhoto() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'photo_user/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.id)
        .update({"photo_url": urlDownload});
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No file selected';

    void succesUpdate() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Update data profile success"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Edit Profile',
          style: kGreyTextStyle.copyWith(
            fontWeight: regular,
            fontSize: 16,
            color: kWhiteColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 30.0,
          left: 24.0,
          right: 24.0,
        ),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: selectFile,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.attach_file),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Update Photo profie'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  fileName,
                  style: kGreyTextStyle,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              nameTextField: widget.user.name,
              iconTextField: const Icon(Icons.account_circle),
              controller: _nameCtl,
            ),
            CustomTextField(
              nameTextField: widget.user.email,
              iconTextField: const Icon(Icons.markunread),
              controller: _emailCtl,
              isEnabled: false,
            ),
            CustomTextField(
              nameTextField: widget.user.password,
              iconTextField: const Icon(Icons.password),
              controller: _passwordCtl,
              isPassword: true,
              isEnabled: false,
            ),

            /// Input Tanggal Lahir

            TextField(
              controller: _dateCtl,
              decoration: InputDecoration(
                hintText: widget.user.tanggalLahir,
                hintStyle: kBlackTextStyle.copyWith(
                  fontWeight: regular,
                  fontSize: 16,
                  color: const Color.fromARGB(255, 92, 92, 92),
                ),
                filled: true,
                fillColor: kGreyColor,
                suffixIcon: const Icon(Icons.date_range),
                suffixIconColor: const Color.fromARGB(255, 92, 92, 92),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: kPrimaryColor,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onTap: () async {
                DateTime? date = DateTime(1900);
                FocusScope.of(context).requestFocus(FocusNode());
                date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                _dateCtl.text = DateFormat('yyyy-MM-dd').format(date!);
              },
            ),
            const SizedBox(
              height: 8.0,
            ),
            CustomTextField(
              nameTextField: widget.user.alamat,
              iconTextField: const Icon(Icons.add_home_work),
              controller: _addressCtl,
            ),
            CustomTextField(
              nameTextField: widget.user.nomorHp,
              iconTextField: const Icon(Icons.phone),
              controller: _nomorHpCtl,
            ),
            CustomTextField(
              nameTextField: widget.user.hobby,
              iconTextField: const Icon(Icons.menu_book),
              controller: _hobbyCtl,
            ),
            CustomButton(
              buttonColor: Colors.green,
              textButton: 'Update Profile',
              onPressFunc: () async {
                String? updateName = _nameCtl.text;
                String? updateDateBirth = _dateCtl.text;
                String? updateAddress = _addressCtl.text;
                String? updateNomorHp = _nomorHpCtl.text;
                String? updateHobby = _hobbyCtl.text;

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.user.id)
                    .update({
                  "name": updateName.isNotEmpty ? updateName : widget.user.name,
                  "date_birth": updateDateBirth.isNotEmpty
                      ? updateDateBirth
                      : widget.user.tanggalLahir,
                  "address": updateAddress.isNotEmpty
                      ? updateAddress
                      : widget.user.alamat,
                  "nomor_hp": updateNomorHp.isNotEmpty
                      ? updateNomorHp
                      : widget.user.nomorHp,
                  "hobby":
                      updateHobby.isNotEmpty ? updateHobby : widget.user.hobby,
                });
                uploadPhoto();
                succesUpdate();
                setState(() {});
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
