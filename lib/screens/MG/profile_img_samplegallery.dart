import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class ProfileSampleGallery extends StatefulWidget {
  const ProfileSampleGallery(
      {super.key});

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

  late String _selectedImage = 'assets/img/profile_smp4.png';
  
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
                  Navigator.of(context).pop();
                },
              ).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('기본 이미지').pageTitle(),
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
            SizedBox(height: 20),
            Center(
              child: Container(
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
                  width: 150,
                  height: 150,
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
                  ),
                  child: Image.asset(_selectedImage),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 30.0,
                        crossAxisSpacing: 30.0,
                      ),
                      padding: const EdgeInsets.all(3.0),
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
                                image: AssetImage(_imageUrls[index])
                                        as ImageProvider
                                  
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Spacer(),
            LoginButton('선택하기', 
                () {
                  print(_selectedImage);
                  Navigator.pop(context, _selectedImage);

                }).loginButton()
                
            
          ],
        ),
      ),
    );
  }
}
