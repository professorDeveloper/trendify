class ProfileUser {
  final String name;
  final String email;
  final String imageUrl;

  const ProfileUser({
    required this.name,
    required this.email,
    required this.imageUrl,
  });
}

class ProfileUserData {
  static const ProfileUser currentUser = ProfileUser(
    name: 'Andrew Ainsley',
    email: 'andrew.ainsley@yourdomain.com',
    imageUrl: 'assets/images/avatar.png',
  );
}