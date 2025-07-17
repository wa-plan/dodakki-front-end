import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_myGoal.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:domino/widgets/popup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:domino/apis/services/image_services.dart';
import 'package:domino/widgets/MG/calender.dart';
import 'package:domino/utils/permission_util.dart';

class MygoalEdit extends StatefulWidget {
  final String name;
  final int dday;
  final String description;
  final String color;
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
  bool _isDeleting = false;

  Future<void> _pickImages() async {
    try {
      if (goalImage.length + _imageFiles.length >= 3) {
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        withData: kIsWeb,
      );

      if (result != null) {
        List<String> uploadedUrls =
            await UploadFilesService.uploadFiles(result.files);

        if (uploadedUrls.isNotEmpty) {
          setState(() {
            _imageFiles = [
              ...{..._imageFiles, ...uploadedUrls}
            ].take(3 - goalImage.length).toList();
          });
        }
      }
    } catch (e) {}
  }

  void _deleteImage(int index) async {
    if (_isDeleting) return;
    if (goalImage.isEmpty && _imageFiles.isEmpty) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    String imageToDelete;
    bool isServerImage = index < goalImage.length;

    if (isServerImage) {
      imageToDelete = goalImage[index];
    } else {
      int newIndex = index - goalImage.length;
      if (newIndex < _imageFiles.length) {
        imageToDelete = _imageFiles[newIndex];
      } else {
        setState(() {
          _isDeleting = false;
        });
        return;
      }
    }

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
    }

    setState(() {
      _isDeleting = false;
    });
  }

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

  void _checkGalleryThenPickImages() async {
    bool granted =
        await PermissionUtil.checkAndRequestGalleryPermission(context, '이미지');
    if (granted) {
      await _pickImages();
    }
  }

  @override
  void initState() {
    super.initState();

    calculatedDate = DateTime.now().add(Duration(days: widget.dday));
    _selectedDate = calculatedDate;

    _selectedColor = Color(
        int.parse(widget.color.replaceAll('Color(', '').replaceAll(')', '')));

    _namecontroller.text = widget.name;
    _descriptcontroller.text = widget.description;

    goalImage = List.from(widget.goalImage);
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
              //뒤로가기 버튼
              CustomBackButton(
                () {
                  Navigator.pop(context);
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.build_rounded,
                color: mainRed,
                size: 19,
              ),
              SizedBox(width: 7),
              DPTitleText('목표 수정하기', currentWidth).dPTitleText(),
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
              // ❤️어떤 목표인가요?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Question(question: '어떤 목표인가요?'),
                  const Tag(Color(0xff503333), '필수').tag()
                ],
              ),
              const SizedBox(height: 15),
              NewCustomTextField("", _namecontroller, (value) => null, false, 1,
                      currentWidth)
                  .newtextField(),

              const SizedBox(height: 40),

              //❤️언제까지 목표를 이루고 싶나요?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Question(question: '언제까지 목표를 이루고 싶나요?'),
                  const Tag(Color(0xff503333), '필수').tag()
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 55,
                      padding: const EdgeInsets.fromLTRB(20, 5, 15, 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: const Color(0xff2C2C2C)),
                      child: Text(
                        _selectedDate != null
                            ? DateFormat('yyyy년 MM월 dd일')
                                .format(_selectedDate!) // 선택된 날짜 포맷팅

                            : '달력에서 날짜를 선택해 주세요.', // null인 경우 출력

                        style: TextStyle(
                          color: _selectedDate != null
                              ? Colors.white
                              : settingGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  SizedBox(
                    height: 55,
                    child: NewButton(Color(0xff161616), Colors.white, '📅', () {
                      showCalendarPopup(context, (DateTime? selectedDate) {
                        if (selectedDate != null) {
                          setState(() {
                            _selectedDate = selectedDate; // 상위 화면의 변수에 저장
                          });
                        }
                      });
                    }, )
                        .newButton(),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              //❤️목표에 대해서 더 알려주세요.
              const Question(question: '목표에 대해서 더 알려주세요.'),
              const SizedBox(height: 15),
              NewCustomTextField("", _descriptcontroller, (value) => null,
                      false, 4, currentWidth)
                  .newtextField(),

              const SizedBox(height: 40),

              //❤️목표를 보여주는 사진이 있나요?
              const Question(question: '목표를 보여주는 사진이 있나요?'),
              const SizedBox(height: 15),
              //❤️이미지 선택 UI
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
                                  : _imageFiles[
                                      index - goalImage.length]; // 새로 추가한 이미지

                              return Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                          color: Color(
                                              0xff2C2C2C), // ✅ 로드 실패 대비 배경 설정
                                          borderRadius: BorderRadius.circular(
                                              6)), // ✅ 로드 실패 대비 배경
                                      child: imageData.startsWith("http")
                                          ? ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: Image.network(
                                                imageData,
                                                width: 90,
                                                height: 90,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Text(
                                                      '로드 실패', // ✅ 이미지 로드 실패 시 표시
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  );
                                                },
                                              ),
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
                              onTap:
                                  _checkGalleryThenPickImages, // 🔹 이미지 선택 함수 호출
                              child: Container(
                                width: 90,
                                height: 90,
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

              const SizedBox(height: 40),
              //❤️목표를 색깔로 표현해주세요.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Question(question: '목표를 색깔로 표현해주세요.'),
                  const Tag(Color(0xff503333), '필수').tag()
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: currentWidth < 600 ? double.infinity : 500,
                  padding: EdgeInsets.all(13),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0xff2C2C2C)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ColorOption(
                        colorCode: const Color(0xffFF7A7A),
                        isSelected: _selectedColor == const Color(0xffFF7A7A),
                        onTap: () => _onColorSelected(const Color(0xffFF7A7A)),
                      ),
                      ColorOption(
                        colorCode: const Color(0xffFFB82D),
                        isSelected: _selectedColor == const Color(0xffFFB82D),
                        onTap: () => _onColorSelected(const Color(0xffFFB82D)),
                      ),
                      //여기기
                      ColorOption(
                        colorCode: const Color(0xffFCFF62),
                        isSelected: _selectedColor == const Color(0xffFCFF62),
                        onTap: () => _onColorSelected(const Color(0xffFCFF62)),
                      ),
                      ColorOption(
                        colorCode: const Color(0xff72FF5B),
                        isSelected: _selectedColor == const Color(0xff72FF5B),
                        onTap: () => _onColorSelected(const Color(0xff72FF5B)),
                      ),
                      ColorOption(
                        colorCode: const Color(0xff5DD8FF),
                        isSelected: _selectedColor == const Color(0xff5DD8FF),
                        onTap: () => _onColorSelected(const Color(0xff5DD8FF)),
                      ),
                      ColorOption(
                        colorCode: const Color(0xffFFFFFF),
                        isSelected: _selectedColor == const Color(0xffFFFFFF),
                        onTap: () => _onColorSelected(const Color(0xffFFFFFF)),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 20,
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
            //이전 버튼
          Expanded(
            flex: 1,
            child: NewButton(Color(0xff2C2C2C), settingGrey, '취소', () {
              Navigator.pop(context);
            }).newButton(),
          ),
          SizedBox(width: 15),
          //완료 버튼
          Expanded(
            flex: currentWidth < 330 ? 2 : 3,
            child: NewButton(mainRed, backgroundColor, '목표 수정하기 완료!', () async {
                // 모든 API 호출이 성공했는지 확인할 변수
                bool isSuccess = true;

                // 🔹 목표 이름 수정
                bool nameSuccess =
                    await _editName(_namecontroller.text, int.parse(widget.id));
                if (!nameSuccess) {
                  isSuccess = false;
                }

                // 🔹 목표 설명 수정
                bool descriptSuccess = await _editDescript(
                    _descriptcontroller.text, int.parse(widget.id));
                if (!descriptSuccess) {
                  isSuccess = false;
                }

                for (String imageUrl in goalImage) {
                  bool deleteSuccess =
                      await DeleteFileService.deleteFile(imageUrl);
                  if (!deleteSuccess) {
                    isSuccess = false;
                  }
                }

                // 🔹 2️⃣ 삭제가 모두 성공했을 경우에만 새로운 이미지 저장 진행
                if (isSuccess) {
                  List<String> finalImageList = [...goalImage, ..._imageFiles];

                  // 🔹 3️⃣ 최종적으로 서버에 업데이트 요청
                  bool photoSuccess =
                      await _editPhoto(finalImageList, int.parse(widget.id));

                  if (!photoSuccess) {
                    isSuccess = false;
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
                }

                // 🔹 모든 API 호출이 성공했을 경우만 화면 닫기
                if (isSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyGoal(),
                    ),
                  );
                  //Navigator.pop(context);
                }
              }).newButton(),
          ),


           
            
            
          ],
        ),
      ),
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
          width: currentWidth < 600 ? 30 : 40,
          height: currentWidth < 600 ? 30 : 40,
          decoration: BoxDecoration(
            color: colorCode,
            borderRadius: BorderRadius.circular(5),
          ),
          child: isSelected
              ? Icon(
                  Icons.check_circle_rounded,
                  color: backgroundColor,
                  size: currentWidth < 600 ? 20 : 22,
                )
              : null,
        ),
      ),
    );
  }
}
