import 'dart:io';

import 'package:physio/Screens/Notification/MessageDetails.dart';
import 'package:sqflite/sqflite.dart' as db;
import 'package:path/path.dart';

class DatabaseHelper {
  static const int version = 1;
  static const String dbName = 'Physio';
  static const String logCounterTable = 'counter';
  static const String notificationsTable = 'notification';

  ///create database
  static Future<db.Database> getDb() async {
    // Open the database
    return db.openDatabase(join(await db.getDatabasesPath(), dbName),
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE $logCounterTable (logCont INTEGER); ");
          await db.execute(
              "CREATE TABLE $notificationsTable (id INTEGER PRIMARY KEY,title TEXT, body TEXT,hour INTEGER, minute INTEGER,repeats INTEGER ,active INTEGER,timestamp INTEGER);");
        }, version: version);
  }

  static Future<int> addLogCounter() async {
    final gDb = await getDb();
    return await gDb.insert(logCounterTable, {'logCont': 'log'},
        conflictAlgorithm: db.ConflictAlgorithm.replace);
  }

  static Future<int> deleteLogCounter() async {
    final gDb = await getDb();
    return await gDb.delete(
      logCounterTable,
    );
  }

  static Future<int> updateLogCounter(int logCount) async {
    final gDb = await getDb();
    return await gDb.update(logCounterTable, {'logCont': logCount},
        conflictAlgorithm: db.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getLogCounter() async {
    final gDb = await getDb();
    return await gDb.query(logCounterTable);
  }

  static Future<List<Map<String, dynamic>>> getAllAlerts() async {
    final gDb = await getDb();
    return await gDb.query(notificationsTable,orderBy: 'timestamp DESC');
  }

  static Future<int> addAlerts(MessageDetails message) async {
    final gDb = await getDb();
    return await gDb.insert(
        notificationsTable,
        {
          'id': message.id,
          'title': message.title,
          'body': message.body,
          'hour': message.hour,
          'minute': message.minute,
          'repeats': message.repeats ? 1 : 0,
          'active': message.active,
          'timestamp':DateTime.now().millisecondsSinceEpoch
        },
        conflictAlgorithm: db.ConflictAlgorithm.replace);
  }

  static Future<int> updateAlert(int id, int active) async {
    final gDb = await getDb();
    return await gDb.update(notificationsTable, {'active': active == 1 ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: db.ConflictAlgorithm.replace);
  }

  static Future<void> deleteTable({required table}) async {
    try {
      String path = join(await db.getDatabasesPath(), dbName);
      var database = await db.openDatabase(path);
      await database.execute('DROP TABLE IF EXISTS $table');
      print('  deleting table: done');
      await database.close();
    } catch (e) {
      print('Error deleting table: $e');
    }
  }

  static Future<void> deleteDatabase() async {
    try {
      String path = join(await db.getDatabasesPath(), dbName);
      final file = File(path);

      if (await file.exists()) {
        await file.delete();
        print('Database $dbName deleted successfully.');
      } else {
        print('Database $dbName does not exist.');
      }
    } catch (e) {
      print('Error deleting database: $e');
    }
  }
}