import 'dart:io';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:domino/screens/MG/profile_img_samplegallery.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:domino/apis/services/image_services.dart';
import 'package:flutter/services.dart';

class ProfileEdit extends StatefulWidget {
  final String selectedImage;
  final String profileImage;
  final String cameraImage;

  const ProfileEdit(
      {super.key,
      required this.selectedImage,
      required this.profileImage,
      required this.cameraImage});

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController _nicknamecontroller = TextEditingController();
  final TextEditingController _explaincontroller = TextEditingController();
  String defaultImage = 'assets/img/profile_smp4.png'; // 기본 이미지 경로
  String? nickname;
  String? description;
  String? profile;
  final List<String> _imageFiles = [];

  final ImagePicker _picker = ImagePicker();

  /// 📌 **카메라로 사진 촬영 및 업로드**
  Future<void> _takePhoto() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800, // 최대 너비
        maxHeight: 800, // 최대 높이
        imageQuality: 80, // 품질 (0~100)
      );

      if (pickedFile == null) {
        print("❌ 오류: 사용자가 사진을 촬영하지 않음.");
        return;
      }

      File imageFile = File(pickedFile.path);

      if (!imageFile.existsSync()) {
        print("❌ 오류: 촬영된 이미지 파일이 존재하지 않습니다.");
        Fluttertoast.showToast(
          msg: '촬영된 이미지가 저장되지 않았습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      print("✅ 촬영된 이미지 경로: ${imageFile.path}");
      print("✅ 파일 크기: ${await imageFile.length()} bytes");

      // 📌 촬영한 사진을 서버에 업로드
      String uploadedUrl = await _uploadCamera(imageFile);

      if (uploadedUrl.isNotEmpty) {
        setState(() {
          _imageFiles.add(uploadedUrl); // ✅ 업로드된 URL을 리스트에 추가
        });
        print('✅ 업로드된 이미지 URL: $uploadedUrl');
      } else {
        print("❌ 오류: 서버 업로드 실패");
        Fluttertoast.showToast(
          msg: '이미지 업로드에 실패했습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print('❌ 카메라 사진 촬영 오류: $e');
      Fluttertoast.showToast(
        msg: '사진 촬영 오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// 📌 **카메라로 찍은 사진을 서버에 업로드**
  Future<String> _uploadCamera(File imageFile) async {
    try {
      if (!imageFile.existsSync()) {
        print("❌ 오류: 업로드할 이미지 파일이 존재하지 않음.");
        return "";
      }

      print("📤 서버로 업로드 중: ${imageFile.path}");
      print("📏 파일 크기: ${await imageFile.length()} bytes");

      /// 📌 File을 PlatformFile로 변환 (웹과 모바일 분리)
      PlatformFile platformFile = PlatformFile(
        name: 'camera_image.jpg',
        path: imageFile.path,
        size: await imageFile.length(),
      );

      /// 📌 UploadFileService.uploadFiles() 사용하여 업로드
      String uploadedUrl = await UploadFileService.uploadFiles([platformFile]);

      if (uploadedUrl.isNotEmpty) {
        print("✅ 업로드 완료! URL: $uploadedUrl");
        return uploadedUrl;
      } else {
        print("❌ 오류: 서버에서 업로드 URL을 반환하지 않음.");
        return "";
      }
    } catch (e) {
      print("❌ 카메라 사진 업로드 오류: $e");
      return "";
    }
  }

  Future<void> _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        withData: kIsWeb, // 웹에서는 true, 모바일에서는 false
      );

      if (result == null || result.files.isEmpty) {
        print('파일 선택이 취소됨.');
        return; // 파일을 선택하지 않았으면 함수 종료
      }
      String uploadedUrl = await UploadFileService.uploadFiles(result.files);

      if (uploadedUrl.isEmpty) {
        print('파일 업로드 실패');
        Fluttertoast.showToast(
          msg: '파일 업로드에 실패했습니다. 다시 시도해주세요.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return; // 업로드가 실패했으므로 함수 종료
      }

      setState(() {
        _imageFiles.add(uploadedUrl); // URL을 _imageFiles에 추가
      });

      print('_imageFiles=$_imageFiles');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileEdit(
              selectedImage: "", profileImage: uploadedUrl, cameraImage: ""),
        ),
      );
    } catch (e) {
      print('이미지 선택 오류: $e');
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _uploadSelectedImage() async {
    try {
      if (widget.selectedImage.isNotEmpty) {
        print('업로드할 selectedImage: ${widget.selectedImage}');

        // selectedImage를 File로 변환 (Flutter의 asset 이미지는 직접 File로 변환 불가하므로, ByteData로 변환 후 처리)
        ByteData byteData = await rootBundle.load(widget.selectedImage);
        Uint8List imageBytes = byteData.buffer.asUint8List();

// Uint8List를 PlatformFile로 변환
        PlatformFile selectedFile = PlatformFile(
          name: 'profile_image.png', // 파일 이름 지정
          bytes: imageBytes, // 파일 데이터
          size: imageBytes.length, // 파일 크기
        );

        List<PlatformFile> fileList = [selectedFile];
        String uploadedUrl = await UploadFileService.uploadFiles(fileList);

        if (uploadedUrl.isNotEmpty) {
          print('업로드된 selectedImage URL: $uploadedUrl');
          setState(() {
            _imageFiles.clear();
            _imageFiles.add(uploadedUrl); // 업로드된 URL을 _imageFiles에 추가
            print('_imageFiles=$_imageFiles');
          });
        } else {
          print('selectedImage 업로드 실패');
        }
      } else {
        print('selectedImage가 비어 있습니다.');
      }
    } catch (e) {
      print('selectedImage 업로드 오류: $e');
      Fluttertoast.showToast(
        msg: '이미지 업로드 오류: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  ImageProvider getImageProvider(
      String? profile, String? selectedImage, String? cameraImage) {
    // 1️⃣ 우선순위에 따라 사용할 이미지 선택
    String? imageToShow = profile?.isNotEmpty == true
        ? profile
        : (selectedImage?.isNotEmpty == true ? selectedImage : cameraImage);

    // 2️⃣ 기본 이미지 처리
    if (imageToShow == null || imageToShow.isEmpty) {
      return AssetImage(defaultImage);
    }

    // 3️⃣ 네트워크 이미지인지 확인 후 반환
    if (imageToShow.startsWith('http')) {
      return NetworkImage(imageToShow);
    } else if (imageToShow.startsWith('file://')) {
      // 로컬 파일은 FileImage로 변환
      return FileImage(File(imageToShow.replaceFirst('file://', '')));
    } else {
      // Asset 이미지 사용 (경로 확인 필요)
      return AssetImage(imageToShow);
    }
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
      return false;
    }
  }

  void userInfo() async {
    final data = await UserInfoService.userInfo();
    if (data.isNotEmpty) {
      setState(() {
        nickname = data['nickname'];
        description = data['description'];
        profile = widget.profileImage;
        _nicknamecontroller.text = nickname ?? '';
        _explaincontroller.text = description ?? '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userInfo();
    print('selectedImage=${widget.selectedImage}');
    print('cameraImage=${widget.cameraImage}');
    print('profileImage=${widget.profileImage}');
  }

  @override
  void dispose() {
    _nicknamecontroller.dispose();
    _explaincontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color(0xffD4D4D4),
                iconSize: 17,
              ),
              Text(
                '프로필 편집',
                style: TextStyle(
                    fontSize: currentWidth < 600 ? 20 : 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
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
                              width: currentWidth < 600
                                  ? 140
                                  : 250, //imageSize / 1.2, // CircleAvatar의 전체 크기
                              height: currentWidth < 600
                                  ? 140
                                  : 250, //imageSize / 1.2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 147, 147, 147), // 원하는 테두리 색
                                  width: 0.5, // 테두리 두께
                                ),
                              ),
                              child: CircleAvatar(
                                radius: currentWidth < 600
                                    ? 70
                                    : 125, //imageSize / 2.4,
                                backgroundImage: (() {
                                  // 값이 있는 이미지 찾기
                                  String? imageToShow = profile != ""
                                      ? profile
                                      : (widget.selectedImage != ""
                                          ? widget.selectedImage
                                          : widget.cameraImage);

                                  // 네트워크 이미지인지 확인 후 반환
                                  return imageToShow!.startsWith("http")
                                      ? NetworkImage(imageToShow)
                                          as ImageProvider // 네트워크 이미지 (profile 또는 cameraImage)
                                      : AssetImage(imageToShow)
                                          as ImageProvider; // 로컬 asset 이미지 (selectedImage)
                                })(),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Positioned(
                                right: currentWidth < 600 ? 20 : 35,
                                top: currentWidth < 600 ? 110 : 200,
                                child: CircleAvatar(
                                    radius: currentWidth < 600 ? 14 : 20,
                                    backgroundColor: mainRed,
                                    child: Icon(Icons.edit,
                                        size: currentWidth < 600 ? 16 : 24,
                                        color: backgroundColor))),
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
                    const Question(question: '닉네임을 만들어봐요'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          // 🔹 리스너 추가: 입력값 변경 시 setState() 호출
                          _nicknamecontroller.addListener(() {
                            setState(() {});
                          });

                          return CustomTextField(
                            'Ex. 꿈꾸는 마이클',
                            _nicknamecontroller,
                            (value) => null, // validator
                            false, // obscureText
                            1, // maxLines
                          ).textField(
                            onClear: () {
                              _nicknamecontroller.clear();
                              setState(() {}); // 🔹 clear() 후에도 UI 갱신
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Question(question: '당신은 어떤 사람인가요?'),
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
                  Button(Colors.black, Colors.white, '완료', () async {
                    await _uploadSelectedImage(); // 🔹 이미지 업로드 완료까지 대기
                    if (_imageFiles.isNotEmpty) {
                      // 🔹 업로드된 이미지가 존재하는지 확인
                      bool isEdited = await _editProfile(
                        _nicknamecontroller.text,
                        _imageFiles[0], // 🔹 업로드된 이미지 URL 사용
                        _explaincontroller.text,
                      );

                      if (isEdited) {
                        // 🔹 프로필 수정이 성공했을 경우만 이동
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyGoal()),
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: '프로필 수정에 실패했습니다.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyGoal(),
                        ),
                      );
                    }
                  }).button()
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
                    color: Colors.white,
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
                  onTap: () async {
                    Navigator.pop(context);
                    setState(() {
                      _imageFiles.clear();
                    });
                    await _takePhoto();
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
                    _imageFiles.clear();

                    _pickImages();

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
                            profileImage: widget.profileImage),
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
}
