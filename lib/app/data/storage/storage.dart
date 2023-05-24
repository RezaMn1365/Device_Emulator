import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_storage.dart';
import 'storage_driver.dart';

//REQUIRED FIELDS
//const String KEY_USERNAME = 'USERNAME';
const String KEY_FIRSTNAME = 'FIRSTNAME';
const String KEY_LASTNAME = 'LASTNAME';
const String KEY_PASSWORD = 'PASSWORD';
const String KEY_PASSWORD2 = 'PASSWORD2';
const String KEY_EMAIL = 'EMAIL';

//OPTIONAL FIELDS
const String KEY_PHONE = 'PHONE';
const String KEY_NATIONALID = 'NATIONALID';
const String KEY_COUNTRY = 'COUNTRY';
const String KEY_PROVINCE = 'PROVINCE';
const String KEY_CITY = 'CITY';
const String KEY_ADDRESS = 'ADDRESS';
const String KEY_ZIP = 'ZIP';
const String KEY_LOCATION = 'LOCATION';
const String KEY_SOCIALMEDIA = 'SOCIALMEDIA';

const String KEY_ACCESSTOKEN = 'ACCESSTOKEN';
const String KEY_REFERESHTOKEN = 'REFERESHTOKEN';

const String KEY_HIVE_SECURE_TOKEN_BOX = 'KEY_HIVE_SECURE_TOKEN_BOX';

const String KEY_ACCESSTOKENT = 'ACCESSTOKENT';
const String KEY_REFERESHTOKENT = 'REFERESHTOKENT';
const String KEY_EXPIRTY_MILLIS = 'EXPIRTY_MILLIS';

const String KEY_TICKET = 'TICKET';
const String KEY_BROKERIP = 'BROKER_ADDRESS';
const String KEY_BROKERPORT = 'BROKER_PORT';

const String KEY_LONGITUDE = 'LONGITUDE';
const String KEY_LATITUDE = 'LATITUDE';

const String USER_TWITTER = 'USER_TWITTER';
const String USER_FACEBOOK = 'USER_FACEBOOK';
const String USER_INSTAGRAM = 'USER_INSTAGRAM';
const String USER_WHATSAPP = 'USER_WHATSAPP';

const String SECURE_STORAGE_KEY1 = 'HIVE_ENCYPTED_KEY1';
const String SECURE_STORAGE_KEY2 = 'HIVE_ENCYPTED_KEY2';

const String SECURE_STORAGE_TOKEN_KEY = 'SECURE_STORAGE_TOKEN_KEY';

// const FlutterSecureStorage secureStorage1 = FlutterSecureStorage();

class Storage {
  late StorageDriver _storage;

//MAKE SINGLETON
  static final Storage _singleton = Storage._internal();
  factory Storage() {
    return _singleton;
  }
  //In java
  // static Storage getInstance() {
  //   return _singleton;
  // }
  Storage._internal();
  //END OF SINGLETON

  Future<void> init() async {
    // WidgetsFlutterBinding.ensureInitialized();
    _storage = HiveStorage();
    await _storage.init();

    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    bool containsEncryptionKey =
        await secureStorage.containsKey(key: SECURE_STORAGE_TOKEN_KEY);

    List<int> hiveSecureKey;

    if (!containsEncryptionKey) {
      var newHiveSecureKey = Hive.generateSecureKey();
      hiveSecureKey = newHiveSecureKey;
      await secureStorage.write(
          key: SECURE_STORAGE_TOKEN_KEY, value: json.encode(newHiveSecureKey));
    } else {
      var initialSecureStorageKey =
          await secureStorage.read(key: SECURE_STORAGE_TOKEN_KEY);
      hiveSecureKey =
          (json.decode(initialSecureStorageKey!) as List<dynamic>).cast<int>();
    }
    await Hive.openBox(KEY_HIVE_SECURE_TOKEN_BOX,
        encryptionCipher: HiveAesCipher(hiveSecureKey));

    await Hive.openBox(
      KEY_HIVE_SECURE_TOKEN_BOX,
    );

    // _storage = SqliteStorage();
    // _storage = SharedPreferenceStorage();
  }

  Future storeTokens(
      {required String accessToken,
      required String refreshToken,
      required int expirtyMillis}) async {
    // final encryptedBox1 = await Hive.openBox(KEY_HIVE_SECURE_TOKEN_BOX,
    //     encryptionCipher: HiveAesCipher(secureKey1));

    final tokenBox = Hive.box(KEY_HIVE_SECURE_TOKEN_BOX);
    await tokenBox.put(KEY_ACCESSTOKENT, accessToken);
    await tokenBox.put(KEY_REFERESHTOKENT, refreshToken);
    await tokenBox.put(KEY_EXPIRTY_MILLIS, expirtyMillis);
  }

  Future<Map<String, dynamic>> getTokens() async {
    final tokenBox = Hive.box(KEY_HIVE_SECURE_TOKEN_BOX);
    String? accessToken = await tokenBox.get(KEY_ACCESSTOKENT);
    String? refreshToken = await tokenBox.get(KEY_REFERESHTOKENT);
    int? expirtyMillis = await tokenBox.get(KEY_EXPIRTY_MILLIS);
    // _encryptedBox1.close();
    // print(accessToken);
    // print(refreshToken);

    if (accessToken != 'null' && refreshToken != 'null') {
      return {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expirtyMillis': expirtyMillis
      };
    } else {
      return {
        'accessToken': 'null',
        'refreshToken': 'null',
        'expirtyMillis': null
      };
    }
  }

  Future storeTicket(
      {required String ticket,
      required String brokerIp,
      required String brokerPort}) async {
    // final encryptedBox1 = await Hive.openBox(KEY_HIVE_SECURE_TOKEN_BOX,
    //     encryptionCipher: HiveAesCipher(secureKey1));

    final tokenBox = Hive.box(KEY_HIVE_SECURE_TOKEN_BOX);
    await tokenBox.put(KEY_TICKET, ticket);
    await tokenBox.put(KEY_BROKERIP, brokerIp);
    await tokenBox.put(KEY_BROKERPORT, brokerPort);
  }

  Future<Map<String, dynamic>> getTicket() async {
    final tokenBox = Hive.box(KEY_HIVE_SECURE_TOKEN_BOX);
    String? ticket = await tokenBox.get(KEY_TICKET);
    String? brokerIp = await tokenBox.get(KEY_BROKERIP);
    String? brokerPort = await tokenBox.get(KEY_BROKERPORT);
    // _encryptedBox1.close();
    // print(accessToken);
    // print(refreshToken);

    if (ticket != 'null' && brokerIp != 'null') {
      return {
        'ticket': ticket,
        'broker_ip': brokerIp,
        'broker_port': brokerPort
      };
    } else {
      return {'ticket': 'null', 'broker_address': 'null', 'broker_port': null};
    }
  }

  Future<void> clearUser() async {
    final tokenBox = Hive.box(KEY_HIVE_SECURE_TOKEN_BOX);
    await tokenBox.clear();
    // await _storage.clear();
  }
}
