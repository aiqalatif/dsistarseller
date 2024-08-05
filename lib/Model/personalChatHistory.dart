class PersonalChatHistory {
  final String? id;
  final String? fromId;
  final String? toId;
  final String? isRead;
  final String? message;
  final String? type;
  final String? media;
  final String? dateCreated;
  final String? opponentUsername;
  final String? email;
  final String? mobile;
  final String? image;
  final String? lastOnline;
  final String? webFcm;
  final String? createdAt;
  final String? unreadMsg;
  final int? isOnline;
  final String? opponentUserId;

  PersonalChatHistory({
    this.id,
    this.fromId,
    this.toId,
    this.isRead,
    this.message,
    this.type,
    this.media,
    this.dateCreated,
    this.opponentUsername,
    this.opponentUserId,
    this.email,
    this.mobile,
    this.image,
    this.lastOnline,
    this.webFcm,
    this.createdAt,
    this.unreadMsg,
    this.isOnline,
  });

  PersonalChatHistory copyWith({
    String? id,
    String? fromId,
    String? toId,
    String? isRead,
    String? message,
    String? type,
    String? media,
    String? dateCreated,
    String? opponentUsername,
    String? email,
    String? mobile,
    String? image,
    String? lastOnline,
    String? webFcm,
    String? createdAt,
    String? unreadMsg,
    int? isOnline,
    String? opponentUserId,
  }) {
    return PersonalChatHistory(
      id: id ?? this.id,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      isRead: isRead ?? this.isRead,
      message: message ?? this.message,
      type: type ?? this.type,
      media: media ?? this.media,
      dateCreated: dateCreated ?? this.dateCreated,
      opponentUsername: opponentUsername ?? this.opponentUsername,
      opponentUserId: opponentUserId ?? this.opponentUserId,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      image: image ?? this.image,
      lastOnline: lastOnline ?? this.lastOnline,
      webFcm: webFcm ?? this.webFcm,
      createdAt: createdAt ?? this.createdAt,
      unreadMsg: unreadMsg ?? this.unreadMsg,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  String getOtherUserId() {
    return opponentUserId ?? "";
  }

  PersonalChatHistory.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        fromId = json['from_id'] as String?,
        toId = json['to_id'] as String?,
        isRead = json['is_read'] as String?,
        message = json['message'] as String?,
        type = json['type'] as String?,
        media = json['media'] as String?,
        dateCreated = json['date_created'] as String?,
        opponentUsername = json['opponent_username'] as String?,
        opponentUserId = json['opponent_user_id'] as String?,
        email = json['email'] as String?,
        mobile = json['mobile'] as String?,
        image = json['image'] as String?,
        lastOnline = json['last_online'] as String?,
        webFcm = json['web_fcm'] as String?,
        createdAt = json['created_at'] as String?,
        unreadMsg = json['unread_msg'] as String?,
        isOnline = json['is_online'] as int?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'from_id': fromId,
        'to_id': toId,
        'is_read': isRead,
        'message': message,
        'type': type,
        'media': media,
        'date_created': dateCreated,
        'opponent_username': opponentUsername,
        "opponent_user_id": opponentUserId,
        'email': email,
        'mobile': mobile,
        'image': image,
        'last_online': lastOnline,
        'web_fcm': webFcm,
        'created_at': createdAt,
        'unread_msg': unreadMsg,
        'is_online': isOnline
      };
}
