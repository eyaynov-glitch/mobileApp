import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import '../services/firestore_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});
  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final nameCtrl = TextEditingController();
  String? selectedImagePath;

  Future<void> _pick(ImageSource source) async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.microphone.request();
    final file = await ImagePicker().pickImage(source: source);
    setState(() => selectedImagePath = file?.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Display name')),
            const SizedBox(height: 8),
            if (selectedImagePath != null) Text('Selected image: $selectedImagePath'),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: () => _pick(ImageSource.camera), child: const Text('Camera')),
                ElevatedButton(onPressed: () => _pick(ImageSource.gallery), child: const Text('Gallery')),
              ],
            ),
            ElevatedButton(
              onPressed: () => FirestoreService.instance.updateProfile(widget.user.uid, {
                'displayName': nameCtrl.text.trim(),
                'updatedAt': DateTime.now().toIso8601String(),
              }),
              child: const Text('Save profile'),
            ),
          ],
        ),
      ),
    );
  }
}
