import 'package:domino/screens/MG/mygoal_profile_edit.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class ProfileSampleGallery extends StatefulWidget {
  final String selectedImage;
  const ProfileSampleGallery({super.key, required this.selectedImage});

  @override
  ProfileSampleGalleryState createState() => ProfileSampleGalleryState();
}

class ProfileSampleGalleryState extends State<ProfileSampleGallery> {
  final List<String> _imageUrls = [
    'assets/img/profile_smp1.png',
    'assets/img/profile_smp2.png',
    'assets/img/profile_smp3.png',
    'assets/img/profile_smp4.png',
    'assets/img/profile_smp5.png',
    'assets/img/profile_smp6.png',
    'assets/img/profile_smp7.png',
    'assets/img/profile_smp8.png',
    'assets/img/profile_smp9.png',
  ];

  late String _selectedImage;

  @override
  void initState() {
    super.initState();
    _selectedImage = widget.selectedImage;
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 3.5;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        scrolledUnderElevation: 0,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Color(0xffD4D4D4),
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '프로필 이미지',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
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
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(_selectedImage), // 선택된 이미지를 표시
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xff2A2A2A),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '도민호씨 갤러리',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.3,
                ),
                const SizedBox(height: 10),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 20.0,
                              crossAxisSpacing: 20.0,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            itemCount: _imageUrls.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImage = _imageUrls[index];
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(_imageUrls[index]),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    
                    
                  ],
                ),
              ),
              
            ),
            const SizedBox(height: 10),
            Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Button(Colors.black, Colors.white, '완료', 
                        () {
                            print(_selectedImage);
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileEdit(
                                        selectedImage: _selectedImage,
                                       ),
                                     ),
                                   );
                          }).button()
                        
                      ],
                    ),
          ],
        ),
      ),
    );
  }
}
