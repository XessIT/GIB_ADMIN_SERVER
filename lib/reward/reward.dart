import 'package:flutter/material.dart';
import '../main.dart';

class Rewards extends StatelessWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: RewardsPage(),
    );
  }
}
class RewardsPage extends StatefulWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}
String points ='Set the points';
var pointslist = ['Set the points','1','2','3','4','5','6','7','8'];


final _formKey =GlobalKey<FormState>();

class _RewardsPageState extends State<RewardsPage> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/rewards',
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                      children: [
                        const Text("Reward Details",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 25),),
                        const SizedBox(height: 40,),
                        Wrap(

                        //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:  [

                           Wrap(
                             runSpacing: 20,
                             spacing: 10,
                             children: [
                               //Enter Reward TextFormField starts
                               SizedBox(width: 300,
                                 child: TextFormField(
                                   validator: (value){
                                     if(value!.isEmpty){
                                       return "Required reward";
                                     }else {
                                       return null;
                                     }
                                   },
                                   decoration: const InputDecoration(
                                     hintText: "set the points",
                                       label: Text('Enter Reward')
                                   ),

                                 ),
                               ),
                               //Enter Reward TextFormField ends

                               const SizedBox(width: 20),

                               //Previous Reward TextFormField starts
                               SizedBox(width: 300,
                                 child: TextFormField(
                                   validator: (value){
                                     if(value!.isEmpty){
                                       return "Required reward";
                                     }else {
                                       return null;
                                     }
                                   },
                                   decoration: const InputDecoration(
                                       label: Text('Previous Reward')

                                   ),
                                 ),
                               ),
                               //Previous Reward TextFormField end

                             ],
                           ),

                          ],
                        ),


                        const SizedBox(height: 80,),

                        //Submit ElevatedButton starts
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              shadowColor: Colors.pinkAccent,),
                            onPressed: (){
                              if(_formKey.currentState!.validate()){}
                            }, child: const Text("Submit")),
                        //Submit ElevatedButton starts

                      ],
                       ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
