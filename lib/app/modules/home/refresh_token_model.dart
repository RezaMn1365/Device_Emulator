class RefreshToken {
  String? accessToken;
  String? refreshToken;

  RefreshToken({this.accessToken, this.refreshToken});

  RefreshToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
