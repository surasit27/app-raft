import 'package:flutter_raft/models/sqlite_promotionmodel.dart';
import 'package:flutter_raft/models/sqlite_raftmodel.dart';
import 'package:flutter_raft/models/sqlite_servicesmodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteHelper {
  final String nameDatabase = 'RaftPJ.db';
  final int version = 1;

  final String tableDatabase = 'tableRaft';
  final String columnId = 'id';
  final String columnRaftId = 'raftId';
  final String columnRaftName = 'raftName';
  final String columnRaftDetails = 'raftDetails';
  final String columnrRftPrice = 'raftPrice';
  final String columnRaftImage = 'raftImage';
  final String columnBusinessId = 'busId';
  final String columnBusinessName = 'busName';

  final String nameSerDatabase = 'RaftSerPJ.db';
  final String tableServisesDatabase = 'tableServises';
  final String columnSqliteId = 'sqliteid';
  final String columnSerId = 'serId';
  final String columnSerName = 'serName';
  final String columnSerDetails = 'serDetails';
  final String columnrSerPrice = 'serPrice';
  final String columnSerImage = 'serImage';
  final String columnSerBusId = 'serbusId';
  final String columnSerBusName = 'serbusName';
  final String columnSerRaftId = 'serRaftId';

  final String nameproDatabase = 'RaftProPJ.db';
  final String tableProDatabase = 'tablePromotion';
  final String columnSqliteProid = 'sqliteProid';
  final String columnProId = 'proId';
  final String columnProName = 'proName';
  final String columnProImage = 'proImage';
  final String columnProDetaits = 'proDetaits';
  final String columnProDiscoun = 'proDiscoun';
  final String columnProStartdate = 'proStartdate';
  final String columnProLastdate = 'proLastdate';
  final String columnStatusId = 'proStatusId';
  final String columnStatusName = 'proStatusName';
  final String columnProBusId = 'proBusId';

  SQLiteHelper() {
    initialDatabase();
    initialServicesDatabase();
    initialPromotionDatabase();
  }

  Future<Null> initialPromotionDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameproDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableProDatabase ($columnSqliteProid INTEGER PRIMARY KEY, $columnProId TEXT, $columnProName TEXT, $columnProDetaits TEXT, $columnProDiscoun TEXT, $columnProStartdate TEXT, $columnProLastdate TEXT, $columnStatusId TEXT, $columnStatusName TEXT, $columnProImage TEXT, $columnProBusId TEXT)'),
      version: version,
    );
  }

  Future<void> deletePromotionSQLite(int id) async {
    Database database = await connectedPromotionDatadase();
    await database
        .delete(tableProDatabase, where: '$columnSqliteProid = $id')
        .then((value) => print('success delete id'));
  }

  Future<Database> connectedPromotionDatadase() async {
    return await openDatabase(join(await getDatabasesPath(), nameproDatabase));
  }

  Future<List<PromotionSQLite>> readPromotionSQLite() async {
    Database database = await connectedPromotionDatadase();
    List<PromotionSQLite> results = [];
    List<Map<String, dynamic>> maps = await database.query(tableProDatabase);

    print('### maps on SQL promotion ==> $maps');
    for (var item in maps) {
      PromotionSQLite model = PromotionSQLite.fromMap(item);
      results.add(model);
    }
    return results;
  }

  Future<Null> inserPromotionToSQLite(PromotionSQLite promotionSQLite) async {
    Database database = await connectedPromotionDatadase();
    await database
        .insert(tableProDatabase, promotionSQLite.toMap())
        .then((value) => print('inserEsrvices ==> ${promotionSQLite.proName}'));
  }

  Future<Null> initialServicesDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameSerDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableServisesDatabase ($columnSqliteId INTEGER PRIMARY KEY, $columnSerId TEXT, $columnSerName TEXT, $columnSerDetails TEXT, $columnrSerPrice TEXT, $columnSerImage TEXT, $columnSerBusId TEXT, $columnSerBusName TEXT, $columnSerRaftId TEXT)'),
      version: version,
    );
  }

  Future<void> deleteServicesSQLite(int id) async {
    Database database = await connectedServicesDatadase();
    await database
        .delete(tableServisesDatabase, where: '$columnSqliteId = $id')
        .then((value) => print('success delete id'));
  }

  Future<Database> connectedServicesDatadase() async {
    return await openDatabase(join(await getDatabasesPath(), nameSerDatabase));
  }

  Future<List<SesviceSQLite>> readServiceSQLite() async {
    Database database = await connectedServicesDatadase();
    List<SesviceSQLite> results = [];
    List<Map<String, dynamic>> maps =
        await database.query(tableServisesDatabase);

    print('### maps on SQL services ==> $maps');
    for (var item in maps) {
      SesviceSQLite model = SesviceSQLite.fromMap(item);
      results.add(model);
    }
    return results;
  }

  Future<Null> inserServicesToSQLite(SesviceSQLite sesviceSQLite) async {
    Database database = await connectedServicesDatadase();
    await database
        .insert(tableServisesDatabase, sesviceSQLite.toMap())
        .then((value) => print('inserEsrvices ==> ${sesviceSQLite.serName}'));
  }

  Future<Null> initialDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableDatabase ($columnId INTEGER PRIMARY KEY, $columnRaftId TEXT, $columnRaftName TEXT, $columnRaftDetails TEXT, $columnrRftPrice TEXT, $columnRaftImage TEXT, $columnBusinessId TEXT, $columnBusinessName TEXT)'),
      version: version,
    );
  }

  Future<Database> connectedDatadase() async {
    return await openDatabase(join(await getDatabasesPath(), nameDatabase));
  }

  Future<List<RaftSQLite>> readSQLite() async {
    Database database = await connectedDatadase();
    List<RaftSQLite> results = [];
    List<Map<String, dynamic>> maps = await database.query(tableDatabase);

    print('### maps on SQL ==> $maps');
    for (var item in maps) {
      RaftSQLite model = RaftSQLite.fromMap(item);
      results.add(model);
    }
    return results;
  }

  Future<void> deleteRaftSQLite(int id) async {
    Database database = await connectedDatadase();
    await database
        .delete(tableDatabase, where: '$columnId = $id')
        .then((value) => print('success delete id'));
  }

  Future<Null> inserRaftToSQLite(RaftSQLite raftSQLite) async {
    Database database = await connectedDatadase();
    await database
        .insert(tableDatabase, raftSQLite.toMap())
        .then((value) => print('inserRaft ==> ${raftSQLite.raftName}'));
  }

  Future<void> emptyRaftSQLite() async {
    Database database = await connectedDatadase();
    await database
        .delete(tableDatabase)
        .then((value) => print('Empty SQLiteRaft Success'));
  }

  Future<void> emptyServiseSQlite() async {
    Database database = await connectedServicesDatadase();
    await database
        .delete(tableServisesDatabase)
        .then((value) => print('Empty SQLiteServices Success'));
  }

  Future<void> emptyPromotion() async {
    Database database = await connectedPromotionDatadase();
    await database
        .delete(tableProDatabase)
        .then((value) => print('Empty SQLitePromotion Success'));
  }
}
