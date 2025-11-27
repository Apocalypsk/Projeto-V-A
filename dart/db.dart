import 'package:mysql1/mysql1.dart';

class Database {
  static Future<MySqlConnection> connect() async {
    final settings = ConnectionSettings(
      host: 'mysql-11c90c76-projetoib.l.aivencloud.com',
      port: 22993,
      user: 'avnadmin',
      password: 'AVNS_PaPGFxTI-Mwg9IIAPmI',
      db: 'defaultdb',
      useSSL: true,
    );

    return await MySqlConnection.connect(settings);
  }
}
