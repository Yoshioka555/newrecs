import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/login_page.dart';
import 'reset_password_model.dart';

//エラーを表示
String? error;

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ResetPasswordModel>(
      create: (_) => ResetPasswordModel(),
      child: Theme(
        data: ThemeData(
          useMaterial3: true, // Material 3 を有効化
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
        ),
        child: Scaffold(
          appBar: AppBar(title: Text('パスワードリセット'),),
          body: Consumer<ResetPasswordModel>(builder: (context, model, child) {
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 5,
                      blurRadius: 30,
                      offset: Offset(1, 1),
                    ),
                  ],
                  color: Colors.white,
                ),
                height: 600,
                width: 400,
                child: Stack(
                  children: [
                    Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            children: [
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 700),
                                child: SizedBox(
                                  //横長がウィンドウサイズの８割になる設定
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: TextField(
                                    controller: model.emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Your Email',
                                      icon: Icon(Icons.mail),
                                    ),
                                    onChanged: (text) {
                                      model.setEmail(text);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 250),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(200, double.infinity),
                                      backgroundColor: Colors.black, //ボタンの背景色
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)),
                                    ),
                                    onPressed: () async {
                                      model.startLoading();
                                      try {
                                        await model.sendPasswordResetEmail();
                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.blue,
                                          content:
                                              Text('${model.email}にメールを送信しました'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        //現在の画面をナビゲーションスタックから取り除き、新しい画面をプッシュできる
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        //ユーザーログインに失敗した場合
                                        if (e.code == 'user-not-found') {
                                          error = 'ユーザーは存在しません';
                                        } else if (e.code == 'invalid-email') {
                                          error = 'メールアドレスの形をしていません';
                                        } else {
                                          error = 'メールを送信できません';
                                        }

                                        final snackBar = SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(error.toString()),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } finally {
                                        model.endLoading();
                                      }
                                    },
                                    child: const Text(
                                      '送信',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (model.isLoading)
                      Container(
                        color: Colors.black45,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
