import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  // ADD ACCESS LOG
  static Future<int> createAccess(int pId, String accessType) async {
    final db = await DbHelper.db();

    final accessInfo = {
      'p_id': pId,
      'access_type': accessType,
    };

    final newAccess = await db.insert('access', accessInfo,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print('New access log added');
    return newAccess;
  }

  /// CREATE PROFILE
  static Future<int> createProfile(
      int pId, String surname, String name, String gpa) async {
    final db = await DbHelper.db();

    final profileInfo = {
      'p_id': pId,
      'surname': surname,
      'name': name,
      'gpa': gpa
    };

    final newProfile = await db.insert('profiles', profileInfo,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    print('New profile added');
    return newProfile;
  }

  static Future<void> createTable(sql.Database db) async {
    await db.execute("""CREATE TABLE IF NOT EXISTS profiles(
          p_id INTEGER PRIMARY KEY NOT NULL,
          surname TEXT NOT NULL,
          name TEXT NOT NULL,
          gpa TEXT NOT NULL
        )""");

    await db.execute("""CREATE TABLE IF NOT EXISTS access(
          a_id INTEGER PRIMARY KEY,
          p_id INTEGER NOT NULL,
          access_type TEXT NOT NULL,
          timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY(p_id) REFERENCES profiles(p_id)
        )""");
  }

  /// CREATE DB
  static Future<sql.Database> db() async {
    return sql.openDatabase('profiles_db.db', version: 1,
        onCreate: (sql.Database db, int version) async {
      print('creating a table');
      await createTable(db);
    });
  }

  // DELETE PROFILE
  static Future<void> deleteProfile(int pId) async {
    final db = await DbHelper.db();

    try {
      await db.delete('profiles', where: "p_id=?", whereArgs: [pId]);
      createAccess(pId, 'Profile deleted');
    } catch (err) {
      debugPrint("Error deleting record $err");
    }
  }

  // GET ACCESS LOG
  static Future<List<Map<String, dynamic>>> getLogs(int pId) async {
    final db = await DbHelper.db();

    return db.query('access',
        where: "p_id = ?", whereArgs: [pId], orderBy: "timestamp DESC");
  }

  // GET SINGLE PROFILE
  static Future<List<Map<String, dynamic>>> getProfile(int pId) async {
    final db = await DbHelper.db();

    return db.query('profiles', where: "p_id = ?", whereArgs: [pId], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getProfilesById() async {
    final db = await DbHelper.db();

    return db.query('profiles', orderBy: "p_id");
  }

  // GET PROFILES
  static Future<List<Map<String, dynamic>>> getProfilesBySurname() async {
    final db = await DbHelper.db();

    return db.query('profiles', orderBy: "surname");
  }
}
