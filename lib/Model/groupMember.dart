class GroupMember {
  final String? id;
  final String? groupId;
  final String? userId;
  final String? isAdmin;
  final String? createdOn;
  final String? username;
  final String? image;

  GroupMember({
    this.id,
    this.groupId,
    this.userId,
    this.isAdmin,
    this.createdOn,
    this.username,
    this.image,
  });

  GroupMember copyWith({
    String? id,
    String? groupId,
    String? userId,
    String? isAdmin,
    String? createdOn,
    String? username,
    String? image,
  }) {
    return GroupMember(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      isAdmin: isAdmin ?? this.isAdmin,
      createdOn: createdOn ?? this.createdOn,
      username: username ?? this.username,
      image: image ?? this.image,
    );
  }

  GroupMember.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        groupId = json['group_id'] as String?,
        userId = json['user_id'] as String?,
        isAdmin = json['is_admin'] as String?,
        createdOn = json['created_on'] as String?,
        username = json['username'] as String?,
        image = json['image'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': groupId,
        'user_id': userId,
        'is_admin': isAdmin,
        'created_on': createdOn,
        'username': username,
        'image': image
      };
}
