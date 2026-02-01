import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/shared/log/logger.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    logger.i('스플래시 화면 시작');

    // 스플래시 화면 표시 시간 (2초)
    await Future.delayed(const Duration(seconds: 2));

    // 메인 화면으로 이동
    Get.offAllNamed(AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: 로고 이미지로 교체
            Icon(
              Icons.cake,
              size: 100,
              color: Colors.pinkAccent,
            ),
            const SizedBox(height: 20),
            Text(
              '기억해달',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '소중한 생일을 기억하세요',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}