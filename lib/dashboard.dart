import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['_id'];
    getTodoList(userId);
  }

  // --- HÀM THÊM TO-DO ---
  void addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      var regBody = {
        "userId": userId,
        "title": _todoTitle.text,
        "desc": _todoDesc.text,
      };

      try {
        var response = await http.post(
          Uri.parse(addtodo),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${widget.token}",
          },
          body: jsonEncode(regBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true) {
          _todoDesc.clear();
          _todoTitle.clear();
          Navigator.pop(context);
          getTodoList(userId);
        }
      } catch (e) {
        print("Lỗi kết nối khi Add: $e");
      }
    }
  }

  // --- HÀM LẤY DANH SÁCH ---
  void getTodoList(userId) async {
    var regBody = {"userId": userId};
    try {
      var response = await http.post(
        Uri.parse(getToDoList),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: jsonEncode(regBody),
      );

      var jsonResponse = jsonDecode(response.body);
      setState(() {
        items = jsonResponse['success'];
      });
    } catch (e) {
      print("Lỗi lấy danh sách: $e");
    }
  }

  // --- HÀM XÓA ---
  void deleteItem(id) async {
    var regBody = {"id": id};
    try {
      var response = await http.post(
        Uri.parse(deleteTodo),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: jsonEncode(regBody),
      );

      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == true) {
        getTodoList(userId);
      }
    } catch (e) {
      print("Lỗi khi xóa: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: 60.0,
              left: 30.0,
              right: 30.0,
              bottom: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: Icon(Icons.list, size: 30.0),
                  backgroundColor: Colors.white,
                  radius: 30.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  'ToDo with NodeJS + Mongodb',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${items?.length ?? 0} Tasks',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: items == null
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: items!.length,
                        itemBuilder: (context, int index) {
                          return Slidable(
                            key: ValueKey(items![index]['_id']),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  onPressed: (BuildContext context) {
                                    deleteItem('${items![index]['_id']}');
                                  },
                                ),
                              ],
                            ),
                            child: Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.task,
                                  color: Colors.blueAccent,
                                ),
                                title: Text('${items![index]['title']}'),
                                subtitle: Text(
                                  '${items![index]['desc'] ?? "Không có mô tả"}',
                                ),
                                trailing: Icon(Icons.arrow_back_ios, size: 15),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add To-Do'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _todoTitle,
                decoration: InputDecoration(hintText: "Title"),
              ).p4(),
              TextField(
                controller: _todoDesc,
                decoration: InputDecoration(hintText: "Description"),
              ).p4(),
              ElevatedButton(
                onPressed: () => addTodo(),
                child: Text("Add"),
              ).p8(),
            ],
          ),
        );
      },
    );
  }
}
