import 'package:flutter/material.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/oss_licenses.dart';

class OssLicensesPage extends StatelessWidget {
  const OssLicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('오픈소스 라이선스'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // 폰트 라이선스
          _buildFontLicenseSection(context),
          const Divider(height: 1),
          // 패키지 라이선스 목록
          ...allDependencies.map((package) => Column(
            children: [
              ListTile(
                title: Text(
                  package.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  package.version,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  color: AppColors.textTertiary,
                ),
                onTap: () => _showLicenseDetail(context, package),
              ),
              const Divider(height: 1),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildFontLicenseSection(BuildContext context) {
    return ListTile(
      title: const Text(
        'Maplestory Font',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: const Text(
        '넥슨 제공 무료 폰트',
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textTertiary,
      ),
      onTap: () => _showFontLicenseDetail(context),
    );
  }

  void _showFontLicenseDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const _FontLicenseDetailPage(),
      ),
    );
  }

  void _showLicenseDetail(BuildContext context, Package package) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _LicenseDetailPage(package: package),
      ),
    );
  }
}

class _FontLicenseDetailPage extends StatelessWidget {
  const _FontLicenseDetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Maplestory Font'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Maplestory Font',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '넥슨(NEXON) 제공',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'https://maplestory.nexon.com/Media/Font',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '''메이플스토리 서체는 넥슨㈜에서 제공하며, 개인 및 기업 사용자를 포함한 모든 사용자에게 무료로 제공됩니다.

사용 범위
• 인쇄, 광고, 온라인, 영상, 게임, 어플리케이션 등 다양한 매체에서 자유롭게 사용 가능합니다.
• 영리적, 비영리적 목적 모두 사용 가능합니다.

제한 사항
• 폰트 파일 자체를 유료로 판매하거나 재배포하는 것은 금지됩니다.
• 폰트를 임의로 수정하거나 변형하여 재배포하는 것은 금지됩니다.

본 앱에서는 메이플스토리체 Light와 Bold를 사용합니다.''',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LicenseDetailPage extends StatelessWidget {
  final Package package;

  const _LicenseDetailPage({required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(package.name),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 패키지 정보
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'v${package.version}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (package.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      package.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (package.homepage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      package.homepage!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 라이선스 내용
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                package.license ?? '라이선스 정보 없음',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
