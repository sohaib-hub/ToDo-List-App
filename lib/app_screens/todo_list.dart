import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailList extends StatefulWidget {
  const DetailList({super.key});

  @override
  State<DetailList> createState() => _DetailListState();
}

class _DetailListState extends State<DetailList> {
  final title_controller = TextEditingController();
  final des_controller = TextEditingController();
  final status_controller = TextEditingController();

  String task_title = '';
  String task_des = '';
  String task_status = '';
  List<String> detail_list = [];
  List<String> title_list = [];
  List<String> des_list = [];
  List<String> status_list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    // SharedPreferences db = await SharedPreferences.getInstance();
    setState(() async {
      SharedPreferences db = await SharedPreferences.getInstance();
      SharedPreferences mainlist = await SharedPreferences.getInstance();

      // detail_list = db.getStringList('list_items') ?? [];
      await db.getStringList('title_list') ?? ['title is emply'];
      await db.getStringList('des_list') ?? ['des is emply'];
      await db.getStringList('status_list') ?? ['status is emply'];
      await mainlist.getStringList('listfordisplay') ?? ['empty list'];
    });
  }

  Future<void> saveItems() async {
    SharedPreferences db = await SharedPreferences.getInstance();
    SharedPreferences mainlist = await SharedPreferences.getInstance();
    await db.setStringList('title_list', title_list);
    await db.setStringList('des_list', des_list);
    await db.setStringList('status_list', status_list);
  }

  void Showdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add New Task'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: title_controller,
                  decoration: InputDecoration(labelText: 'Task'),
                  onSubmitted: (value) {
                    value = title_controller.text.toString();
                  },
                ),
                TextField(
                  controller: des_controller,
                  decoration: InputDecoration(labelText: 'description'),
                  onSubmitted: (value) {
                    value = des_controller.text.toString();
                  },
                ),
                TextField(
                  controller: status_controller,
                  decoration: InputDecoration(labelText: 'status'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final new_task_title = title_controller.text.toString();
                  final new_task_des = des_controller.text;
                  final new_task_status = status_controller.text;
                  if (new_task_title.isNotEmpty &&
                      new_task_des.isNotEmpty &&
                      new_task_status.isNotEmpty) {
                    setState(() {
                      title_list.add(new_task_title.toString());
                      des_list.add(new_task_des.toString());
                      status_list.add(new_task_status.toString());
                    });

                    saveItems();
                    title_controller.clear();
                    status_controller.clear();
                    des_controller.clear();
                  }
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
  }

  void dispose() {
    title_controller.dispose();
    status_controller.dispose();
    des_controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Showdialog();
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Daily Tasks ',style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: title_list.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 25),
                    child: InkWell(
                      onTap:(){
             showDialog(
               context: context,
               builder: (BuildContext context){
                 return AlertDialog(
                   title: Text('more Options'),
                   content: Column(
                     children: [
                       IconButton(onPressed: ()async{
                         SharedPreferences db=await SharedPreferences.getInstance();
                         title_list.removeAt(index);

                       }, icon: Icon(Icons.delete)),
                       IconButton(onPressed: (){
                       }, icon: Icon(Icons.edit)),

                     ],
                   ),
                   actions: [
                     TextButton(onPressed: (){
                       Navigator.pop(context);
                     }, child: Text('save')),
                     TextButton(onPressed: (){
                       Navigator.pop(context);
                     }, child: Text('cancle'))
                   ],
                 );
             }
             ); } ,
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          alignment: Alignment.center,
                          height: 100,
                          width: double.infinity,
                          child: ListTile(
                            title: Text(
                              title_list[index].toString(),
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 26),
                            ),
                            subtitle: Text(
                              des_list[index].toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              status_list[index].toString(),
                              style: TextStyle(fontSize: 22),
                            ),
                          )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
