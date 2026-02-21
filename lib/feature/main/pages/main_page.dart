import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rememberotter/app/app_routes.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/feature/birthday/controllers/birthday_controller.dart';
import 'package:rememberotter/feature/birthday/widgets/birthday_form_sheet.dart';
import 'package:rememberotter/feature/birthday/widgets/birthday_list_item.dart';
import 'package:rememberotter/feature/calendar/pages/calendar_page.dart';
import 'package:rememberotter/shared/widgets/otter_image.dart';
import 'package:rememberotter/shared/widgets/update_bottom_sheet.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CalendarPage(),
    const _FriendsPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateBottomSheet.showIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('기억해달'),
        centerTitle: true,
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            color: AppColors.textSecondary,
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      floatingActionButton: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        color: AppColors.primary,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            BirthdayFormSheet.show();
          },
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 50,
            height: 50,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.background,
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          onTap: (index) {
            HapticFeedback.selectionClick();
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: '캘린더',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cake_outlined),
              label: '생일',
            ),
          ],
        ),
      ),
    );
  }
}

// 친구 목록 탭 페이지
class _FriendsPage extends StatelessWidget {
  const _FriendsPage();

  @override
  Widget build(BuildContext context) {
    return GetX<BirthdayController>(
      builder: (controller) {
        if (!controller.isLoaded.value) {
          return const SizedBox.shrink();
        }

        final birthdays = controller.birthdays;

        if (birthdays.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const OtterImage(type: OtterType.empty, size: 120),
                const SizedBox(height: 24),
                const Text(
                  '아직 등록된 생일이 없어요',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '소중한 사람의 생일을 추가해보세요',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.contactImport),
                  icon: const Icon(Icons.contact_phone_outlined, size: 18),
                  label: const Text('연락처에서 가져오기'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: birthdays.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final birthday = birthdays[index];
            return BirthdayListItem(
              birthday: birthday,
              onTap: () => Get.toNamed(
                AppRoutes.birthdayDetail,
                arguments: birthday.id,
              ),
              onDelete: () => controller.deleteBirthday(birthday.id),
            );
          },
        );
      },
    );
  }
}
