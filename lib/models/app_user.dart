enum UserRole { student, professor, admin, clubLead }

class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
  });

  final String uid;
  final String email;
  final String displayName;
  final UserRole role;

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    final roleName = (data['role'] ?? 'student').toString();
    return AppUser(
      uid: uid,
      email: (data['email'] ?? '').toString(),
      displayName: (data['displayName'] ?? '').toString(),
      role: UserRole.values.firstWhere(
        (role) => role.name == roleName,
        orElse: () => UserRole.student,
      ),
    );
  }
}
