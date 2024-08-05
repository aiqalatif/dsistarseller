import 'package:sellermultivendor/Model/groupMEmber.dart';

class GroupDetails {
  final String? id;
  final String? groupId;
  final String? userId;
  final String? isRead;
  final String? isAdmin;
  final String? createdOn;
  final String? title;
  final String? description;
  final String? createdBy;
  final String? noOfMembers;
  final List<GroupMember>? groupMembers;

  GroupDetails({
    this.id,
    this.groupId,
    this.userId,
    this.isRead,
    this.isAdmin,
    this.createdOn,
    this.title,
    this.description,
    this.createdBy,
    this.noOfMembers,
    this.groupMembers,
  });

  GroupDetails copyWith(
      {String? id,
      String? groupId,
      String? userId,
      String? isRead,
      String? isAdmin,
      String? createdOn,
      String? title,
      String? description,
      String? createdBy,
      String? noOfMembers,
      List<GroupMember>? groupMembers}) {
    return GroupDetails(
        id: id ?? this.id,
        groupId: groupId ?? this.groupId,
        userId: userId ?? this.userId,
        isRead: isRead ?? this.isRead,
        isAdmin: isAdmin ?? this.isAdmin,
        createdOn: createdOn ?? this.createdOn,
        title: title ?? this.title,
        description: description ?? this.description,
        createdBy: createdBy ?? this.createdBy,
        noOfMembers: noOfMembers ?? this.noOfMembers,
        groupMembers: groupMembers ?? this.groupMembers);
  }

  GroupDetails.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        groupId = json['group_id'] as String?,
        userId = json['user_id'] as String?,
        isRead = json['is_read'] as String?,
        isAdmin = json['is_admin'] as String?,
        createdOn = json['created_on'] as String?,
        title = json['title'] as String?,
        description = json['description'] as String?,
        createdBy = json['created_by'] as String?,
        groupMembers = ((json['group_members'] ?? []) as List)
            .map((groupMember) =>
                GroupMember.fromJson(Map.from(groupMember ?? {})))
            .toList(),
        noOfMembers = json['no_of_members'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'group_id': groupId,
        'user_id': userId,
        'is_read': isRead,
        'is_admin': isAdmin,
        'created_on': createdOn,
        'title': title,
        'description': description,
        'created_by': createdBy,
        'no_of_members': noOfMembers,
        'group_members': groupMembers?.map((e) => e.toJson()).toList(),
      };
}
