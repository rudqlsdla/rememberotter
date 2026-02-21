import 'package:flutter/material.dart';
import 'package:rememberotter/domain/models/gift.dart';
import 'package:rememberotter/design_system/variable/app_colors.dart';
import 'package:rememberotter/shared/utils/price_formatter.dart';

class GiftListItem extends StatelessWidget {
  final Gift gift;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const GiftListItem({
    super.key,
    required this.gift,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(gift.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildStatusIcon(),
        title: Text(
          '${gift.year}년',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (gift.given && _hasGivenInfo)
              Text(
                '준 선물: ${_formatGiftInfo(gift.givenGiftName, gift.givenGiftPrice)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            if (gift.received && _hasReceivedInfo)
              Text(
                '받은 선물: ${_formatGiftInfo(gift.receivedGiftName, gift.receivedGiftPrice)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            if (gift.memo != null && gift.memo!.isNotEmpty)
              Text(
                gift.memo!,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: _buildExchangeStatusBadge(),
      ),
    );
  }

  bool get _hasGivenInfo =>
      (gift.givenGiftName != null && gift.givenGiftName!.isNotEmpty) ||
      (gift.givenGiftPrice != null && gift.givenGiftPrice! > 0);

  bool get _hasReceivedInfo =>
      (gift.receivedGiftName != null && gift.receivedGiftName!.isNotEmpty) ||
      (gift.receivedGiftPrice != null && gift.receivedGiftPrice! > 0);

  String _formatGiftInfo(String? name, int? price) {
    final hasName = name != null && name.isNotEmpty;
    final hasPrice = price != null && price > 0;

    if (hasName && hasPrice) {
      return '$name (${PriceFormatter.formatWithUnit(price)})';
    } else if (hasName) {
      return name;
    } else if (hasPrice) {
      return PriceFormatter.formatWithUnit(price);
    }
    return '';
  }

  Widget _buildStatusIcon() {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    if (gift.given && gift.received) {
      iconData = Icons.swap_horiz;
      backgroundColor = AppColors.success.withValues(alpha: 0.1);
      iconColor = AppColors.success;
    } else if (gift.given) {
      iconData = Icons.card_giftcard;
      backgroundColor = AppColors.primary.withValues(alpha: 0.1);
      iconColor = AppColors.primary;
    } else if (gift.received) {
      iconData = Icons.redeem;
      backgroundColor = AppColors.accent.withValues(alpha: 0.1);
      iconColor = AppColors.accent;
    } else {
      iconData = Icons.help_outline;
      backgroundColor = AppColors.surfaceVariant;
      iconColor = AppColors.textTertiary;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: backgroundColor,
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }

  Widget _buildExchangeStatusBadge() {
    Color backgroundColor;
    Color textColor;

    if (gift.given && gift.received) {
      backgroundColor = AppColors.success.withValues(alpha: 0.1);
      textColor = AppColors.success;
    } else if (gift.given) {
      backgroundColor = AppColors.primary.withValues(alpha: 0.1);
      textColor = AppColors.primary;
    } else if (gift.received) {
      backgroundColor = AppColors.accent.withValues(alpha: 0.1);
      textColor = AppColors.accent;
    } else {
      backgroundColor = AppColors.surfaceVariant;
      textColor = AppColors.textTertiary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        gift.exchangeStatus,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
