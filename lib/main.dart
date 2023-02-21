import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/models/db.dart';

import 'package:intl/intl.dart';

// import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(DataBaseAdapter());
  await Hive.openBox<DataBase>('database');

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
    date = datesplit[0];
    month = datesplit[1];
    year = datesplit[2];

    fetch_db();

    super.initState();
  }

  void fetch_db() {
    print('fetching db my man');

    setState(() {
      db_list = db.values
          // .where((element) => element.edited == false)
          .toList()
          .cast<DataBase>();

      list_count = db_list.length;

      List<int> indexes_to_del = [];

      for (int i = 0; i < list_count; i++) {
        if (db_list[i].edited == true) {
          // db.delete(db_list[i]);
          indexes_to_del.add(i);
          print(i);
          print(db_list[i].title);
          print(db_list[i].edited);
        }
      }

      for (int i = 0; i < indexes_to_del.length; i++) {
        db.deleteAt(indexes_to_del[i]);
        // list_count -= 1;
      }

      // db_list = db.values
      //     // .where((element) => element.edited == false)
      //     .toList()
      //     .cast<DataBase>();

      // list_count = db_list.length;

      List<DataBase> db_list_editing = db.values
          .where((element) => element.edited == true)
          .toList()
          .cast<DataBase>();

      List<DataBase> db_list_1_1 = db.values
          .where((element) =>
              element.level == 0 &&
              element.edited == false &&
              element.check == false)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_1_2 = db.values
          .where((element) =>
              element.level == 0 &&
              element.edited == false &&
              element.check == true)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_2_1 = db.values
          .where((element) =>
              element.level == 1 &&
              element.edited == false &&
              element.check == false)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_2_2 = db.values
          .where((element) =>
              element.level == 1 &&
              element.edited == false &&
              element.check == true)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_3_1 = db.values
          .where((element) =>
              element.level == 2 &&
              element.edited == false &&
              element.check == false)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_3_2 = db.values
          .where((element) =>
              element.level == 2 &&
              element.edited == false &&
              element.check == true)
          .toList()
          .cast<DataBase>();

      db_list_1_1.sort((a, b) {
        return a.title.compareTo(b.title);
      });
      db_list_1_2.sort((a, b) {
        return a.title.compareTo(b.title);
      });
      db_list_2_1.sort((a, b) {
        return a.title.compareTo(b.title);
      });
      db_list_2_2.sort((a, b) {
        return a.title.compareTo(b.title);
      });

      db_list_3_1.sort((a, b) {
        return a.title.compareTo(b.title);
      });
      db_list_3_2.sort((a, b) {
        return a.title.compareTo(b.title);
      });

      db_list = db_list_editing +
          db_list_3_1 +
          db_list_2_1 +
          db_list_1_1 +
          db_list_3_2 +
          db_list_2_2 +
          db_list_1_2;

      list_count = db_list.length;
    });
  }

  void _refreshitems() {
    print('refreshing db my man');

    setState(() {
      List<DataBase> db_list_editing = db.values
          .where((element) => element.edited == true)
          .toList()
          .cast<DataBase>();

      List<DataBase> db_list_1_1 = db.values
          .where((element) =>
              element.level == 0 &&
              element.edited == false &&
              element.check == false)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_1_2 = db.values
          .where((element) =>
              element.level == 0 &&
              element.edited == false &&
              element.check == true)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_2_1 = db.values
          .where((element) =>
              element.level == 1 &&
              element.edited == false &&
              element.check == false)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_2_2 = db.values
          .where((element) =>
              element.level == 1 &&
              element.edited == false &&
              element.check == true)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_3_1 = db.values
          .where((element) =>
              element.level == 2 &&
              element.edited == false &&
              element.check == false)
          .toList()
          .cast<DataBase>();
      List<DataBase> db_list_3_2 = db.values
          .where((element) =>
              element.level == 2 &&
              element.edited == false &&
              element.check == true)
          .toList()
          .cast<DataBase>();

      db_list_1_1.sort((a, b) {
        return a.title.compareTo(b.title);
      });
      db_list_1_2.sort((a, b) {
        return a.title.compareTo(b.title);
      });
      db_list_2_1.sort((a, b) {
        return a.title.compareTo(b.title);
      });
      db_list_2_2.sort((a, b) {
        return a.title.compareTo(b.title);
      });

      db_list_3_1.sort((a, b) {
        return a.title.compareTo(b.title);
      });
      db_list_3_2.sort((a, b) {
        return a.title.compareTo(b.title);
      });

      db_list = db_list_editing +
          db_list_3_1 +
          db_list_2_1 +
          db_list_1_1 +
          db_list_3_2 +
          db_list_2_2 +
          db_list_1_2;

      list_count = db_list.length;
    });

    print('start');

    db_list.forEach((element) {
      print(element.title);
      print(element.edited);
      print("edited should be false");
    });

    print('end');
  }

  // void _del(DataBase db_item) {
  // setState(() {
  // db.delete(db_item);
  // list_count -= 1;
  // });
  // _refreshitems();
  // }

  void _del(String titl, int leve) {
    print('eeee');
    print(titl);
    print(level);
    var _task = db.values
        .where((element) => element.title == titl && element.level == leve)
        .first;
    _task.delete();

    print('ojo');

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
    _task.delete();

    print('nect');

    var new_data = DataBase(
      title: titl,
      check: !chec,
      edited: false,
      level: leve,
    );

    db.add(new_data);

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
    return Container(
      margin: const EdgeInsets.only(top: 0),
      // child: SingleChildScrollView(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        // separatorBuilder: (context, index) => const Divider(
        // color: Colors.white,
        // ),
        // key: Key('myList'),
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
                  // width: 10,
                  // height: 10,
                  margin:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  // decoration: BoxDecoration(
                  //   // border: Border.all(color: Colors.black),
                  //   borderRadius: BorderRadius.circular(10),
                  //   gradient: _tilecol(db_list[index].level),
                  // ),
                  //
                  // child:
                  // Text(db_list[index].title),
                  // child:
                  child: ListTile(
                    title: Text(
                      db_list[index].title,
                      style: TextStyle(
                        fontFamily: 'custom',
                        decoration: TextDecoration.lineThrough,
                        fontSize: 25,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        // db_list[index].check = !db_list[index].check;
                        _change_check(db_list[index].title,
                            db_list[index].level, db_list[index].check);
                      });
                    },
                  ),
                ),
              );
            } else {
              return Dismissible(
                key: UniqueKey(),
                onDismissed: ((direction) => {
                      print('uiui'),
                      _del(db_list[index].title, db_list[index].level),
                      print('oioi'),
                    }),
                child: Container(
                  // height: 10,
                  // width: 10,
                  margin:
                      const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    gradient: _tilecol(db_list[index].level),
                  ),
                  child: ListTile(
                    // tileColor: _tilecol(db_list[index].level),
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
                        print(index);
                        _change_check(db_list[index].title,
                            db_list[index].level, db_list[index].check);
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
                    decoration: const InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Type your task',
                    ),
                    onChanged: (text) {
                      setState(() {
                        title = text;
                        //fullName = nameController.text;
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
                                color: _iconcol(level),
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
                              // Text(
                              //   level.toString(),
                              // ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.save_rounded),
                          onPressed: () {
                            if (title == "") {
                              print('fill something bich');
                            } else {
                              print('huhu');
                              print(title);
                              print(level);

                              setState(() {
                                new_elem = !new_elem;

                                // db_list[index].title = title;
                                // db_list[index].edited = false;
                                // db_list[index].check = false;
                                // db_list[index].level = level;

                                // db.putAt(index, db_list[index]);

                                DataBase new_data = DataBase(
                                    title: title,
                                    edited: false,
                                    check: false,
                                    level: level);

                                db.add(new_data);

                                titleController.clear();
                              });

                              print(title);
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

              // trailing: Checkbox(
              //   value: db_list[index].check,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       db_list[index].check = value;
              //       // db.put(index, db_list[index]);
              //     });
              //   },
              // ),
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
      ),
      // ),
    );
  }

  void _delelement() {
    print('hihi');
    print(title);
    print(level);

    // var _task = db.values
    //     .where((element) => element.title == title && element.level == level)
    //     .first;
    // _task.delete();

    // List<DataBase> newdb_list = [];

    // for (int i = 0; i < list_count; i++) {
    //   if (db_list[i].title != title && db_list[i].level != level) {
    //     newdb_list.add(db_list[i]);
    //   }
    // }

    // setState(() {
    //   db_list = newdb_list;
    // });

    level = 0;
    titleController.text = "";
    new_elem = !new_elem;

    // _refreshitems();
    fetch_db();
  }

  void _newelement() {
    print('hmm');

    var new_data = DataBase(
      title: "",
      check: false,
      edited: true,
      level: 1,
    );

    db.add(new_data);

    setState(() {
      new_elem = !new_elem;
      titleController.clear();
      level = 0;
    });

    // db_list = db.values
    //     // .where((element) => element.edited == false)
    //     .toList()
    //     .cast<DataBase>();

    // db_list.forEach((element) {
    //   print(element.title);
    // });

    print('sad');

    _refreshitems();
  }

  double curve_width = 40;
  double curve_height = 40;

  ItemScrollController _scrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: const Color(0xff4044c9),
          ),
          Container(
            // margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            height: 60,
            color: const Color(0xff4044c9),
            alignment: Alignment.center,
            child: Center(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    Text(
                      datetoday,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    // SizedBox(
                    //   width:
                    //       MediaQuery.of(context).size.width - 30 - 30 - 90 - 30,
                    // ),
                    IconButton(
                      icon: new_elem
                          ? const Icon(Icons.delete_outline_outlined)
                          : const Icon(Icons.add_circle_outline_outlined),
                      color: Colors.white,
                      onPressed: () {
                        print('jiji');
                        if (new_elem) {
                          _delelement();
                        } else {
                          _newelement();
                        }
                      },
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                height: 40,
              ),
            ),
          ),
          Container(
            height: 50,
            color: const Color(0xff4044c9),
            child: Center(
              child: ScrollablePositionedList.builder(
                itemScrollController: _scrollController,
                itemCount: _myList.length,
                itemBuilder: (context, index) {
                  return _myList[index];
                },
              ),
            ),
// _scrollController.scrollTo(index: 150, duration: Duration(seconds: 1));),
          ),
          Expanded(
            child: Stack(children: [
              Container(
                height: 30,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: curve_height,
                      width: curve_width,
                      // color: Colors.white,
                      child: CustomPaint(
                        size: Size(
                            curve_width,
                            (curve_width * 0.5)
                                .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: RPSCustomPainter(),
                      ),
                    ),
                    SizedBox(
                      height: curve_height,
                      width: curve_width,
                      // color: Colors.white,
                      child: CustomPaint(
                        size: Size(
                            curve_width,
                            (curve_width * 0.5)
                                .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                        painter: RPSCustomPainterright(context),
                      ),
                    ),
                  ],
                ),
              ),
              _createList(),
            ]),
          ),
        ],
      ),
    );
  }
}
