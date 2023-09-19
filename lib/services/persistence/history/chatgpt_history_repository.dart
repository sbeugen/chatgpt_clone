import 'dart:convert';

import 'package:chatgpt_clone/providers/chatgpt/chat_data.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const tableName = 'chat_history';

class ChatGPTHistoryRepository {
  late final Database _database;

  ChatGPTHistoryRepository._create(Database database) {
    _database = database;
  }

  static Future<ChatGPTHistoryRepository> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    final database = await openDatabase(
      join(await getDatabasesPath(), 'chatgpt_history_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id TEXT PRIMARY KEY, data TEXT)',
        );
      },
      version: 1,
    );

    return ChatGPTHistoryRepository._create(database);
  }

  void upsertChat(Chat chat) async {
    final entry =
        await _database.query(tableName, where: 'id=?', whereArgs: [chat.id]);
    if (entry.isNotEmpty) {
      _database.update(tableName, {"data": jsonEncode(chat.toMap())},
          where: 'id=?', whereArgs: [chat.id]);
    } else {
      _database
          .insert(tableName, {'id': chat.id, "data": jsonEncode(chat.toMap())});
    }
  }

  Future<List<Chat>> getAll() async {
    final allEntries = await _database.query(tableName);
    return allEntries
        .map((entry) => Chat.fromMap(jsonDecode(entry['data'] as String)))
        .toList();
  }
}
