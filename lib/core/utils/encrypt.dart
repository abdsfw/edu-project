import 'package:encrypt/encrypt.dart';

class Encryption {
  static const ivString = "ewlJy0SvQtgCk+ZwdpWn7Q==";
  static const keyString = "1RHb9p06ZTiU7myblEOKuc7OvaPHF+uPIlT7QLt1wF4=";

  static encrypt(plaintext) {
    final keyBytes = Key.fromBase64(keyString).bytes;
    final ivBytes = IV.fromBase64(ivString).bytes;

    final key = Key(keyBytes);
    final iv = IV(ivBytes);

    final encrypter = Encrypter(AES(key));
    Encrypted encrypted = encrypter.encrypt(plaintext, iv: iv);

    return encrypted.base64;
  }

  static decrypt(String sypherTextBase64) {
    final keyBytes = Key.fromBase64(keyString).bytes;
    final ivBytes = IV.fromBase64(ivString).bytes;
    final sypherTextEnceypted = Encrypted.fromBase64(sypherTextBase64).bytes;

    final encrypted = Encrypted(sypherTextEnceypted);
    final key = Key(keyBytes);
    final iv = IV(ivBytes);

    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    return decrypted.toString();
  }
}
