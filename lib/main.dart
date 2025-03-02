import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/TD/date_provider.dart';
import 'package:domino/provider/ST/password_provider.dart';
import 'package:domino/provider/LR/user_provider.dart';
import 'package:domino/provider/nav_provider.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:domino/screens/LR/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:domino/widgets/alarm.dart';

void main() async {
  // 앱 실행 전에 NotificationService 인스턴스 생성
  // final notificationService = NotificationService();
  // Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();
  // 로컬 푸시 알림 초기화
  // await notificationService.init();
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 엔진 초기화
  await initializeDateFormatting();
  await dotenv.load(fileName: 'assets/config/.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DateProvider()),
        //ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => DateListProvider()),
        ChangeNotifierProvider(create: (_) => PasswordProvider()),
        ChangeNotifierProvider(create: (_) => SelectFinalGoalModel()),
        ChangeNotifierProvider(create: (_) => SelectFinalGoalId()),
        ChangeNotifierProvider(create: (_) => SaveInputtedDetailGoalModel()),
        ChangeNotifierProvider(create: (_) => SaveInputtedActionPlanModel()),
        ChangeNotifierProvider(create: (_) => SelectDetailGoal()),
        ChangeNotifierProvider(create: (_) => GoalColor()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NavBarProvider()),
        ChangeNotifierProvider(create: (_) => SelectAPModel()),
        ChangeNotifierProvider(create: (_) => SaveEditedDetailGoalIdModel()),
        ChangeNotifierProvider(create: (_) => SaveEditedActionPlanIdModel()),
        ChangeNotifierProvider(create: (_) => SaveMandalartCreatedGoal()),
        ChangeNotifierProvider(create: (_) => TestInputtedDetailGoalModel()),
        ChangeNotifierProvider(create: (_) => TestInputtedActionPlanModel()),
        ChangeNotifierProvider(create: (_) => GoalOrder()),
      ],
      child: const MyApp(), // MyApp 클래스를 사용
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'domino',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), 
      theme: ThemeData(
        fontFamily: 'Pretendard',
        useMaterial3: true,
        textTheme: TextTheme(
          // all > appBar의 메뉴 텍스트 
          titleLarge: TextStyle(
            fontSize: MediaQuery.of(context).size.width*0.045,
            fontWeight: FontWeight.w600,
            color:Colors.white),
           // all > 메뉴 설명
          titleMedium: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color:Colors.white
          ),
          // TD > 투두 컨테이너 > 두 번째 목표
           bodySmall: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color:Color(0xffA1A1A1)
          ),
          // TD > 투두 컨테이너 > 세 번째 목표
           bodyMedium: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color:Colors.white
          ),
          // MG > 질문 텍스트 
          titleSmall: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w600,
            color:Colors.white
          ),
        ),

        // all > 인풋박스 스타일
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 148, 148, 148),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7)
          )
        ),

        scaffoldBackgroundColor: const Color(0xff262626)
      
      )
      ,
    );
  }
}
