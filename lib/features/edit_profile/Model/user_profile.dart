class UserProfile {
  final String uid;
  final String name;
  final String username; // tanpa "@"
  final String bio;
  final String gender; // "Pria" / "Wanita"
  final String photoUrl;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.username,
    required this.bio,
    required this.gender,
    required this.photoUrl,
  });

  factory UserProfile.empty(String uid) => UserProfile(
    uid: uid,
    name: '',
    username: '',
    bio: '',
    gender: 'Pria',
    photoUrl: '',
  );

  factory UserProfile.fromMap(String uid, Map<String, dynamic> map) {
    return UserProfile(
      uid: uid,
      name: (map['name'] ?? '') as String,
      username: (map['username'] ?? '') as String,
      bio: (map['bio'] ?? '') as String,
      gender: (map['gender'] ?? 'Pria') as String,
      photoUrl: (map['photoUrl'] ?? '') as String,
    );
  }
}
