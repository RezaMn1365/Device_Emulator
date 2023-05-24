class Authenticate {
  String? username;
  String? password;
  String? accessToken;
  String? refreshToken;
  String? expirty;

  Authenticate(
      {this.username,
      this.password,
      this.accessToken,
      this.refreshToken,
      this.expirty});

  Authenticate.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    expirty = json['expirty'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    data['expirty'] = expirty;
    return data;
  }
}
