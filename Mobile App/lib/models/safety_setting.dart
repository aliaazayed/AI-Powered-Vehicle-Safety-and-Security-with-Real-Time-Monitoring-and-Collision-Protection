class SafetySettings {
  final String userId;
  final bool authorizedAccess;
  final bool childDetection;
  final bool petDetection;
  final DateTime? lastUpdated;

  SafetySettings({
    required this.userId,
    required this.authorizedAccess,
    required this.childDetection,
    required this.petDetection,
    this.lastUpdated,
  });

  // Create from API response
  factory SafetySettings.fromJson(Map<String, dynamic> json) {
    return SafetySettings(
      userId: json['userId'] ?? '',
      authorizedAccess: json['unauthorizedAccess'] ?? false,
      childDetection: json['childDetectionAlert'] ?? false,
      petDetection: json['petDetectionAlert'] ?? false,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'unauthorizedAccess': authorizedAccess,
      'childDetectionAlert': childDetection,
      'petDetectionAlert': petDetection,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  // Convert to Map for local storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'authorizedAccess': authorizedAccess,
      'childDetection': childDetection,
      'petDetection': petDetection,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  // Create from local storage
  factory SafetySettings.fromMap(Map<String, dynamic> map) {
    return SafetySettings(
      userId: map['userId'] ?? '',
      authorizedAccess: map['authorizedAccess'] ?? false,
      childDetection: map['childDetection'] ?? false,
      petDetection: map['petDetection'] ?? false,
      lastUpdated: map['lastUpdated'] != null
          ? DateTime.parse(map['lastUpdated'])
          : null,
    );
  }

  // Create default settings for new users (all disabled)
  factory SafetySettings.defaultSettings(String userId) {
    return SafetySettings(
      userId: userId,
      authorizedAccess: false,
      childDetection: false,
      petDetection: false,
      lastUpdated: DateTime.now(),
    );
  }

  // Copy with modifications
  SafetySettings copyWith({
    String? userId,
    bool? authorizedAccess,
    bool? childDetection,
    bool? petDetection,
    DateTime? lastUpdated,
  }) {
    return SafetySettings(
      userId: userId ?? this.userId,
      authorizedAccess: authorizedAccess ?? this.authorizedAccess,
      childDetection: childDetection ?? this.childDetection,
      petDetection: petDetection ?? this.petDetection,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'SafetySettings(userId: $userId, authorizedAccess: $authorizedAccess, childDetection: $childDetection, petDetection: $petDetection, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SafetySettings &&
        other.userId == userId &&
        other.authorizedAccess == authorizedAccess &&
        other.childDetection == childDetection &&
        other.petDetection == petDetection;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        authorizedAccess.hashCode ^
        childDetection.hashCode ^
        petDetection.hashCode;
  }
}
