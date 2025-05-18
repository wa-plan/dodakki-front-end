import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String content;
  final String title;
  final bool cancel;
  final bool delete;
  final bool signout;
  final bool success;
  final VoidCallback? onCancel;
  final VoidCallback? onDelete;
  final VoidCallback? onSignOut;
  final VoidCallback? onSuccess;

  const PopupDialog({
    super.key,
    required this.content,
    required this.cancel,
    required this.delete,
    required this.signout,
    required this.success,
    required this.title,
    this.onCancel,
    this.onDelete,
    this.onSignOut,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    // Determine which button to display based on the flags
    List<Widget> buttons = [];
    if (delete) {
      buttons.add(
        SizedBox(
          width: 110,
          child: NewButton(
                  const Color.fromARGB(255, 128, 22, 15),
                  Colors.white,
                  '삭제',
                  () => onDelete != null
                      ? onDelete!()
                      : Navigator.of(context).pop(),
                  currentWidth)
              .newButton(),
        ),
      );
    }
    if (signout) {
      buttons.add(
        SizedBox(
          width: 110,
          child: NewButton(
                  mainRed,
                  backgroundColor,
                  '탈퇴하기',
                  () => onSignOut != null
                      ? onSignOut!()
                      : Navigator.of(context).pop(),
                  currentWidth)
              .newButton(),
        ),
      );
    }
    if (success) {
      buttons.add(
        SizedBox(
          width: 110,
          child: NewButton(
                  mainRed,
                  backgroundColor,
                  '확인',
                  () => onSuccess != null
                      ? onSuccess!()
                      : Navigator.of(context).pop(),
                  currentWidth)
              .newButton(),
        ),
      );
    }

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
      elevation: 30.0,
      content: Container(
        padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 26, 26, 26),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        height: 200,
        width: 300,
        child: Stack(
          children: [
            //이미지
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                  'assets/img/popup.png',
                  height: 170,
                ),
              
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //타이틀
                  Text(
                    title,
                    style: TextStyle(
                        color: mainRed,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.7),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  //본문
                  Text(
                    content,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: currentWidth < 600 ? 16 : 20,
                        fontWeight: FontWeight.w600,
                        height: 1.7),
                  ),

                  Spacer(),
                  //버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (cancel)
                        SizedBox(
                          width: 110,
                          child: NewButton(
                                  mainGrey,
                                  Colors.white,
                                  '취소',
                                  () => Navigator.of(context).pop(),
                                  currentWidth)
                              .newButton(),
                        ),
                      ...buttons,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context,
    String content,
    String title,
    bool cancel,
    bool delete,
    bool signout,
    bool success, {
    VoidCallback? onCancel,
    VoidCallback? onDelete,
    VoidCallback? onSignOut,
    VoidCallback? onSuccess,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PopupDialog(
          content: content,
          title: title,
          cancel: cancel,
          delete: delete,
          signout: signout,
          success: success,
          onCancel: onCancel,
          onDelete: onDelete,
          onSignOut: onSignOut,
          onSuccess: onSuccess,
        );
      },
    );
  }
}
