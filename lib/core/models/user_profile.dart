class UserProfile {
  final int id;
  final String createdAt;
  final String name;
  final String username;
  final String profilePicture;
  final String description;

  UserProfile({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.username,
    required this.profilePicture,
    required this.description,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      createdAt: json['created_at']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      profilePicture: json['profile_picture']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'name': name,
      'username': username,
      'profile_picture': profilePicture,
      'description': description,
    };
  }
}