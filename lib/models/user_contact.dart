
class UserContact {
  final String id;
  final String? bio;
  final String phone;
  final String email;
  final String username;
  final String? photoUrl;
  final String contactName;
  final String countryPhoneCode;
  final List<dynamic>? blockedUsers;
  UserContact({
    required this.contactName,
    this.bio,
    this.photoUrl,
    required this.id,
    this.blockedUsers,
    required this.email,
    required this.phone,
    required this.username,
    required this.countryPhoneCode,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) {
    return UserContact(
      id: json['id'],
      bio: json['bio'],
      email: json['email'],
      phone: json['phone'],
      photoUrl: json['photoUrl'],
      username: json['username'],
      contactName: json['contactName'],
      blockedUsers: json['blockedUsers'],
      countryPhoneCode: json['countryPhoneCode'],
    );
  }
}
