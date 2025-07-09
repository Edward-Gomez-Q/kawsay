import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project_3_kawsay/model/patient/medical_history_model.dart';

class EncryptionService {
  static final _key = Key.fromUtf8(dotenv.env['PRIVATE_KEY']!.padRight(32));

  static MedicalHistoryModel decryptModel(String encryptedBase64) {
    try {
      final combinedBytes = base64Decode(encryptedBase64);
      final iv = IV(Uint8List.fromList(combinedBytes.sublist(0, 16)));
      final encryptedBytes = combinedBytes.sublist(16);
      final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt(
        Encrypted(Uint8List.fromList(encryptedBytes)),
        iv: iv,
      );
      final map = jsonDecode(decrypted) as Map<String, dynamic>;
      return MedicalHistoryModel.fromMap(map);
    } catch (e) {
      print('Error decrypting data: $e');
      throw Exception('Failed to decrypt data');
    }
  }

  static Future<String> encodeDataWithPrivateKey(
    MedicalHistoryModel data,
  ) async {
    try {
      final jsonString = jsonEncode(data.toMap());
      final iv = IV.fromSecureRandom(16);
      final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(jsonString, iv: iv);
      final combined = iv.bytes + encrypted.bytes;
      return base64Encode(combined);
    } catch (e) {
      print('Error encrypting data: $e');
      throw Exception('Failed to encrypt data');
    }
  }
}
