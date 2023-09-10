import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/models/db.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'constants.dart' as Constants;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(DataBaseAdapter());
  await Hive.openBox<DataBase>('database');
  // var a = await Hive.openBox<DataBase>('database');
  // a.clear();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO_DO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1d1d1d),
      body: Center(
        child: Container(
          height: 100,
          child: Image.asset('assets/splash.png'),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color(0xff4044c9)
      // ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.lineTo(0, size.height);
    path0.quadraticBezierTo(
        size.width * 0.4562700, size.height * 0.0411800, size.width, 0);
    path0.quadraticBezierTo(
        size.width * 0.6696800, size.height * 0.0008000, 0, 0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainterright extends CustomPainter {
  late BuildContext context;

  RPSCustomPainterright(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color(0xff4044c9)
      // ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(MediaQuery.of(context).size.width, 0);
    path0.lineTo(MediaQuery.of(context).size.width, size.height);
    path0.quadraticBezierTo(size.width * 0.4562700, size.height * 0.0411800,
        MediaQuery.of(context).size.width - size.width, 0);
    path0.quadraticBezierTo(size.width * 0.6696800, size.height * 0.0008000,
        MediaQuery.of(context).size.width, 0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var db = Hive.box<DataBase>('database');

  late List<DataBase> db_list;
  late int list_count;
  late String datetoday;
  String title = "";
  bool new_elem = false;
  int level = 0;

  TextEditingController titleController = TextEditingController();

  late int year;
  late int month;
  late int date;

  @override
  void initState() {
    final now = new DateTime.now();
    datetoday = DateFormat.yMd().format(now);
    List datesplit = datetoday.split('/');
    date = int.parse(datesplit[0]);
    month = int.parse(datesplit[1]);
    year = int.parse(datesplit[2]);

    fetch_db();

    super.initState();
  }

  void fetch_db() {
    setState(() {
      db_list = db.values.toList().cast<DataBase>();

      list_count = db_list.length;

      List<int> indexes_to_del = [];

      for (int i = 0; i < list_count; i++) {
        if (db_list[i].edited == true) {
          // db.delete(db_list[i]);
          indexes_to_del.add(i);
        }
      }

      for (int i = 0; i < indexes_to_del.length; i++) {
        db.deleteAt(indexes_to_del[i]);
        // list_count -= 1;
      }

      List<DataBase> db_list_editing = db.values
          .where((element) => element.edited == true)
          .toList()
          .cast<DataBase>();

      List<DataBase> db_list_nonediting = db.values
          .where((element) => element.edited == false)
          .toList()
          .cast<DataBase>();

      // List<DataBase> db_list_1_2 = db.values
      //     .where((element) =>
      //         element.level == 0 &&
      //         element.edited == false &&
      //         element.check == true)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_2_1 = db.values
      //     .where((element) =>
      //         element.level == 1 &&
      //         element.edited == false &&
      //         element.check == false)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_2_2 = db.values
      //     .where((element) =>
      //         element.level == 1 &&
      //         element.edited == false &&
      //         element.check == true)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_3_1 = db.values
      //     .where((element) =>
      //         element.level == 2 &&
      //         element.edited == false &&
      //         element.check == false)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_3_2 = db.values
      //     .where((element) =>
      //         element.level == 2 &&
      //         element.edited == false &&
      //         element.check == true)
      //     .toList()
      //     .cast<DataBase>();

      db_list_nonediting.sort((a, b) {
        return b.createdOn.compareTo(a.createdOn);
      });
      // db_list_1_2.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });
      // db_list_2_1.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });
      // db_list_2_2.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });

      // db_list_3_1.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });
      // db_list_3_2.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });

      db_list = db_list_editing + db_list_nonediting;
      // db_list_3_1 +
      // db_list_2_1 +
      // db_list_1_1 +
      // db_list_3_2 +
      // db_list_2_2 +
      // db_list_1_2;

      list_count = db_list.length;
    });
  }

  void _refreshitems() {
    setState(() {
      List<DataBase> db_list_editing = db.values
          .where((element) => element.edited == true)
          .toList()
          .cast<DataBase>();

      List<DataBase> db_list_nonediting = db.values
          .where((element) => element.edited == false)
          .toList()
          .cast<DataBase>();

      // List<DataBase> db_list_1_1 = db.values
      //     .where((element) =>
      //         element.level == 0 &&
      //         element.edited == false &&
      //         element.check == false)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_1_2 = db.values
      //     .where((element) =>
      //         element.level == 0 &&
      //         element.edited == false &&
      //         element.check == true)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_2_1 = db.values
      //     .where((element) =>
      //         element.level == 1 &&
      //         element.edited == false &&
      //         element.check == false)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_2_2 = db.values
      //     .where((element) =>
      //         element.level == 1 &&
      //         element.edited == false &&
      //         element.check == true)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_3_1 = db.values
      //     .where((element) =>
      //         element.level == 2 &&
      //         element.edited == false &&
      //         element.check == false)
      //     .toList()
      //     .cast<DataBase>();
      // List<DataBase> db_list_3_2 = db.values
      //     .where((element) =>
      //         element.level == 2 &&
      //         element.edited == false &&
      //         element.check == true)
      //     .toList()
      //     .cast<DataBase>();

      db_list_nonediting.sort((a, b) {
        return b.createdOn.compareTo(a.createdOn);
      });
      // db_list_1_2.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });
      // db_list_2_1.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });
      // db_list_2_2.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });

      // db_list_3_1.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });
      // db_list_3_2.sort((a, b) {
      //   return a.title.compareTo(b.title);
      // });

      db_list = db_list_editing + db_list_nonediting;
      // db_list_3_1 +
      // db_list_2_1 +
      // db_list_1_1 +
      // db_list_3_2 +
      // db_list_2_2 +
      // db_list_1_2;

      list_count = db_list.length;
    });

    db_list.forEach((element) {});
  }

  // void _del(DataBase db_item) {
  // setState(() {
  // db.delete(db_item);
  // list_count -= 1;
  // });
  // _refreshitems();
  // }

  void _del(String titl, int leve) {
    var _task = db.values
        .where((element) => element.title == titl && element.level == leve)
        .first;
    _task.delete();

    _refreshitems();
  }

  void _change_check(titl, leve, chec) {
    var _task = db.values
        .where((element) =>
            element.title == titl &&
            element.level == leve &&
            element.check == chec &&
            element.edited == false)
        .first;
    _task.check = !chec;

    _refreshitems();
  }

  Gradient _tilecol(leve) {
    if (leve == 0) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [
          0.2,
          0.95,
        ],
        colors: [
          Color(0xff4044c9),
          Color(0xff29bbbe),
        ],
      );
    } else if (leve == 1) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [
          0.2,
          0.95,
        ],
        colors: [
          Color(0xff4044c9),
          Color(0xffb3d1a3),
        ],
      );
    } else if (leve == 2) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [
          0.2,
          0.95,
        ],
        colors: [
          Color(0xff4044c9),
          Color(0xffff005c),
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [
          0.2,
          0.95,
        ],
        colors: [
          Color(0xff4044c9),
          Color(0xff29bbbe),
        ],
      );
    }
  }

  Color _iconcol(leve) {
    if (leve == 0) {
      return const Color(0xff29bbbe);
    } else if (leve == 1) {
      return const Color(0xffb3d1a3);
    } else if (leve == 2) {
      return const Color(0xffff005c);
    } else {
      return const Color(0xff29bbbe);
    }
  }

  Widget _createList() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: list_count,
      itemBuilder: (BuildContext context, int index) {
        if (!db_list[index].edited) {
          if (db_list[index].check) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: ((direction) => {
                    _del(db_list[index].title, db_list[index].level),
                  }),
              child: Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                child: ListTile(
                  title: Text(
                    db_list[index].title,
                    style: TextStyle(
                      fontFamily: 'custom',
                      decoration: TextDecoration.lineThrough,
                      fontSize: 25,
                      color: Constants.ForegroundColor12,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _change_check(db_list[index].title, db_list[index].level,
                          db_list[index].check);
                    });
                  },
                ),
              ),
            );
          } else {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: ((direction) => {
                    _del(db_list[index].title, db_list[index].level),
                  }),
              child: Container(
                // height: 10,
                // width: 10,
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: darktheme ? Constants.ForegroundColor2 : Constants.ForegroundColor1,
                ),
                child: ListTile(
                  title: Text(
                    db_list[index].title,
                    style: const TextStyle(
                      fontFamily: 'custom',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      // db_list[index].check = !db_list[index].check;
                      _change_check(db_list[index].title, db_list[index].level,
                          db_list[index].check);
                    });
                  },
                ),
                // Text(db_list[index].title),
              ),
            );
          }
        } else {
          return ListTile(
            title: Container(
                child: Column(
              children: [
                TextField(
                  controller: titleController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    labelText: 'Type your task',
                    iconColor: Colors.white,
                    fillColor: Colors.white,
                  ),
                  onChanged: (text) {
                    setState(() {
                      title = text;
                    });
                  },
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.catching_pokemon_sharp),
                              color: Colors.white,
                              onPressed: () {
                                setState(() {
                                  level += 1;
                                  if (level > 2) {
                                    level = 0;
                                  }
                                });

                                _refreshitems();
                              },
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.save_rounded),
                        color: Colors.white,
                        onPressed: () {
                          if (title == "") {
                          } else {
                            setState(() {
                              new_elem = !new_elem;

                              DataBase new_data = DataBase(
                                title: title,
                                edited: false,
                                check: false,
                                level: level,
                                createdOn: DateTime.now(),
                                // year: year,
                                // month: month,
                                // date: date,
                              );

                              db.add(new_data);

                              titleController.clear();
                            });

                            fetch_db();
                          }

                          _refreshitems();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )),
            onTap: () {
              setState(() {
                if (db_list[index].check) {
                  db_list[index].check = false;
                }
                db.putAt(index, db_list[index]);
              });
            },
          );
        }
      },
      shrinkWrap: true,
    );
  }

  void _delelement() {
    level = 0;
    titleController.text = "";
    new_elem = !new_elem;

    // _refreshitems();
    fetch_db();
  }

  void _newelement() {
    var new_data = DataBase(
      title: "",
      check: false,
      edited: true,
      level: 1,
      createdOn: DateTime.now(),
      // year: year,
      // month: month,
      // date: date,
    );

    db.add(new_data);

    setState(() {
      new_elem = !new_elem;
      titleController.clear();
      level = 0;
    });

    _refreshitems();
  }

  double curve_width = 40;
  double curve_height = 40;

  ItemScrollController _scrollController = ItemScrollController();

  bool darktheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: darktheme ? Constants.BackgroundColor2 : Constants.BackgroundColor1,
          ),
          Container(
            height: 40,
            width: double.infinity,
            color: darktheme ? Constants.BackgroundColor2 : Constants.BackgroundColor1,
            alignment: Alignment.centerRight,
            child: Container(
              height: 35,
              width: 80,
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.white)),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        darktheme = true;
                        
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color:
                                darktheme ? Colors.white : Colors.transparent),
                        color: Constants.ForegroundColor2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        darktheme = false;
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Constants.ForegroundColor1,
                          border: Border.all(
                            color:
                                darktheme ? Colors.transparent : Colors.white,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   height: 60,
          //   color: Constants.BackgroundColor1,
          //   child: Center(
          //     child: Container(
          //       width: double.infinity,
          //       margin: const EdgeInsets.only(left: 30, right: 30),
          //       child: Row(
          //         children: [
          //           const Text(
          //             "Hola",
          //             style: TextStyle(
          //               fontSize: 20,
          //               color: Colors.white,
          //             ),
          //           ),
          //           IconButton(
          //             icon: new_elem
          //                 ? const Icon(Icons.delete_outline_outlined)
          //                 : const Icon(Icons.add_circle_outline_outlined),
          //             color: Colors.white,
          //             onPressed: () {
          //               if (new_elem) {
          //                 _delelement();
          //               } else {
          //                 _newelement();
          //               }
          //             },
          //           ),
          //         ],
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       ),
          //       height: 40,
          //     ),
          //   ),
          // ),
          Container(
            color: darktheme ? Constants.BackgroundColor2 : Constants.BackgroundColor1,
            margin: const EdgeInsets.only(top: 0),
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                60,
            child: _createList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: new_elem
            ? const Icon(
                Icons.delete,
                color: Colors.white,
              )
            : const Icon(
                Icons.add,
                color: Colors.white,
              ),
        onPressed: () {
          if (new_elem) {
            _delelement();
          } else {
            _newelement();
          }
        },
      ),
    );
  }
}
