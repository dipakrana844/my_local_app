import 'package:local_app/db_helper/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  var moDatabaseConnection;

  Repository() {
    moDatabaseConnection = DatabaseConnection();
  }

  static Database? moDatabase;

  Future<Database?> get database async {
    if (moDatabase != null) {
      return moDatabase;
    } else {
      moDatabase = await moDatabaseConnection.setDatabase();
      return moDatabase;
    }
  }

  insertData(table, data) async {
    var loConnection = await database;
    return await loConnection?.insert(table, data);
  }

  readData(table) async {
    var loConnection = await database;
    return await loConnection?.query(table);
  }

  readDataById(table, itemId) async {
    var loConnection = await database;
    return await loConnection?.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async {
    var loConnection = await database;
    return await loConnection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteDataById(table, itemId) async {
    var loConnection = await database;
    return await loConnection?.rawDelete("delete from $table where id=$itemId");
  }

  checkEmail(table, email) async {
    var loConnection = await database;
    var loX = await loConnection?.rawQuery("SELECT count(*) from $table ");
    int liCount = loX!.length;
    print("Your Count is : +$liCount");
    return liCount;
  }

  // checkEmail(table, email) async {
  //   var loConnection = await database;
  //   return await loConnection
  //       ?.rawQuery("SELECT count(*) from $table where email='$email'");
  // }

  checkDatabase(table) async {
    var loConnection = await database;
    var loCount =  await loConnection?.rawQuery("SELECT COUNT(*) FROM $table");
    print(loCount);
    return loCount;
  }

  getUserAllDetail(table, id) async {
    var loConnection = await database;
    return await loConnection?.rawQuery("select * from $table where id=$id");
  }
}
