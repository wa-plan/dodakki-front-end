import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  final String content;
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
        NewButton(
          const Color.fromARGB(255, 128, 22, 15),
          Colors.white,
          '삭제',
          () => onDelete != null ? onDelete!() : Navigator.of(context).pop(),currentWidth
        ).newButton(),
      );
    }
    if (signout) {
      buttons.add(
        NewButton(
          const Color.fromARGB(255, 128, 22, 15),
          Colors.white,
          '탈퇴',
          () => onSignOut != null ? onSignOut!() : Navigator.of(context).pop(),currentWidth
        ).newButton(),
      );
    }
    if (success) {
      buttons.add(
        NewButton(
          Colors.black,
          Colors.white,
          '확인',
          () => onSuccess != null ? onSuccess!() : Navigator.of(context).pop(), currentWidth
        ).newButton(),
      );
    }

    

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
      elevation: 30.0,
      content: Container(
        padding: const EdgeInsets.fromLTRB(10, 30, 30, 0),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 26, 26, 26),
            borderRadius: BorderRadius.all(Radius.circular(7))),
        height: currentWidth < 600 ? 160 : 220,
        width: currentWidth < 600 ? 340 : 400,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset('assets/img/Dominho2.png',
                width: currentWidth < 600 ? 95 : 130),
            SizedBox(width: currentWidth < 600 ? 30 : 50),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: currentWidth < 600 ? 15 : 20,
                        fontWeight: FontWeight.w600,
                        height: 1.7),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (cancel)
                        NewButton(Colors.black, Colors.white, '취소',
                            () => Navigator.of(context).pop(), currentWidth).newButton(),
                      ...buttons,
                    ],
                  ),
                   SizedBox(
                    height: currentWidth < 600 ? 15 : 20,
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
