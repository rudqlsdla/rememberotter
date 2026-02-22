import 'dart:ui';

class Group {
  final String id;
  final String name;
  final int colorValue;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Group({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  Color get color => Color(colorValue);

  Group copyWith({
    String? id,
    String? name,
    int? colorValue,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
