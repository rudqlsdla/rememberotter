import 'package:flutter/material.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';

/// 해달 캐릭터 이미지 위젯
/// 이미지 파일이 없으면 placeholder 아이콘을 표시합니다.
class OtterImage extends StatelessWidget {
  final OtterType type;
  final double size;

  const OtterImage({
    super.key,
    required this.type,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    final assetPath = 'assets/images/otter/${type.fileName}';

    return Image.asset(
      assetPath,
      width: size,
      height: size,
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.op(AppColors.primary, 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        type.placeholderIcon,
        size: size * 0.5,
        color: AppColors.primary,
      ),
    );
  }
}

enum OtterType {
  splash('img_otter_splash.png', Icons.pets),
  empty('img_otter_empty.png', Icons.cake_outlined),
  celebrate('img_otter_celebrate.png', Icons.celebration),
  gift('img_otter_gift.png', Icons.card_giftcard),
  error('img_otter_error.png', Icons.error_outline),
  wave('img_otter_wave.png', Icons.waving_hand);

  final String fileName;
  final IconData placeholderIcon;

  const OtterType(this.fileName, this.placeholderIcon);
}
