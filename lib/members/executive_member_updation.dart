import 'package:flutter/material.dart';
import '../main.dart';

class ExecutiveMemberUpdation extends StatelessWidget {
  const ExecutiveMemberUpdation({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ExecutiveMemberUpdationPage(),
    );
  }
}
class ExecutiveMemberUpdationPage extends StatefulWidget {
  const ExecutiveMemberUpdationPage({Key? key}) : super(key: key);

  @override
  State<ExecutiveMemberUpdationPage> createState() => _ExecutiveMemberUpdationPageState();
}

class _ExecutiveMemberUpdationPageState extends State<ExecutiveMemberUpdationPage> {

  String districtgroup ='Select District';
  var districtgrouplist = ['Select District','Erode','Salem',];

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: '/executive_member_updation',
      body: Center(
      child: Column(
        children:  [
          Text('Executive Member Updation',style: Theme.of(context).textTheme.headlineSmall),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Text('ID :',style: Theme.of(context).textTheme.headlineSmall,),
                  const SizedBox(width: 10,),
                  Text("2011102",style: Theme.of(context).textTheme.headlineSmall,),
                  const SizedBox(width: 5,),
                  Text("|",style: Theme.of(context).textTheme.headlineSmall,),
                  const SizedBox(width: 5,),
                  Text("Reg.On :",style: Theme.of(context).textTheme.headlineSmall,),
                  const SizedBox(width: 10,),
                  Text("25-07-2020",style: Theme.of(context).textTheme.headlineSmall,),
                ],
              ),
              Container(
                //  width: 300,
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: districtgroup,
                    //elevation: 20,
                    icon: const Icon(Icons.arrow_drop_down),
                    isExpanded: true,
                    items:districtgrouplist.map((String district) {
                      return DropdownMenuItem(
                          value: district,
                          child: Text(district)
                      );
                    }
                    ).toList(),
                    onChanged: (newValue){
                      setState(() {
                        districtgroup = newValue.toString();
                      });
                    },
                  ),
                ),
              ),
            ],
          )


        ],
      ),
    ),);
  }
}
