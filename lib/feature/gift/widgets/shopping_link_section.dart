import 'package:flutter/material.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/shared/services/shopping_link_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ShoppingLinkSection extends StatelessWidget {
  const ShoppingLinkSection({super.key});

  static const _kakaoColor = Color(0xFFFEE500);
  static const _naverColor = Color(0xFF03C75A);
  static const _coupangColor = Color(0xFFE52528);

  @override
  Widget build(BuildContext context) {
    final config = ShoppingLinkService();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _ShoppingChip(
              label: '카카오',
              icon: Icons.shopping_bag_outlined,
              brandColor: _kakaoColor,
              darkBrandColor: const Color(0xFF3C1E1E),
              onTap: () => _openShoppingUrl(config.kakaoShoppingUrl, config.defaultShoppingQuery),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ShoppingChip(
              label: '네이버',
              icon: Icons.shopping_cart_outlined,
              brandColor: _naverColor,
              onTap: () => _openShoppingUrl(config.naverShoppingUrl, config.defaultShoppingQuery),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _ShoppingChip(
              label: '쿠팡',
              icon: Icons.local_mall_outlined,
              brandColor: _coupangColor,
              onTap: () => _openUrl(config.coupangShoppingUrl),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openShoppingUrl(String baseUrl, String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('$baseUrl$encodedQuery');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class _ShoppingChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color brandColor;
  final Color? darkBrandColor;
  final VoidCallback onTap;

  const _ShoppingChip({
    required this.label,
    required this.icon,
    required this.brandColor,
    this.darkBrandColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = darkBrandColor ?? brandColor;
    return Material(
      color: AppColors.op(brandColor, 0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: textColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
