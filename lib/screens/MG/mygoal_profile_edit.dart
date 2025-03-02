import 'dart:io';
import 'package:dio/dio.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:domino/screens/MG/profile_img_samplegallery.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/MG/mygoal_main.dart';

class ProfileEdit extends StatefulWidget {
  final String selectedImage;
  const ProfileEdit({super.key, required this.selectedImage});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController _nicknamecontroller = TextEditingController();
  final TextEditingController _explaincontroller = TextEditingController();
  XFile? _pickedFile;
  String defaultImage = 'assets/img/profile_smp4.png'; // 기본 이미지 경로
  String? nickname;
  String? description;

  @override
  void initState() {
    super.initState();
    userInfo();
  }

  Future<bool> _editProfile(
      String nickname, String profile, String description) async {
    try {
      final success = await EditProfileService.editProfile(
        nickname: nickname,
        profile: profile,
        description: description,
      );
      return success;
    } catch (e) {
      debugPrint('Error in _editProfile: $e');
      return false; // Return false if there's an error
    }
  }





  void userInfo() async {
    final data = await UserInfoService.userInfo();
    if (data.isNotEmpty) {
      setState(() {
        nickname = data['nickname'];
        description = data['description'];
        _nicknamecontroller.text = nickname ?? '';
        _explaincontroller.text = description ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nicknamecontroller.dispose();
    _explaincontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
            padding: appBarPadding,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyGoal(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xffD4D4D4),
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '프로필 편집',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            )),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet();
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              width: imageSize / 1.2, // CircleAvatar의 전체 크기
                              height: imageSize / 1.2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 147, 147, 147), // 원하는 테두리 색
                                  width: 0.5, // 테두리 두께
                                ),
                              ),
                              child: CircleAvatar(
                                radius: imageSize / 2.4,
                                backgroundImage: _pickedFile != null
                                    ? FileImage(File(_pickedFile!.path))
                                    : AssetImage(defaultImage)
                                        as ImageProvider,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            const Positioned(
                                right: 20,
                                top: 135,
                                child: CircleAvatar(
                                    radius: 17,
                                    backgroundColor: mainRed,
                                    child: Icon(Icons.edit,
                                        size: 20, color: backgroundColor))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Question(number: '1', question: '닉네임을 만들어봐요'),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 40,
                        child: CustomTextField('Ex. 꿈꾸는 마이클',
                                _nicknamecontroller, (value) => null, false, 1)
                            .textField()),
                    const SizedBox(height: 40),
                    const Question(number: '2', question: '당신은 어떤 사람인가요?'),
                    const SizedBox(height: 10),
                    SizedBox(
                        height: 80,
                        child: CustomTextField('Ex. 명랑하면서 도전적인 사람!',
                                _explaincontroller, (value) => null, false, 3)
                            .textField()),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Button(
                    Colors.black,
                    Colors.white,
                    '취소',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyGoal(),
                        ),
                      );
                    },
                  ).button(),
                  Button(
  Colors.black,
  Colors.white,
  '완료',
  () async {
    try {
      bool imageUrl;

      if (_pickedFile != null) {
        // Upload the image to S3
        imageUrl = await UploadImage.uploadImage(
         filePath: _pickedFile!.path);
      } else {
      }

      // Call the edit profile service
      final profileUpdated = await _editProfile(
        _nicknamecontroller.text,
        _pickedFile!.path,
        _explaincontroller.text,
      );

      if (profileUpdated) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyGoal(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필 수정에 실패했습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  },
).button()

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: backgroundColor.withOpacity(0.95),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(6),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          widthFactor: 0.85, // 화면 너비의 3/4
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '어디서 사진을 가져올까요?',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    _getCameraImage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white.withOpacity(0.03),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera,
                          color: Color(0xffD4D4D4),
                          size: 17,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '카메라로 찍기',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    _getPhotoLibraryImage();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white.withOpacity(0.03),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.insert_photo,
                          color: Color(0xffD4D4D4),
                          size: 17,
                        ),
                        SizedBox(width: 10),
                        Text('앨범에서 고르기',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSampleGallery(
                          selectedImage: widget.selectedImage,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white.withOpacity(0.03),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.grade,
                          color: Color(0xffD4D4D4),
                          size: 17,
                        ),
                        SizedBox(width: 10),
                        Text('도민호씨 갤러리',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getCameraImage() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 75,
      maxWidth: 75,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  Future<void> _getPhotoLibraryImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 75,
      maxWidth: 75,
      imageQuality: 30,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }
}


