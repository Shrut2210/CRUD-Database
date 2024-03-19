import 'package:crud_demo/database/my_database.dart';
import 'package:flutter/material.dart';

class InsertForDatabase extends StatefulWidget {
  Map<String, Object?>? map = {};

  InsertForDatabase(map) {
    this.map = map;
  }

  State<InsertForDatabase> createState() => _InsertForDatabase();
}


class _InsertForDatabase extends State<InsertForDatabase> {

  var nameController = TextEditingController();
  var descController = TextEditingController();
  var imageController = TextEditingController();

  void initState() {
    nameController.text = widget.map == null ? '': widget.map!['Name'].toString();
    descController.text = widget.map == null ? '': widget.map!['Desc'].toString();
    imageController.text = widget.map == null ? '': widget.map!['Image'].toString();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Insert Data', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: Column(
          children: [
            TextFormField(
              controller: imageController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter image url '
              ),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter name '
              ),
            ),
            TextFormField(
              controller: descController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Enter Description '
              ),
            ),
            ElevatedButton(onPressed: () {
              if(widget.map == null)
                {
                  addData().then((value) => {});
                }
              else
                {
                  editData(widget.map!['Name'].toString()).then((value) => {});
                }

              Navigator.of(context).pop(true);
            }, child: Text('ADD',))
          ],
        ),
        ),
      );
    // TODO: implement build
    throw UnimplementedError();
  }
  Future<int> addData() async {
    Map<String, Object?> map = {};

    map['Name'] = nameController.text;
    map['Desc'] = descController.text;
    map['Image'] = imageController.text;

    var res = await MyDatabase().insertData(map);
    return res;
  }

  Future<int> editData(id) async {
    Map<String, Object?> map = {};

    map['Name'] = nameController.text;
    map['Desc'] = descController.text;
    map['Image'] = imageController.text;

    var res = await MyDatabase().updatData(map, id);
    return res;
  }
}

