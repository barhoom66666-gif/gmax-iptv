part of '../api/api.dart';

const String tableChannels = "channels";
const String tableChannelLives = "channels_lives";
const String tableCategories = "categories";
const String tableUsers = "users";

const String databaseName = "gmax1.db";

class SqlDb {
  static Database? _db;

  //check if db has initialed or not, so we can call the db one time
  //we don't need to do the initialDb everytime, if it initial get it one time
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  ///initial database
  Future<Database> initialDb() async {
    if (UniversalPlatform.isWindows) {
      databaseFactory = databaseFactoryFfi;
    }

    String databasePath = await getDatabasesPath();
    //create database path
    String path = join(databasePath, databaseName);

    //version means update database from version 1 to version 2...
    Database mydb = await openDatabase(
      path,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 1,
    );
    return mydb;
  }

  ///create tables
  _onCreate(Database db, int version) async {
    ///Table Channels
    await db.execute('''
    CREATE TABLE "$tableChannels" (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      account_name TEXT NOT NULL,
      num TEXT,
      name TEXT,
      title TEXT,
      year TEXT,
      stream_type TEXT,
      series_id TEXT,
      cover TEXT,
      plot TEXT,
      cast TEXT,
      director TEXT,
      genre TEXT,
      release_date TEXT,
      releaseDate TEXT,
      last_modified TEXT,
      rating TEXT,
      rating_5based TEXT,
      backdrop_path TEXT,
      youtube_trailer TEXT,
      episode_run_time TEXT,
      category_id TEXT,
      category_ids TEXT,
      stream_id TEXT,
      stream_icon TEXT,
      added TEXT,
      container_extension TEXT,
      custom_sid TEXT,
      direct_source TEXT,
      is_favourite INTEGER
    )
    ''');

    ///Table Categories
    await db.execute('''
    CREATE TABLE "$tableCategories" (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      account_name TEXT NOT NULL,
      type TEXT NOT NULL,     
      category_id TEXT,
      category_name TEXT,
      parent_id TEXT
      )
    ''');

    ///Table User
    await db.execute('''
    CREATE TABLE "$tableUsers" (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      account_name TEXT NOT NULL,
      active INTEGER,
      domain TEXT,     
      type_login TEXT,
      user_info TEXT,
      server_info TEXT
      )
    ''');

    ///Table ChannelsLive
    await db.execute('''
    CREATE TABLE "$tableChannelLives" (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      account_name TEXT NOT NULL,
      num TEXT,
      name TEXT,
      stream_type TEXT,
      stream_id TEXT,
      stream_icon TEXT,
      epg_channel_id TEXT,
      added TEXT,
      custom_sid TEXT,
      tv_archive TEXT,
      direct_source TEXT,
      tv_archive_duration TEXT,
      category_id TEXT,
      thumbnail TEXT,
      is_favourite INTEGER
      )
    ''');
    debugPrint(
        "========================== DATABASE & TABLES has Created ==========================");
  }

  dropTable(Database db, String table) async {
    try {
      //STATE
      // final db = await SqlDb().initialDb();
      // SqlDb().dropTable(db, tableChannels);
      // End Reload app

      await db.execute('DROP TABLE $table');
      debugPrint("TABLE HAS DROP: $table");
    } catch (e) {
      debugPrint("Error Drop: $e");
    }
  }

  ///Upgrade tables
  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Perform database schema updates here
      // You can execute SQL statements to modify the database schema
      // For example, you can add or modify tables, columns, indexes, etc.

      await db.execute('''
              ALTER TABLE $tableChannelLives 
              ADD COLUMN is_favourite INTEGER
            ''');
    }
    debugPrint(
        "========================== DATABASE & TABLE has Upgraded ==========================");
  }

  ///READ RAW
  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }

  ///READ QUERY
  Future<List<Map<String, dynamic>>> readDataQuery(String database,
      {int? limit,
      int? offset,
      String? where,
      List<String>? columns,
      String? groupBy,
      String? orderBy,
      List<Object?>? whereArgs}) async {
    Database? mydb = await db;
    List<Map<String, dynamic>> response = await mydb!.query(
      database,
      limit: limit,
      offset: offset,
      where: where,
      columns: columns,
      groupBy: groupBy,
      orderBy: orderBy,
      whereArgs: whereArgs,
    );
    return response;
  }

  ///INSERT RAW
  Future<int> insertRawData(String sql, {List<dynamic>? list}) async {
    Database? mydb = await db;
    //return id created row, 0 means false, other numbers means it's id row
    int response = await mydb!.rawInsert(sql, list);
    return response;
  }

  ///INSERT MAP
  Future<int> insertMapData(String database, Map<String, dynamic> map) async {
    Database? mydb = await db;
    //return id created row, 0 means false, other numbers means it's id row
    int response = await mydb!.insert(database, map);
    return response;
  }

  ///Create Or Update
  Future<int> createOrUpdate(String database) async {
    Database? mydb = await db;
    //return id created row, 0 means false, other numbers means it's id row
    int response = await mydb!.rawInsert(database);
    return response;
  }

  ///UPDATE
  Future<int> updateData(String sql) async {
    Database? mydb = await db;
    //return id updated row
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  ///DELETE
  Future<int> deleteData(String sql) async {
    Database? mydb = await db;
    //return id deleted row
    int response = await mydb!.rawDelete(sql);
    return response;
  }
}
