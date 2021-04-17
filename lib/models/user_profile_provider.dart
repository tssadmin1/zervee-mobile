class UserProfile {
  final String name;
  final String username;
  final List<String> roles;
  final String phoneNumber;
  final String email;
  final String location;
  final String title;

  UserProfile({
    this.name, 
    this.username, 
    this.roles, 
    this.phoneNumber='', 
    this.email, 
    this.location, 
    this.title,
  });

}