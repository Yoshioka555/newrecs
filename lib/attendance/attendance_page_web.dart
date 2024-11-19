import 'package:flutter/material.dart';
import 'package:labmaidfastapi/attendance/attendance_home_page_web.dart';
import 'package:labmaidfastapi/attendance/attendance_management_page_web.dart';
import 'package:labmaidfastapi/door_status/door_status_appbar.dart';
import 'package:labmaidfastapi/gemini/gemini_chat_page.dart';
import '../header_footer_drawer/drawer.dart';
import 'attendance_create_page.dart';

//変更点
//新規作成
//WEB用の出席管理ページ

class AttendancePageWeb extends StatelessWidget {
  const AttendancePageWeb({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Attendance Management'),
            SizedBox(height: 70, width: 170, child: DoorStatusAppbar()),
          ],
        ),
        //Gemini AI Page への遷移
        //仮でここに置いています
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.psychology_alt),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GeminiChatPage()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: const UserDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[200],
        onPressed: () async {
          //画面遷移
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateAttendancePage(),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Row(

        children: [
          //Web用の予定追加ページ
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: const AttendanceHomePageWeb(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 1.0,
            child: const Column(
              children: [
                Expanded(child: AttendanceManagementPageWeb()),
              ],
            )
          ),
        ],
      ),
    );
  }
}