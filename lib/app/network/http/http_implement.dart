import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:emulator/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/storage/storage.dart';
import '../../modules/home/device_model.dart';
import 'basic_api_response.dart';
import 'http.dart';
import 'package:emulator/app/modules/home/refresh_token_model.dart';

class HttpImplement implements HTTP {
  int latestexpirtyMillis = 0;
  @override
  Future<bool> signInRequest(String url, Device deviceData) async {
    var response = await _post(url, deviceData.toJson());

    if (response.success && response.data != null) {
      String accessToken = response.data['access_token'];
      String refreshToken = response.data['refresh_token'];
      int expirtyMillis = response.data['exp'];
      expirtyMillis =
          DateTime.now().millisecondsSinceEpoch + (expirtyMillis * 1000);
      await _storeTokens(accessToken, refreshToken, expirtyMillis);
    }

    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> requestTicket(String url) async {
    var response = await _get(url, authorized: true, firstTry: true);

    if (response.success && response.data != null) {
      String ticket = response.data['ticket'];
      String brokerIp = response.data['broker_ip'];
      String brokerPort = response.data['broker_port'];
      await _storeTicket(ticket, brokerIp, brokerPort);
    }

    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<BasicApiResponse> logout() async {
    var _response = await _get(
        'http://192.168.1.172:8081/authentication/logout',
        authorized: true,
        firstTry: true);

    return _response;
  }

  //post//post//post//post//post//post//post//post//post//post//post//post
  Future<BasicApiResponse> _post(String url, dynamic data,
      {bool firstTry = true, bool authorized = false}) async {
    var _dio = Dio();

    _dio.options.contentType = 'application/json; charset=UTF-8';

    if (authorized) {
      var token = await _getAccessToken();
      if (token != null) {
        _dio.options.headers["Authorization"] = 'Bearer ' + token;
      }
    }

    _dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );

    try {
      var response = await _dio.post(
        url,
        data: data,
      );

      print(
          'Response: ${response.statusCode}, ${response.statusMessage}: ${response.data}');

      return BasicApiResponse.fromJson(response.data);
    } on DioError catch (e) {
      return _handleExceptions(e, url, data, true, authorized, firstTry);
    } catch (e) {
      Get.defaultDialog(
          content: const Text(
              'Http post Error: Failed to get response from server.'));
      return BasicApiResponse.failed('Failed to get response from server.');
    }
  }

  //_get//_get//_get//_get//_get//_get//_get//_get//_get//_get//_get//_get
  Future<BasicApiResponse> _get(String url,
      {bool firstTry = true, bool authorized = false}) async {
    var _dio = Dio();

    _dio.options.contentType = 'application/json; charset=UTF-8';

    if (authorized) {
      var token = await _getAccessToken();
      print(token);
      if (token != null) {
        _dio.options.headers["Authorization"] = 'Bearer ' + token;
      }
    }

    _dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );

    try {
      var response = await _dio.get(
        url,
      );

      return BasicApiResponse.fromJson((response.data));
    } on DioError catch (e) {
      return _handleExceptions(e, url, null, false, authorized, firstTry);
    } catch (e) {
      Get.defaultDialog(
          content: Text('Http Get Error: Failed to get response from server.'));
      return BasicApiResponse.failed('Failed to get response from server.');
    }
  }

  Future<String?> _getAccessToken() async {
    final tokens = await Storage().getTokens();
    String? accessToken = tokens['accessToken'];
    return accessToken;
  }

  Future<String?> _getRefreshToken() async {
    final tokens = await Storage().getTokens();
    String? refreshtoken = tokens['refreshToken'];
    return refreshtoken;
  }

  Future<int> _getExpirtyMillis() async {
    final tokens = await Storage().getTokens();
    int expirtyMillis = tokens['expirtyMillis'];
    return expirtyMillis;
  }

  Future<void> _storeTokens(
      String accessToken, String refreshToken, int expirtyMillis) async {
    await Storage().storeTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expirtyMillis: expirtyMillis);
  }

  Future<String?> _getTicket() async {
    final tokens = await Storage().getTicket();
    String? ticket = tokens['ticket'];
    return ticket;
  }

  Future<String?> _getBrokerIp() async {
    final tokens = await Storage().getTicket();
    String? brokerIp = tokens['broker_ip'];
    return brokerIp;
  }

  Future<String?> _getBrokerPort() async {
    final tokens = await Storage().getTicket();
    String? brokerPort = tokens['broker_port'];
    return brokerPort;
  }

  Future<void> _storeTicket(
      String ticket, String brokerIp, String brokerPort) async {
    await Storage().storeTicket(
        ticket: ticket, brokerIp: brokerIp, brokerPort: brokerPort);
  }

  Future<void> _clearTokens() async {
    await Storage().clearUser();
  }

  Future<bool> tryRefreshToken() async {
    print('Performin refresh token');
    String _url = 'http://192.168.1.172:8081/authentication/renew_token';

    var request = RefreshToken(
            accessToken: await _getAccessToken(),
            refreshToken: await _getRefreshToken())
        .toJson();

    var dio = Dio();
    dio.options.contentType = 'application/json';
    dio.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );

    try {
      var response = await dio.post(_url, data: request);

      var _response = BasicApiResponse.fromJson((response.data));

      if (_response.success && _response.data != null) {
        // print('trueeeeeeeeeeeeeeeeeeeeeeee');
        String accessToken = _response.data['access_token'];
        String refreshToken = _response.data['refresh_token'];
        int expirtyMillis = await _getExpirtyMillis();
        // DateTime.now().millisecondsSinceEpoch + (expirtyMillis * 1000);

        await _storeTokens(accessToken, refreshToken, expirtyMillis);

        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      // print('DioError $e');

      return false;
    } catch (e) {
      // print('Error $e');
      return false;
    }
    // return false;
  }

  Future<BasicApiResponse> _handleExceptions(DioError e, String url,
      dynamic data, bool isPost, bool authorized, bool firstTry) async {
    if (e.response != null) {
      if (e.response?.statusCode == 400) {
        //Invalid Parameters
        return BasicApiResponse.missingParams(e.response?.data);
      } else if (e.response?.statusCode == 401 && firstTry) {
        // Unauthorized
        var refreshDone = await tryRefreshToken();
        if (refreshDone) {
          if (isPost) {
            print('Recalling $url with $data as POST');
            return await _post(url, data,
                authorized: authorized, firstTry: false);
          } else {
            print('Recalling $url as GET');
            return await _get(url, authorized: authorized, firstTry: false);
          }
        } else {
          _clearTokens();

          // final NavigationService _navigationService =
          //     locator<NavigationService>();
          // _navigationService.navigateTo(routes.LoginPage);
          //notify to go to login page
          // Shared().notifyLoginRequired();
          Get.defaultDialog(
              content: Text('Exception: Unauthorized. Login required.'));
          return BasicApiResponse.failed('Unauthorized. Login required.');
        }
      }
      return BasicApiResponse.fromJson(e.response?.data);
    }
    if (e.message.contains('SocketException')) {
      Get.defaultDialog(
          content: Text('Exception: Failed to connect to server.'));
      return BasicApiResponse.failed('Failed to connect to server.');
    }
    print('BasicApiResponse.failed');
    Get.defaultDialog(content: Text('Exception Fatal: ${e.message}.'));
    return BasicApiResponse.failed(e.message);
  }
}
