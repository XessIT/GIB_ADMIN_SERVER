import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class AddBusinessCategory extends StatelessWidget {
  const AddBusinessCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: AddBusinessCategoryPage(),
    );
  }
}
class AddBusinessCategoryPage extends StatelessWidget {
   AddBusinessCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        route: '/add_business_category',
        body: Column(
          children: [
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width:650,
                height: 600,
                color: Colors.white,
              child: Column(
                children: [
                  //Add Business Category
                  const SizedBox(height: 30,),
                  Text('Add Business Category', style: Theme.of(context).textTheme.headlineMedium,),
                  const SizedBox(height: 30,),
                  Column(
                    children:  [
                      //Manufacture
                      SizedBox(height: 55,width: 250,
                        child: InkWell(
                          onTap: (){
                            _manufacuturer(context);
                          },
                          child:  Container(
                            decoration:  const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  end: Alignment.bottomLeft,
                                  colors: [Colors.teal,Colors.lightBlueAccent]),
                              shape: BoxShape.rectangle
                            ),
                           // color: Colors.blueAccent,
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text('Manufacture')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),

                      //Wholesale
                      SizedBox(height: 55,width: 250,
                        child: InkWell(
                          onTap: (){
                            _wholeSale(context);
                          },
                          child:  Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.redAccent,Colors.lightBlueAccent])
                            ),
                            // color: Colors.blueAccent,
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text('Wholesale')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),

                      //Distributed
                      SizedBox(height: 55,width: 250,
                        child: InkWell(
                          onTap: (){
                            _distributed(context);
                          },
                          child:  Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.orangeAccent,Colors.lightBlueAccent])
                            ),
                            // color: Colors.blueAccent,
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text('Distributed')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),

                      //service
                      SizedBox(height: 55,width: 250,
                        child: InkWell(
                          onTap: (){
                            _service(context);
                          },
                          child:  Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.pinkAccent,Colors.lightBlueAccent])
                            ),
                            // color: Colors.blueAccent,
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text('Service')),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),
                      //Retail
                      SizedBox(height: 55,width: 250,
                        child: InkWell(
                          onTap: (){
                            _retail(context);
                          },
                          child:  Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.bottomLeft,
                                    colors: [Colors.deepPurpleAccent,Colors.lightBlueAccent])
                            ),
                            // color: Colors.blueAccent,
                            child: const Align(
                                alignment: Alignment.center,
                                child: Text('Retail')),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25,),
                      ElevatedButton(onPressed: (){
                        Navigator.pop(context);
                      }, child:const Text('GoBack')),
                    ],
                  )
                ],
              ),
          ),
            )],
        ));
  }
}
//_manufacuturer alertDialogue

void _manufacuturer(BuildContext context) {
  TextEditingController manufacturersubcategory =TextEditingController();

  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title:const Text("Manufacturer"),
              content:   SizedBox(width: 300,
                child: TextFormField(
                  controller: manufacturersubcategory,
                  decoration: InputDecoration(
                      hintText: "Enter SubCategory",
                      suffix: IconButton(onPressed: (){


                      },icon: const Icon(Icons.delete,color: Colors.red,),)
                  ),
                ),
              ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton( onPressed: () {   FirebaseFirestore.instance.collection("Manufacturing Sub Collection").doc().set(
                  {"Sub Collection":manufacturersubcategory.text.trim()});

              }, child: Text("ADD"),),
            const  SizedBox(width: 20,),
              ElevatedButton( onPressed: () { }, child: Text("Submit"),),
              const  SizedBox(height: 20,),


           /*   TextButton(
                child:  Text('delete',style: Theme.of(context).textTheme.headline5,),
                onPressed: () {
                  // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),*/
            ],
          ),
        ],
      );
    },
  );
}

//wholeSale alertDialogue
void _wholeSale(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title:const Text("WholeSale"),
        content:   SizedBox(width: 300,
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Enter SubCategory",
                suffix: IconButton(onPressed: (){},icon: Icon(Icons.delete,color: Colors.red,),)
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton( onPressed: () {  }, child: const Text("ADD"),),
              const  SizedBox(width: 20,),
              ElevatedButton( onPressed: () { }, child: const Text("Submit"),),
              const  SizedBox(height: 20,),


              /*   TextButton(
                child:  Text('delete',style: Theme.of(context).textTheme.headline5,),
                onPressed: () {
                  // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),*/
            ],
          ),
        ],
      );
    },
  );
}

//distributor alertDialogue
void _distributed(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title:const Text("Distributor"),
        content:   SizedBox(width: 300,
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Enter SubCategory",
                suffix: IconButton(onPressed: (){},icon: Icon(Icons.delete,color: Colors.red,),)
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton( onPressed: () {  }, child: const Text("ADD"),),
              const  SizedBox(width: 20,),
              ElevatedButton( onPressed: () { }, child: const Text("Submit"),),
              const  SizedBox(height: 20,),


              /*   TextButton(
                child:  Text('delete',style: Theme.of(context).textTheme.headline5,),
                onPressed: () {
                  // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),*/
            ],
          ),
        ],
      );
    },
  );
}

//service alertDialogue
void _service(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title:const Text("Service"),
        content:   SizedBox(width: 300,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: "Enter SubCategory",
                suffix: IconButton(onPressed: (){},icon: Icon(Icons.delete,color: Colors.red,),)
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton( onPressed: () {  }, child: const Text("ADD"),),
              const  SizedBox(width: 20,),
              ElevatedButton( onPressed: () { }, child: const Text("Submit"),),
              const  SizedBox(height: 20,),


              /*   TextButton(
                child:  Text('delete',style: Theme.of(context).textTheme.headline5,),
                onPressed: () {
                  // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),*/
            ],
          ),
        ],
      );
    },
  );
}

//retail alertDialogue
void _retail(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title:const Text("Retail"),
        content:   SizedBox(width: 300,
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Enter SubCategory",
                suffix: IconButton(onPressed: (){},icon: Icon(Icons.delete,color: Colors.red,),)
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton( onPressed: () {  }, child: const Text("ADD"),),
              const  SizedBox(width: 20,),
              ElevatedButton( onPressed: () { }, child: const Text("Submit"),),
              const  SizedBox(height: 20,),


              /*   TextButton(
                child:  Text('delete',style: Theme.of(context).textTheme.headline5,),
                onPressed: () {
                  // Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                },
              ),*/
            ],
          ),
        ],
      );
    },
  );
}



