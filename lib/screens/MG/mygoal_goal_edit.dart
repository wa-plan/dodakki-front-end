import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:domino/widgets/popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:domino/apis/services/image_services.dart';
import 'package:domino/widgets/MG/calender.dart';

class MygoalEdit extends StatefulWidget {
  final String name;
  final int dday;
  final String description;
  final String color; // 색상 전달
  final List<String> goalImage;
  final String id;

  const MygoalEdit(
      {super.key,
      required this.id,
      required this.name,
      required this.dday,
      required this.description,
      required this.color,
      required this.goalImage});

  @override
  State<MygoalEdit> createState() => _MygoalEditState();
}

class _MygoalEditState extends State<MygoalEdit> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _descriptcontroller = TextEditingController();
  DateTime calculatedDate = DateTime.now();
  List<String> _imageFiles = [];
  Color? _selectedColor;
  DateTime? selectedDate;
  DateTime? _selectedDate;
  List<String> goalImage = [];
  bool _isDeleting = false; // 삭제 중인지 상태 저장

  @override
  void initState() {
    super.initState();

    // dday 계산
    calculatedDate = DateTime.now().add(Duration(days: widget.dday));
    _selectedDate = calculatedDate;

    // 전달받은 색상 설정
    _selectedColor = Color(
        int.parse(widget.color.replaceAll('Color(', '').replaceAll(')', '')));

    // 🔹 초깃값 설정
    _namecontroller.text = widget.name; // widget.name을 초깃값으로 설정
    _descriptcontroller.text = widget.description; // 목표 설명 초기값 설정

    goalImage = List.from(widget.goalImage);
  }

  Future<void> _pickImages() async {
    try {
      // ✅ 이미지 개수 제한: 3개 이상 추가할 수 없도록 버튼이 비활성화됨
      if (goalImage.length + _imageFiles.length >= 3) {
        return; // 추가 못하도록 아무 동작도 하지 않음
      }

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
            // ✅ 중복 방지 & 3개까지만 유지
            _imageFiles = [
              ...{..._imageFiles, uploadedUrl}
            ].take(3 - goalImage.length).toList();
          });
        }
      }
    } catch (e) {}
  }

  void _deleteImage(int index) async {
    if (_isDeleting) return; // 이미 삭제 중이면 중복 실행 방지
    if (goalImage.isEmpty && _imageFiles.isEmpty) {
      return;
    }

    setState(() {
      _isDeleting = true; // 삭제 중 상태로 변경
    });

    String imageToDelete;
    bool isServerImage = index < goalImage.length; // 기존 저장된 이미지인지 여부 확인

    if (isServerImage) {
      imageToDelete = goalImage[index];
    } else {
      int newIndex = index - goalImage.length;
      if (newIndex < _imageFiles.length) {
        imageToDelete = _imageFiles[newIndex];
      } else {
        setState(() {
          _isDeleting = false; // 삭제 실패 시 다시 삭제 가능하도록 설정
        });
        return;
      }
    }

    // ✅ 기존 저장된 이미지인 경우에만 서버에서 삭제 요청
    bool success = true;
    if (isServerImage) {
      success = await DeleteFileService.deleteFile(imageToDelete);
    }

    if (success) {
      setState(() {
        if (isServerImage) {
          goalImage.removeAt(index);
          widget.goalImage.removeAt(index);
        } else {
          _imageFiles.removeAt(index - goalImage.length);
        }
      });
    } else {
      Fluttertoast.showToast(
        msg: "이미지 삭제 실패",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    setState(() {
      _isDeleting = false; // 삭제 완료 후 다시 삭제 가능하도록 설정
    });
  }

  /*void _deleteImage(int index) async {
    if (goalImage.isEmpty && _imageFiles.isEmpty) {
      print("⚠️ 삭제할 이미지가 없습니다.");
      return;
    }

    String imageToDelete;
    if (index < goalImage.length) {
      imageToDelete = goalImage[index];
    } else {
      int newIndex = index - goalImage.length;
      if (newIndex < _imageFiles.length) {
        imageToDelete = _imageFiles[newIndex];
      } else {
        print("❌ 잘못된 index: $index");
        return;
      }
    }

    // ✅ 서버에서 이미지 삭제 요청
    bool success = await DeleteFileService.deleteFile(imageToDelete);

    if (success) {
      setState(() {
        if (index < goalImage.length) {
          goalImage.removeAt(index);
          widget.goalImage.removeAt(index);
        } else {
          _imageFiles.removeAt(index - goalImage.length);
        }
      });

      print("✅ 삭제 후 goalImage: $goalImage");
      print("✅ 삭제 후 _imageFiles: $_imageFiles");
    } else {
      print("❌ 서버에서 이미지 삭제 실패");
      Fluttertoast.showToast(
        msg: "이미지 삭제 실패",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }*/

  Future<bool> _editName(String name, int mandalartId) async {
    try {
      final success = await EditGoalNameService.editGoalName(
        name: name,
        mandalartId: mandalartId,
      );
      return success;
    } catch (e) {
      debugPrint('Error in _editName: $e');
      return false;
    }
  }

  Future<bool> _editDate(String newDate, int mandalartId) async {
    try {
      final success = await EditGoalDateService.editGoalDate(
        newDate: newDate,
        mandalartId: mandalartId,
      );
      return success;
    } catch (e) {
      debugPrint('Error in _editDate: $e');
      return false;
    }
  }

  Future<bool> _editDescript(String description, int mandalartId) async {
    try {
      final success = await EditGoalDescriptionService.editGoalDescription(
        description: description,
        mandalartId: mandalartId,
      );
      return success;
    } catch (e) {
      debugPrint('Error in _editDescription: $e');
      return false;
    }
  }

  Future<bool> _editPhoto(List<String> photo, int mandalartId) async {
    try {
      final success = await EditGoalPhotoService.editGoalPhoto(
        photo: photo,
        mandalartId: mandalartId,
      );
      return success;
    } catch (e) {
      debugPrint('Error in _editName: $e');
      return false;
    }
  }

  Future<bool> _editColor(String color, int mandalartId) async {
    try {
      final success = await EditGoalColorService.editGoalColor(
        color: color,
        mandalartId: mandalartId,
      );
      return success;
    } catch (e) {
      debugPrint('Error in _editColor: $e');
      return false;
    }
  }

  // 날짜 형식을 변환하는 메서드
  String convertDateTimeDisplay(String date, String text) {
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

  @override
  void dispose() {
    _namecontroller.dispose();
    _descriptcontroller.dispose();
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
              Text('목표 편집하기',
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
              SizedBox(height: 10),
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
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05), // 검은색 10% 투명도
                          offset: const Offset(0, 0), // X, Y 위치 (0,0)
                          blurRadius: 7, // 블러 7
                          spreadRadius: 0, // 스프레드 0
                        ),
                      ],
                    ),
                    child: NewCustomTextField("", _namecontroller,
                            (value) => null, false, 1, currentWidth)
                        .newtextField(),
                  )
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.05), // 검은색 10% 투명도
                                  offset: const Offset(0, 0), // X, Y 위치 (0,0)
                                  blurRadius: 7, // 블러 7
                                  spreadRadius: 0, // 스프레드 0
                                ),
                              ],
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
                ],
              ),

              //const SizedBox(height: 10),
              //여기는 왜 체크박스가 없지?
              const SizedBox(height: 40),
              //목표에 대해서 더 알려주세요.
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Question(question: '목표에 대해서 더 알려주세요.'),
                  const SizedBox(height: 8),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05), // 검은색 10% 투명도
                          offset: const Offset(0, 0), // X, Y 위치 (0,0)
                          blurRadius: 7, // 블러 7
                          spreadRadius: 0, // 스프레드 0
                        ),
                      ],
                    ),
                    child: NewCustomTextField("", _descriptcontroller,
                            (value) => null, false, 5, currentWidth)
                        .newtextField(),
                  )
                ],
              ),
              const SizedBox(height: 40),

              // 목표를 보여주는 사진이 있나요?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Question(question: '목표를 보여주는 사진이 있나요?'),
                  const SizedBox(height: 8),
                  // 이미지 선택 UI
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // ✅ 최신 상태를 유지하도록 리스트 병합 후 사용
                              ...List.generate(
                                goalImage.length + _imageFiles.length,
                                (index) {
                                  String imageData = index < goalImage.length
                                      ? goalImage[index] // 기존 저장된 이미지
                                      : _imageFiles[index -
                                          goalImage.length]; // 새로 추가한 이미지

                                  return Stack(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(
                                                          0.05), // 검은색 10% 투명도
                                                  offset: const Offset(
                                                      0, 0), // X, Y 위치 (0,0)
                                                  blurRadius: 7, // 블러 7
                                                  spreadRadius: 0, // 스프레드 0
                                                ),
                                              ],
                                              color: Color(
                                                  0xff2A2A2A), // ✅ 로드 실패 대비 배경 설정
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      6)), // ✅ 로드 실패 대비 배경
                                          child: imageData.startsWith("http")
                                              ? Image.network(
                                                  imageData,
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
                                },
                              ),

                              // ✅ 최대 3개 미만일 때만 추가 버튼 표시
                              if (goalImage.length + _imageFiles.length < 3)
                                GestureDetector(
                                  onTap: _pickImages, // 🔹 이미지 선택 함수 호출
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                                0.05), // 검은색 10% 투명도
                                            offset: const Offset(
                                                0, 0), // X, Y 위치 (0,0)
                                            blurRadius: 7, // 블러 7
                                            spreadRadius: 0, // 스프레드 0
                                          ),
                                        ],
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
                          .tag(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xff2A2A2A)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ColorOption(
                          colorCode: const Color(0xffFF7A7A),
                          isSelected: _selectedColor == const Color(0xffFF7A7A),
                          onTap: () =>
                              _onColorSelected(const Color(0xffFF7A7A)),
                        ),
                        ColorOption(
                          colorCode: const Color(0xffFFB82D),
                          isSelected: _selectedColor == const Color(0xffFFB82D),
                          onTap: () =>
                              _onColorSelected(const Color(0xffFFB82D)),
                        ),
                        //여기기
                        ColorOption(
                          colorCode: const Color(0xffFCFF62),
                          isSelected: _selectedColor == const Color(0xffFCFF62),
                          onTap: () =>
                              _onColorSelected(const Color(0xffFCFF62)),
                        ),
                        ColorOption(
                          colorCode: const Color(0xff72FF5B),
                          isSelected: _selectedColor == const Color(0xff72FF5B),
                          onTap: () =>
                              _onColorSelected(const Color(0xff72FF5B)),
                        ),
                        ColorOption(
                          colorCode: const Color(0xff5DD8FF),
                          isSelected: _selectedColor == const Color(0xff5DD8FF),
                          onTap: () =>
                              _onColorSelected(const Color(0xff5DD8FF)),
                        ),
                        ColorOption(
                          colorCode: const Color(0xffFFFFFF),
                          isSelected: _selectedColor == const Color(0xffFFFFFF),
                          onTap: () =>
                              _onColorSelected(const Color(0xffFFFFFF)),
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
      bottomNavigationBar: Padding(padding: fullPadding,
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //취소버튼
                  NewButton(Colors.black, Colors.white, '취소',
                          () => Navigator.pop(context), currentWidth)
                      .newButton(),

                  //삭제버튼
                  NewButton(Color(0xff6A1B1B), Colors.white, '삭제', () {
                    PopupDialog.show(
                      context,
                      '이건 아니야.. \n정말 떠날거야...?',
                      true, // cancel
                      true, // delete
                      false, //signout
                      false, // success
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                      onDelete: () async {
                        bool isDeleted =
                            await DeleteFirstGoalService.deleteFirstGoal(
                          context,
                          int.parse(widget.id),
                        );
                        if (isDeleted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyGoal(),
                            ),
                          );
                        }
                      },
                      onSignOut: () {},
                    );
                  }, currentWidth)
                      .newButton(),

                  //완료버튼
                  NewButton(Colors.black, Colors.white, '저장', () async {
                    // 모든 API 호출이 성공했는지 확인할 변수
                    bool isSuccess = true;

                    // 🔹 목표 이름 수정
                    bool nameSuccess = await _editName(
                        _namecontroller.text, int.parse(widget.id));
                    if (!nameSuccess) {
                      isSuccess = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('목표 이름 저장에 실패했습니다.')),
                      );
                    }

                    // 🔹 목표 설명 수정
                    bool descriptSuccess = await _editDescript(
                        _descriptcontroller.text, int.parse(widget.id));
                    if (!descriptSuccess) {
                      isSuccess = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('목표 설명 저장에 실패했습니다.')),
                      );
                    }

                    for (String imageUrl in goalImage) {
                      bool deleteSuccess =
                          await DeleteFileService.deleteFile(imageUrl);
                      if (!deleteSuccess) {
                        isSuccess = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('기존 이미지 삭제에 실패했습니다.')),
                        );
                      }
                    }

                    // 🔹 2️⃣ 삭제가 모두 성공했을 경우에만 새로운 이미지 저장 진행
                    if (isSuccess) {
                      List<String> finalImageList = [
                        ...goalImage,
                        ..._imageFiles
                      ];

                      // 🔹 3️⃣ 최종적으로 서버에 업데이트 요청
                      bool photoSuccess = await _editPhoto(
                          finalImageList, int.parse(widget.id));

                      if (!photoSuccess) {
                        isSuccess = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('목표 사진 저장에 실패했습니다.')),
                        );
                      }
                    }

                    // 🔹 날짜 변환 후 목표 날짜 수정
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(calculatedDate);
                    bool dateSuccess =
                        await _editDate(formattedDate, int.parse(widget.id));
                    if (!dateSuccess) {
                      isSuccess = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('목표 날짜 저장에 실패했습니다.')),
                      );
                    }

                    final colorHex = _selectedColor != null
                        ? '0x${_selectedColor!.value.toRadixString(16)}'
                        : '0xffffffff'; // 기본값으로 흰색 (Color(0xffffffff))

                    // 🔹 목표 색상 수정
                    bool colorSuccess =
                        await _editColor(colorHex, int.parse(widget.id));
                    if (!colorSuccess) {
                      isSuccess = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('목표 색상 저장에 실패했습니다.')),
                      );
                    }

                    // 🔹 모든 API 호출이 성공했을 경우만 화면 닫기
                    if (isSuccess) {
                      Navigator.pop(context);
                    }
                  }, currentWidth)
                      .newButton(),
                ],
              ),),
    );
  }
}

class DatePicker extends StatelessWidget {
  final DateTime initialDay;
  final ValueChanged<DateTime> onDateChanged;

  const DatePicker({
    super.key,
    required this.initialDay,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDay,
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          onDateChanged(pickedDate);
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('yyyy-MM-dd').format(initialDay),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Icon(Icons.calendar_today, color: Colors.white),
        ],
      ),
    );
  }
}

class ColorOption extends StatelessWidget {
  final Color colorCode;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOption({
    super.key,
    required this.colorCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(currentWidth < 600 ? 5 : 10),
        child: Container(
          width: currentWidth < 600 ? 33 : 50,
          height: currentWidth < 600 ? 33 : 50,
          decoration: BoxDecoration(
            color: colorCode,
            borderRadius: BorderRadius.circular(5),
          ),
          child: isSelected
              ? Icon(
                  Icons.check_circle_rounded,
                  color: const Color(0xff303030),
                  size: currentWidth < 600 ? 20 : 22,
                )
              : null,
        ),
      ),
    );
  }
}
