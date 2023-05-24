class BasicApiResponse {
  final bool success;
  final String? errorMessage;
  final List<dynamic> missingParams;
  final dynamic data;

  BasicApiResponse.success(this.data)
      : success = true,
        errorMessage = null,
        missingParams = const [];
  BasicApiResponse.failed(this.errorMessage)
      : success = false,
        data = null,
        missingParams = const [];

  BasicApiResponse.missingParams(dynamic json)
      : success = false,
        errorMessage = json['message'],
        data = null,
        missingParams = json['data'] ?? const [];

  BasicApiResponse.fromJson(Map<String, dynamic> json)
      : success = json['success'],
        errorMessage = json['message'],
        data = json['data'],
        missingParams = const [];

  List<String> getMissingParams() {
    if (missingParams.isEmpty) return const [];

    List<String> missings = List.empty(growable: true);

    for (var element in missingParams) {
      try {
        Map<String, dynamic> map = element;

        for (var key in map.keys) {
          missings.add(map[key]);
        }
      } catch (e) {}
    }

    return missings;
  }
}
