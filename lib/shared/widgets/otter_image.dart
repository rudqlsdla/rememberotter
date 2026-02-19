import 'package:flutter/material.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/gen/assets.gen.dart';

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
    final asset = type.asset;
    if (asset == null) return _buildPlaceholder();

    return asset.image(
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
  splash(Icons.pets),
  empty(Icons.cake_outlined),
  celebrate(Icons.celebration),
  gift(Icons.card_giftcard),
  error(Icons.error_outline),
  wave(Icons.waving_hand);

  final IconData placeholderIcon;

  const OtterType(this.placeholderIcon);

  /// otter 전용 이미지가 아직 없으므로 common 에셋에서 매핑
  AssetGenImage? get asset {
    switch (this) {
      case OtterType.splash:
        return Assets.images.splash.splashOtter;
      default:
        return null;
    }
  }
}
