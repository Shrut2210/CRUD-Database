import 'package:crud_demo/InsertData.dart';
import 'package:crud_demo/InsertForDatabase.dart';
import 'package:crud_demo/api/my_api.dart';
import 'package:crud_demo/database/my_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  late TabController _tabController;
  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(child: Icon(Icons.add, color: Colors.white, size: 20,),
          onTap: () {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
               builder: (BuildContext context) {
                 return AlertDialog(
                   backgroundColor: Colors.blue,
                   title: Text('Where to add data!!??', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                   actions: [
                     TextButton(onPressed: () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                         return InsertData();
                       }));
                     }, child: Text('API', style: TextStyle(color: Colors.black),)),
                     TextButton(onPressed: () {
                       Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                         return InsertForDatabase(null);
                       }));
                     }, child: Text('Database', style: TextStyle(color: Colors.black),))
                   ],
                 );
               },
            );
          },),
          InkWell(
            child: Icon(Icons.refresh ,color: Colors.white, size: 20,),
            onTap: () {
              setState(() {

              });
            },
          )
        ],
        backgroundColor: Colors.black,
        title: Center(child:
          Text('Crud Demo', style: TextStyle(color: Colors.white),),),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.exposure_plus_1, color: Colors.blue,),
            ),
            Tab(
              icon: Icon(Icons.exposure_plus_2, color: Colors.blue,),
            )
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            child: FutureBuilder(
              future: MyDatabase().copyPasteAssetFileToRoot(),
              builder: (context, snapshotcopy) {
                print(snapshotcopy.data);
                if(snapshotcopy.hasData){
                  return FutureBuilder(future: MyDatabase().getDetails(), builder: (context, snapshotdata) {
                    if(snapshotdata.hasData)
                      {
                        return ListView.builder(
                          itemCount: snapshotdata.data!.length,
                            itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                              padding: EdgeInsets.all(10),

                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(image: NetworkImage(snapshotdata.data![index]['Image']), fit: BoxFit.cover)
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        color: Color.fromRGBO(0, 0, 0, 90)
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: Text(
                                        snapshotdata.data![index]['Name'], style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    margin: EdgeInsets.only(bottom: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(child: Icon(Icons.delete, color: Colors.white,),
                                        onTap: () async {
                                          await MyDatabase().deleteData(
                                            snapshotdata.data![index]['Name']
                                          ).then((value) => setState((){}));
                                        },),
                                        InkWell(child: Icon(Icons.edit, color: Colors.white,),
                                        onTap: () async {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
                                            return InsertForDatabase(snapshotdata.data![index]);
                                          },)).then((value) => {setState( () {})});
                                        },)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                        });
                      }
                    else
                      {
                        return Center(child: CircularProgressIndicator(),);
                      }
                  });
                }
                else
                  {
                    return Container(
                      child: Text("Not Found..."),
                    );
                  }
              },
            ),
          ),
          Container(
            child: FutureBuilder(
              future: MyAPI().getData(),
              builder: (context, snapshotcopy) {
                if(snapshotcopy.hasData)
                {
                  return ListView.builder(
                      itemCount: snapshotcopy.data!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
                          padding: EdgeInsets.all(10),

                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(image: NetworkImage(snapshotcopy.data![index]?['avatar']), fit: BoxFit.cover)
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: Color.fromRGBO(0, 0, 0, 90)
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Center(
                                      child: Text(
                                        snapshotcopy.data![index]?['name'], style: TextStyle(color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: InkWell(
                                        child: Icon(Icons.delete, color: Colors.white,),
                                      onTap: () {
                                          MyAPI().deleteData(snapshotcopy.data![index]['id']);
                                          setState(() {

                                          });
                                      },
                                    ),

                                  ),
                                  Container(
                                    child: InkWell(
                                      child: Icon(Icons.edit, color: Colors.white,),
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (builder) {

                                          return InsertData(map: {'id' : snapshotcopy.data![index]['id'], 'name' : snapshotcopy.data![index]['name'], 'exp' : snapshotcopy.data![index]['exp'], 'avatar' : snapshotcopy.data![index]['avatar']},);
                                        }));
                                      },
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      });
                }
                else
                {
                  return Center(
                    child: Text(snapshotcopy.error.toString()),
                  );
                }
              },
            ),
          ),
        ],
      )
    );
    throw UnimplementedError();
  }}
