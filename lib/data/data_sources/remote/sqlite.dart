import 'package:ggv_ecom/data/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../../../data/models/cart_model.dart';


class DataBaseHelper {
  final databaseName = "shopper.db";
  String cart =
      "create table cart (id INTEGER PRIMARY KEY AUTOINCREMENT, product TEXT NOT NULL, description TEXT NOT NULL, amount REAL)";


  String users =
      "create table users (userId INTEGER PRIMARY KEY AUTOINCREMENT, userName TEXT UNIQUE, password TEXT)";


  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await db.execute(users);
          await db.execute(cart);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute(cart);
          }
        }
    );
  }


  Future<bool> login(Users user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
        "select * from users where userName = '${user.userName}' AND password = '${user.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

  Future<List<CartModel>> searchCartItem(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db
        .rawQuery("select * from cart where product LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => CartModel.fromMap(e)).toList();
  }

  Future<int> createCartItem(CartModel addToCart) async {
    final Database db = await initDB();
    return db.insert('cart', addToCart.toMap());
  }

  Future<List<CartModel>> getCartItem() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('cart');
    return result.map((e) => CartModel.fromMap(e)).toList();
  }

  Future<int> deleteCartItem(int id) async {
    final Database db = await initDB();
    return db.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateCartItem(id, product, description, amount) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update cart set product = ?, description = ? where id = ?, amount = ?',
        [id, product, description, amount]);
  }
}