import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:domino/styles.dart';
import 'package:domino/widgets/MG/calender.dart';
import 'package:file_picker/file_picker.dart';
import 'package:domino/apis/services/image_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/MG/mygoal_main.dart';

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
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color(0xffD4D4D4),
                iconSize: 17,
              ),
              Text(
                '목표 세우기',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 목표 설명
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Question(question: '어떤 목표인가요?'),
                      const Tag(Color.fromARGB(255, 59, 59, 59),
                              Colors.transparent, '필수')
                          .tag()
                    ],
                  ),
                  const SizedBox(height: 13),
                  SizedBox(
                      height: 40,
                      child: CustomTextField('Ex. 환상적인 세계여행', _nameController,
                              (value) {
                        return null;
                      }, false, 1)
                          .textField()),
                ],
              ),

              const SizedBox(height: 40),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Question(question: '언제까지 목표를 이루고 싶나요?'),
                      const Tag(Color.fromARGB(255, 59, 59, 59),
                              Colors.transparent, '필수')
                          .tag()
                    ],
                  ),
                  const SizedBox(height: 13),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          height: 40,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: const Color(0xff2A2A2A)),
                          child: Text(
                            _selectedDate != null
                                ? DateFormat('yyyy년 MM월 dd일')
                                    .format(_selectedDate!) // 선택된 날짜 포맷팅

                                : '클릭해서 날짜를 선택해 주세요.', // null인 경우 출력

                            style: TextStyle(
                              color: _selectedDate != null
                                  ? Colors.white
                                  : const Color.fromARGB(255, 113, 113, 113),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Button(
                        Colors.black,
                        Colors.white,
                        '달력',
                        () {
                          showCalendarPopup(context, (DateTime? selectedDate) {
                            if (selectedDate != null) {
                              setState(() {
                                _selectedDate = selectedDate; // 상위 화면의 변수에 저장
                              });
                            }
                            print(_selectedDate); // 선택된 날짜 확인
                          });
                        },
                      ).button(),
                    ],
                  ),
                  const SizedBox(height: 13),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        checkColor: backgroundColor,
                        activeColor: mainRed,
                        visualDensity: VisualDensity.compact,
                        value: _isChecked,
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
                      const SizedBox(width: 5),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "확실하지 않아요",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 5),
                          Text(
                            '그럼 오늘부터 날짜를 세어나갈게요.',
                            style: TextStyle(
                                color: Color(0xff909090),
                                fontSize: 10,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Question(question: '목표에 대해서 더 알려주세요.'),
                  const SizedBox(height: 13),
                  SizedBox(
                      height: 80,
                      child: CustomTextField(
                              'Ex. 유럽, 아프리카, 아시아 등 전세계 구석구석을 배낭 하나로 여행하기!',
                              _descriptionController, (value) {
                        return null;
                      }, false, 5)
                          .textField()),
                ],
              ),

              const SizedBox(height: 40),

              // 목표 사진 선택
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Question(question: '목표를 보여주는 사진이 있나요?'),
                  const SizedBox(height: 13),
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
                                      child: CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors
                                            .grey[300], // ✅ 로드 실패 대비 배경 설정
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              40), // ✅ 원형 이미지 유지
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
                                  onTap: _pickImages, // 🔹 이미지 선택 함수 호출
                                  child: const CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                        Color.fromARGB(255, 79, 79, 79),
                                    child: Icon(Icons.add_a_photo,
                                        color:
                                            Color.fromARGB(255, 173, 173, 173)),
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

              // 목표 색상 선택
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Question(question: '목표를 색깔로 표현해주세요.'),
                      const Tag(Color.fromARGB(255, 59, 59, 59),
                              Colors.transparent, '필수')
                          .tag()
                    ],
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorOption2(
                        colorCode: const Color(0xffFF7A7A),
                        isSelected: _selectedColor == const Color(0xffFF7A7A),
                        onTap: () => _onColorSelected(const Color(0xffFF7A7A)),
                      ),
                      ColorOption2(
                        colorCode: const Color(0xffFFB82D),
                        isSelected: _selectedColor == const Color(0xffFFB82D),
                        onTap: () => _onColorSelected(const Color(0xffFFB82D)),
                      ),
                      ColorOption2(
                        colorCode: const Color(0xffFCFF62),
                        isSelected: _selectedColor == const Color(0xffFCFF62),
                        onTap: () => _onColorSelected(const Color(0xffFCFF62)),
                      ),
                      ColorOption2(
                        colorCode: const Color(0xff72FF5B),
                        isSelected: _selectedColor == const Color(0xff72FF5B),
                        onTap: () => _onColorSelected(const Color(0xff72FF5B)),
                      ),
                      ColorOption2(
                        colorCode: const Color(0xff5DD8FF),
                        isSelected: _selectedColor == const Color(0xff5DD8FF),
                        onTap: () => _onColorSelected(const Color(0xff5DD8FF)),
                      ),
                      ColorOption2(
                        colorCode: const Color(0xffffffff),
                        isSelected: _selectedColor == const Color(0xffffffff),
                        onTap: () => _onColorSelected(const Color(0xffffffff)),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //취소버튼
                  Button(Colors.black, Colors.white, '취소',
                      () => Navigator.pop(context)).button(),

                  //완료버튼
                  Button(
                    Colors.black,
                    Colors.white,
                    '완료',
                    () {
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
                    },
                  ).button(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
