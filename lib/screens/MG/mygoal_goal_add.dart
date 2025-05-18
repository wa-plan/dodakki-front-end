import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/MG/calender.dart';
import 'package:file_picker/file_picker.dart';
import 'package:domino/apis/services/image_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:domino/utils/permission_util.dart';

class MyGoalAdd extends StatefulWidget {
  const MyGoalAdd({super.key});

  @override
  State<MyGoalAdd> createState() => _MyGoalAddState();
}

class _MyGoalAddState extends State<MyGoalAdd> {
  bool _isChecked = false;
  Color? _selectedColor;
  DateTime? selectedDate;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? uploadedImageResponse;
  final List<String> _imageFiles = [];

  Future<void> _pickImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        withData: kIsWeb, // 웹에서는 true, 모바일에서는 false
      );

      if (result != null) {
        // 파일 업로드 서비스 호출
        String uploadedUrl = await UploadFileService.uploadFiles(result.files);

        if (uploadedUrl.isNotEmpty) {
          setState(() {
            _imageFiles.add(uploadedUrl); // URL을 _imageFiles에 추가
          });
        } else {}
      }
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

  void _deleteImage(int index) {
    setState(() {
      if (index >= 0 && index < _imageFiles.length) {
        _imageFiles.removeAt(index);
      }
    });
  }

  void _addGoal() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    final colorHex = _selectedColor != null
        ? '0x${_selectedColor!.value.toRadixString(16)}'
        : '0xffffffff'; // 기본값으로 흰색 (Color(0xffffffff))

    final String date = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now()); // null일 경우 현재 날짜를 사용

    // 이미지 업로드
    List<String> uploadedImageUrls = _imageFiles;

    print('name: $name');
    print('description: $description');
    print('colorHex: $colorHex');
    print('date: $date');
    print('uploadedImageUrls: $uploadedImageUrls');

    // AddGoalService.addGoal API 호출, 업로드된 이미지 URL 리스트를 전달
    final success = await AddGoalService.addGoal(
      name: name,
      description: description,
      color: colorHex,
      date: date,
      pictures: uploadedImageUrls, // 업로드된 이미지 URL을 전달
    );

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MyGoal(),
        ),
      );
    }
  }

  // 날짜 형식을 변환하는 메서드
  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormatter = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormatter = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormatter.parse(date);

    return serverFormatter.format(displayDate);
  }

  void _onColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
    });
  }

  void _checkGalleryThenPickImages() async {
    bool granted =
        await PermissionUtil.checkAndRequestGalleryPermission(context);
    if (granted) {
      _imageFiles.clear();
      await _pickImages();
    }
  }

  DateTime? _selectedDate; // 상위 화면에서 사용하는 상태 변수

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
              Text('목표 세우기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 27,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 어떤 목표인가요?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Question(question: '어떤 목표인가요?'),
                      const Tag(Colors.transparent, Color(0xffFF7E7E), '필수')
                          .tag()
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                      height: 40,
                      decoration: BoxDecoration(),
                      child: NewCustomTextField('', _nameController, (value) {
                        return null;
                      }, false, 1, currentWidth)
                          .newtextField()),
                ],
              ),

              const SizedBox(height: 40),
              //언제까지 목표를 이루고 싶나요?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Question(question: '언제까지 목표를 이루고 싶나요?'),
                      const Tag(Colors.transparent, Color(0xffFF7E7E), '필수')
                          .tag()
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 40,
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xff2A2A2A)),
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('yyyy년 MM월 dd일')
                                    .format(_selectedDate!) // 선택된 날짜 포맷팅

                                : '클릭해서 날짜를 선택해 주세요.', // null인 경우 출력

                            style: TextStyle(
                              color: _selectedDate != null
                                  ? Colors.white
                                  : Color(0xffAAAAAA),
                              fontSize: currentWidth < 600 ? 12 : 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 9),
                      SizedBox(
                        height: 40,
                        child: NewButton(Color(0xff161616), Colors.white, '달력',
                                () {
                          showCalendarPopup(context, (DateTime? selectedDate) {
                            if (selectedDate != null) {
                              setState(() {
                                _selectedDate = selectedDate; // 상위 화면의 변수에 저장
                              });
                            }
                          });
                        }, currentWidth)
                            .newButton(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        checkColor: Color(0xffFF7E7E),
                        activeColor: Color(0xff323232),
                        fillColor:
                            WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return Color(0xff323232); // 체크됐을 때 색상
                          }
                          return Color(0xff323232); // 체크 해제 상태 색상
                        }),
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // 모서리 둥글기 조정
                        ),
                        value: _isChecked,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap, // 여백 제거
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                            if (_isChecked) {
                              selectedDate =
                                  DateTime.now(); //목표 날짜 확실하지 않은 경우, 오늘 날짜로 설정
                            } else {
                              selectedDate = null;
                            }
                          });
                        },
                      ),
                      const SizedBox(width: 3),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "확실하지 않아요",
                            style: TextStyle(
                                fontFamily: "Pretendard",
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '그럼 오늘부터 날짜를 세어나갈게요.',
                            style: TextStyle(
                                fontFamily: "Pretendard",
                                color: Color(0xff909090),
                                fontSize: 10,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),
              //목표에 대해서 더 알려주세요.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Question(question: '목표에 대해서 더 알려주세요.'),
                  const SizedBox(height: 8),
                  Container(
                      height: 80,
                      decoration: BoxDecoration(),
                      child: NewCustomTextField('', _descriptionController,
                              (value) {
                        return null;
                      }, false, 5, currentWidth)
                          .newtextField()),
                ],
              ),

              const SizedBox(height: 40),

              // 목표를 보여주는 사진이 있나요?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Question(question: '목표를 보여주는 사진이 있나요?'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // ✅ 새로 추가한 이미지 리스트를 Map을 사용해 변환
                              ..._imageFiles.asMap().entries.map((entry) {
                                int index = entry.key;
                                var imageData = entry.value;

                                return Stack(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                            color: Color(
                                                0xff2A2A2A), // ✅ 로드 실패 대비 배경 설정
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: imageData.startsWith("http")
                                            ? Image.network(
                                                imageData, // ✅ URL이면 NetworkImage 사용
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return const Center(
                                                    child: Text(
                                                      '로드 실패', // ✅ 이미지 로드 실패 시 표시
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child: Text(
                                                  '로드 실패', // ✅ URL이 아니면 기본적으로 표시
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                      ),
                                    ),
                                    // ❗ 삭제 버튼 (Positioned 유지)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _deleteImage(index), // ✅ 삭제 기능 호출
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.black,
                                          child: Icon(Icons.close,
                                              size: 15, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),

                              // ✅ 최대 3개 미만일 때만 추가 버튼 표시
                              if (_imageFiles.length < 3)
                                GestureDetector(
                                  onTap:
                                      _checkGalleryThenPickImages, // 🔹 이미지 선택 함수 호출
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        
                                        color: Color(0xff2A2A2A),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Color(0xffAAAAAA),
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 목표를 색깔로 표현해주세요.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Question(question: '목표를 색깔로 표현해주세요.'),
                      const Tag(Colors.transparent, Color(0xffFF7E7E), '필수')
                          .tag()
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xff2A2A2A)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColorOption2(
                          colorCode: const Color(0xffFF7A7A),
                          isSelected: _selectedColor == const Color(0xffFF7A7A),
                          onTap: () =>
                              _onColorSelected(const Color(0xffFF7A7A)),
                        ),
                        ColorOption2(
                          colorCode: const Color(0xffFFB82D),
                          isSelected: _selectedColor == const Color(0xffFFB82D),
                          onTap: () =>
                              _onColorSelected(const Color(0xffFFB82D)),
                        ),
                        ColorOption2(
                          colorCode: const Color(0xffFCFF62),
                          isSelected: _selectedColor == const Color(0xffFCFF62),
                          onTap: () =>
                              _onColorSelected(const Color(0xffFCFF62)),
                        ),
                        ColorOption2(
                          colorCode: const Color(0xff72FF5B),
                          isSelected: _selectedColor == const Color(0xff72FF5B),
                          onTap: () =>
                              _onColorSelected(const Color(0xff72FF5B)),
                        ),
                        ColorOption2(
                          colorCode: const Color(0xff5DD8FF),
                          isSelected: _selectedColor == const Color(0xff5DD8FF),
                          onTap: () =>
                              _onColorSelected(const Color(0xff5DD8FF)),
                        ),
                        ColorOption2(
                          colorCode: const Color(0xffffffff),
                          isSelected: _selectedColor == const Color(0xffffffff),
                          onTap: () =>
                              _onColorSelected(const Color(0xffffffff)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //취소버튼
            NewButton(Colors.black, Colors.white, '취소',
                    () => Navigator.pop(context), currentWidth)
                .newButton(),

            //완료버튼
            NewButton(Colors.black, Colors.white, '완료', () {
              if (_nameController.text == '') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('목표를 입력해 주세요.')),
                );
              } else if (!_isChecked && _selectedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('목표 날짜를 선택해 주세요.')),
                );
              } else if (_selectedColor == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('색상을 선택해 주세요.')),
                );
              } else {
                _addGoal();
              }
            }, currentWidth)
                .newButton(),
          ],
        ),
      ),
    );
  }
}
