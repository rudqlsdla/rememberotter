class BackupMetadata {
  final String appVersion;
  final int schemaVersion;
  final String createdAt;
  final String deviceInfo;
  final int birthdayCount;
  final int giftCount;
  final int groupCount;

  BackupMetadata({
    required this.appVersion,
    required this.schemaVersion,
    required this.createdAt,
    required this.deviceInfo,
    required this.birthdayCount,
    required this.giftCount,
    required this.groupCount,
  });

  factory BackupMetadata.fromJson(Map<String, dynamic> json) {
    return BackupMetadata(
      appVersion: json['appVersion'] as String? ?? '',
      schemaVersion: json['schemaVersion'] as int? ?? 1,
      createdAt: json['createdAt'] as String? ?? '',
      deviceInfo: json['deviceInfo'] as String? ?? '',
      birthdayCount: json['birthdayCount'] as int? ?? 0,
      giftCount: json['giftCount'] as int? ?? 0,
      groupCount: json['groupCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appVersion': appVersion,
      'schemaVersion': schemaVersion,
      'createdAt': createdAt,
      'deviceInfo': deviceInfo,
      'birthdayCount': birthdayCount,
      'giftCount': giftCount,
      'groupCount': groupCount,
    };
  }
}

class BackupData {
  final BackupMetadata metadata;
  final List<Map<String, dynamic>> groups;
  final List<Map<String, dynamic>> birthdays;
  final List<Map<String, dynamic>> gifts;

  BackupData({
    required this.metadata,
    required this.groups,
    required this.birthdays,
    required this.gifts,
  });

  factory BackupData.fromJson(Map<String, dynamic> json) {
    return BackupData(
      metadata: BackupMetadata.fromJson(
        json['metadata'] as Map<String, dynamic>? ?? {},
      ),
      groups: (json['groups'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      birthdays: (json['birthdays'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
      gifts: (json['gifts'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata.toJson(),
      'groups': groups,
      'birthdays': birthdays,
      'gifts': gifts,
    };
  }
}

class BackupValidationResult {
  final bool isValid;
  final String? errorMessage;
  final BackupMetadata? metadata;

  BackupValidationResult({
    required this.isValid,
    this.errorMessage,
    this.metadata,
  });
}

enum RestoreMode {
  overwrite,
  merge,
}
