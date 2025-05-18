import 'dart:io';
import 'package:domino/style/styles.dart';
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
import 'package:path_provider/path_provider.dart';
import 'package:domino/utils/permission_util.dart';

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
        return;
      }

      File imageFile = File(pickedFile.path);

      if (!imageFile.existsSync()) {
        Fluttertoast.showToast(
          msg: '촬영된 이미지가 저장되지 않았습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // 📌 촬영한 사진을 서버에 업로드
      String uploadedUrl = await _uploadCamera(imageFile);

      if (uploadedUrl.isNotEmpty) {
        setState(() {
          _imageFiles.clear(); // 이전 이미지 제거
          _imageFiles.add(uploadedUrl); // 새 URL 저장
          profile = uploadedUrl; // ✅ 상태에 반영 (중요!)
        });
      } else {
        Fluttertoast.showToast(
          msg: '이미지 업로드에 실패했습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
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
        return "";
      }

      /// 📌 File을 PlatformFile로 변환 (웹과 모바일 분리)
      PlatformFile platformFile = PlatformFile(
        name: 'camera_image.jpg',
        path: imageFile.path,
        size: await imageFile.length(),
      );

      /// 📌 UploadFileService.uploadFiles() 사용하여 업로드
      String uploadedUrl = await UploadFileService.uploadFiles([platformFile]);

      if (uploadedUrl.isNotEmpty) {
        return uploadedUrl;
      } else {
        return "";
      }
    } catch (e) {
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
        return; // 파일을 선택하지 않았으면 함수 종료
      }
      String uploadedUrl = await UploadFileService.uploadFiles(result.files);

      if (uploadedUrl.isEmpty) {
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileEdit(
              selectedImage: "", profileImage: uploadedUrl, cameraImage: ""),
        ),
      );
    } catch (e) {
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
      print('📤 _uploadSelectedImage 호출됨');

      // ✅ selectedImage가 asset이 아닌 경우 생략
      if (widget.selectedImage.isEmpty ||
          !widget.selectedImage.startsWith("assets/")) {
        print('⏭️ selectedImage가 asset이 아님 — 업로드 생략: ${widget.selectedImage}');
        return;
      }

      print('📷 selectedImage 경로: ${widget.selectedImage}');

      ByteData byteData = await rootBundle.load(widget.selectedImage);
      Uint8List imageBytes = byteData.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/profile_image.png';
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      print('📁 파일로 저장 완료: $filePath');

      PlatformFile selectedFile = PlatformFile(
        name: 'profile_image.png',
        path: filePath,
        size: imageBytes.length,
      );

      List<PlatformFile> fileList = [selectedFile];
      String uploadedUrl = await UploadFileService.uploadFiles(fileList);

      if (uploadedUrl.isNotEmpty) {
        setState(() {
          _imageFiles.clear();
          _imageFiles.add(uploadedUrl);
          profile = uploadedUrl;
        });
        print('✅ 이미지 업로드 성공: $uploadedUrl');
      } else {
        print('⚠️ 업로드 실패: 빈 URL');
      }
    } catch (e) {
      print('❌ 이미지 업로드 중 예외 발생: $e');
      Fluttertoast.showToast(
        msg: '이미지 업로드 오류: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  ImageProvider getImageProvider({
    required String selectedImage,
    required String profileImage,
    required String cameraImage,
    required String fallbackAsset,
  }) {
    // 우선순위: profile > selected > camera
    String imageToShow = "";

    if (profileImage.isNotEmpty) {
      imageToShow = profileImage;
    } else if (selectedImage.isNotEmpty) {
      imageToShow = selectedImage;
    } else if (cameraImage.isNotEmpty) {
      imageToShow = cameraImage;
    }

    // 모두 비었을 경우 기본 asset 이미지
    if (imageToShow.isEmpty) {
      return AssetImage(fallbackAsset);
    }

    // asset 이미지일 경우 (assets/로 시작하면 asset으로 간주)
    if (imageToShow.startsWith('assets/')) {
      return AssetImage(imageToShow);
    }

    // 나머지는 S3 URL이므로 NetworkImage로 처리
    return NetworkImage(imageToShow);
  }

  Future<bool> _editProfile(
      String nickname, String profile, String description) async {
    try {
      print('_editProfile 실행');
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
        nickname = data['nickname'] ?? "도민호";
        description = data['description'] ?? "매일의 목표: 행보칸 하루 살기";
        profile = data['profile'] ?? "";
      });

      _nicknamecontroller.text = nickname ?? "";
      _explaincontroller.text = description ?? "";
    }
  }

  void _onNicknameChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _checkGalleryThenPickImages() async {
    bool granted = await PermissionUtil.checkAndRequestGalleryPermission(context);
    if (granted) {
      _imageFiles.clear();
      await _pickImages();
    }
  }

  @override
  void initState() {
    super.initState();
    userInfo();
    _nicknamecontroller.addListener(_onNicknameChanged);
    print('selectedImage: ${widget.selectedImage}');
    print('profileImage: ${widget.profileImage}');
    print('cameraImage: ${widget.cameraImage}');
  }

  @override
  void dispose() {
    _nicknamecontroller.removeListener(_onNicknameChanged);
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
              CustomIconButton(() {
                Navigator.of(context).pop();
              }, Icons.keyboard_arrow_left_rounded, currentWidth)
                  .customIconButton(),
              SizedBox(width: currentWidth < 600 ? 10 : 14),
              Text('프로필 편집',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 27,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff303030),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.05), // 검은색 10% 투명도
                                    offset: const Offset(0, 0), // X, Y 위치 (0,0)
                                    blurRadius: 7, // 블러 7
                                    spreadRadius: 0, // 스프레드 0
                                  ),
                                ],
                              ),
                              child: Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.05), // 검은색 10% 투명도
                                      offset:
                                          const Offset(0, 0), // X, Y 위치 (0,0)
                                      blurRadius: 7, // 블러 7
                                      spreadRadius: 0, // 스프레드 0
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: getImageProvider(
                                      selectedImage: widget.selectedImage,
                                      profileImage:
                                          profile ?? widget.profileImage,
                                      cameraImage: widget.cameraImage,
                                      fallbackAsset: defaultImage,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                right: currentWidth < 600 ? 20 : 35,
                                top: currentWidth < 600 ? 110 : 200,
                                child: CircleAvatar(
                                    radius: currentWidth < 600 ? 14 : 20,
                                    backgroundColor: mainRed,
                                    child: Icon(Icons.edit,
                                        size: currentWidth < 600 ? 15 : 24,
                                        color: backgroundColor))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
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

                          return NewCustomTextField(
                                  'Ex. 꿈꾸는 마이클',
                                  _nicknamecontroller,
                                  (value) => null, // validator
                                  false, // obscureText
                                  1,
                                  currentWidth // maxLines
                                  )
                              .newtextField(
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
                        child: NewCustomTextField(
                                'Ex. 명랑하면서 도전적인 사람!',
                                _explaincontroller,
                                (value) => null,
                                false,
                                3,
                                currentWidth)
                            .newtextField()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NewButton(Colors.black, Colors.white, '취소', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyGoal(),
                ),
              );
            }, currentWidth)
                .newButton(),
            NewButton(Colors.black, Colors.white, '완료', () async {
              await _uploadSelectedImage(); // 🔹 이미지 업로드 완료까지 대기

              String profileToUpload;

              // 1순위: 새로 업로드된 이미지
              if (_imageFiles.isNotEmpty) {
                profileToUpload = _imageFiles[0];
              }
              // 2순위: 기존에 서버에 저장된 이미지 (profile 변수 또는 widget.profileImage) → 단, asset이 아니어야 함
              else if ((profile ?? widget.profileImage).isNotEmpty &&
                  !(profile ?? widget.profileImage).startsWith('assets/')) {
                profileToUpload = profile ?? widget.profileImage;
              }
              // 3순위: 이미지가 없을 경우만 빈 문자열
              else {
                profileToUpload = '';
              }

              bool isEdited = await _editProfile(
                _nicknamecontroller.text,
                profileToUpload, // 🔹 빈 문자열도 가능
                _explaincontroller.text,
              );

              if (isEdited) {
                // 🔹 프로필 수정 성공 시 이동
                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyGoal()),
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
            }, currentWidth)
                .newButton()
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Color.fromARGB(255, 46, 46, 46),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      builder: (context) {
        return FractionallySizedBox(
          widthFactor: 0.9,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '어디서 사진을 가져올까요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    //카메라
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          setState(() {
                            _imageFiles.clear();
                          });
                          await _takePhoto();
                        },
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff262626)),
                          child: Center(
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '카메라',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          _checkGalleryThenPickImages();
                        },
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff262626)),
                          child: Center(
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.insert_photo,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '앨범',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
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
                          height: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Color(0xff262626)),
                          child: Center(
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.grade,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '도민호 갤러리',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
