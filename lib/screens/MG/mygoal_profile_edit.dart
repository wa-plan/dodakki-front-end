import 'dart:io';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_myGoal.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:domino/screens/MG/profile_img_samplegallery.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:domino/apis/services/image_services.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:domino/utils/permission_util.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

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

    // 📌 촬영한 사진을 서버에 업로드
    String uploadedUrl = await _uploadCamera(imageFile);

    if (uploadedUrl.isNotEmpty) {
      setState(() {
        _imageFiles.clear(); // 이전 이미지 제거
        _imageFiles.add(uploadedUrl); // 새 URL 저장
        profile = uploadedUrl; // ✅ 상태에 반영 (중요!)
      });
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
      return; // 업로드가 실패했으므로 함수 종료
    }

    setState(() {
      _imageFiles.add(uploadedUrl); // URL을 _imageFiles에 추가
    });

    setState(() {
      _imageFiles.clear();
      _imageFiles.add(uploadedUrl);
      profile = uploadedUrl; // 🔥 여기서 profile 변수 갱신!
    });
  }

  /*Future<void> _uploadSelectedImage() async {
    print('📤 _uploadSelectedImage 호출됨');

    // ✅ selectedImage가 asset이 아닌 경우 생략
    if (widget.selectedImage.isEmpty) {
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
        print('함수 내부 _imageFiles: $uploadedUrl');
      });
    }
  }*/

  Future<void> _uploadSelectedImage() async {
    print('📤 _uploadSelectedImage 호출됨');

    if (widget.selectedImage.isEmpty) {
      print('⏭️ selectedImage가 비어 있음 — 업로드 생략');
      return;
    }

    print('📷 selectedImage 경로: ${widget.selectedImage}');

    late Uint8List imageBytes;
    String filename = 'profile_image.png';

    try {
      if (widget.selectedImage.startsWith('http')) {
        // ✅ URL 이미지 처리
        final response = await http.get(Uri.parse(widget.selectedImage));
        if (response.statusCode == 200) {
          imageBytes = response.bodyBytes;
          filename = path.basename(widget.selectedImage);
          print('🌐 네트워크 이미지 다운로드 완료');
        } else {
          print('⚠️ 이미지 다운로드 실패: ${response.statusCode}');
          return;
        }
      } else {
        // ✅ 로컬 asset 처리
        final byteData = await rootBundle.load(widget.selectedImage);
        imageBytes = byteData.buffer.asUint8List();
        filename = path.basename(widget.selectedImage);
        print('📦 로컬 asset 로드 완료');
      }

      // ✅ 임시 파일로 저장
      final directory = await getTemporaryDirectory();
      final filePath = path.join(directory.path, filename);
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);
      print('📁 파일로 저장 완료: $filePath');

      // ✅ 업로드
      final selectedFile = PlatformFile(
        name: filename,
        path: filePath,
        size: imageBytes.length,
      );

      final fileList = [selectedFile];
      final uploadedUrl = await UploadFileService.uploadFiles(fileList);

      if (uploadedUrl.isNotEmpty) {
        setState(() {
          _imageFiles.clear();
          _imageFiles.add(uploadedUrl);
          profile = uploadedUrl;
          print('✅ 업로드 완료: $uploadedUrl');
        });
      }
    } catch (e) {
      print('❌ 업로드 중 오류 발생: $e');
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

    if (profileImage.isNotEmpty &&
        profileImage !=
            'https://dodakkibucket.s3.ap-northeast-2.amazonaws.com/baseImage.png') {
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
        if (widget.selectedImage.isEmpty) {
          profile = data['profile'] ?? "";
        }
        //profile = data['profile'] ?? "";
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
    bool granted =
        await PermissionUtil.checkAndRequestGalleryPermission(context, '이미지');
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
    print('selectedImage:${widget.selectedImage}');
    print('cameraImage:${widget.cameraImage}');
    print('profileImage:${widget.profileImage}');
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
              //나가기 버튼
              CustomBackButton(
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyGoal()),
                  );
                },
              ).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('프로필 편집').pageTitle(),
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
                                    color: Colors.black.withOpacity(0.05),
                                    offset: const Offset(0, 0),
                                    blurRadius: 7,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Container(
                                width: 160,
                                height: 160,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      offset: const Offset(0, 0),
                                      blurRadius: 7,
                                      spreadRadius: 0,
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
                                right: 20,
                                top: 125,
                                child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: mainRed,
                                    child: Icon(Icons.edit,
                                        size: 18, color: backgroundColor))),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    //닉네임 부분
                    const FieldTitle('닉네임을 만들어봐요.').fieldTitle(),
                    const SizedBox(height: 10),
                    StatefulBuilder(
                      builder: (context, setState) {
                        // 🔹 리스너 추가: 입력값 변경 시 setState() 호출
                        _nicknamecontroller.addListener(() {
                          setState(() {});
                        });

                        return NewCustomTextField(
                                '꿈꾸는 마이클',
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

                    const SizedBox(height: 40),

                    //설명 부분
                    const FieldTitle('당신은 어떤 사람이 되고 싶나요?').fieldTitle(),
                    const SizedBox(height: 10),
                    NewCustomTextField('명랑하면서 도전적인 사람?', _explaincontroller,
                            (value) => null, false, 3, currentWidth)
                        .newtextField()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: fullPadding,
          //저장하기 버튼
          child: LoginButton('저장하기', () async {
            print('확인: ${widget.selectedImage}');

            // ✅ 이미지 파일이 없을 경우에만 업로드 시도
            if (_imageFiles.isEmpty) {
              await _uploadSelectedImage();
            }

            String profileToUpload;

            if (_imageFiles.isNotEmpty) {
              profileToUpload = _imageFiles[0];
            } else if ((profile ?? widget.profileImage).isNotEmpty &&
                !(profile ?? widget.profileImage).startsWith('assets/')) {
              profileToUpload = profile ?? widget.profileImage;
            } else {
              profileToUpload = '';
            }

            bool isEdited = await _editProfile(
              _nicknamecontroller.text,
              profileToUpload,
              _explaincontroller.text,
            );

            if (isEdited) {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyGoal()),
                );
              }
            } else {
              TutorialMessage('프로필 수정에 실패했습니다.').tutorialMessage(context);
            }
          }).loginButton()),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      backgroundColor: backgroundColor,
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
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '어디서 사진을 가져올까요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                BottomButton('카메라', Icons.photo_camera, () async {
                  Navigator.pop(context);
                  setState(() {
                    _imageFiles.clear();
                  });
                  await _takePhoto();
                }).bottomButton(),
                const SizedBox(height: 10),
                BottomButton('갤러리', Icons.photo, () async {
                  Navigator.pop(context);
                  _checkGalleryThenPickImages();
                }).bottomButton(),
                const SizedBox(height: 10),
                BottomButton('도민호 이미지', Icons.star, () async {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSampleGallery(
                          selectedImage: widget.selectedImage,
                          profileImage: widget.profileImage),
                    ),
                  );
                }).bottomButton()
              ],
            ),
          ),
        );
      },
    );
  }
}
