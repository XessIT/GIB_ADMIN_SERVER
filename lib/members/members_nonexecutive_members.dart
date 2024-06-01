import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../main.dart';
import 'member_update_registration.dart';


class ViewNonExecutive extends StatelessWidget {
  const ViewNonExecutive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ViewNonExecutivePage(),
    );
  }
}

class ViewNonExecutivePage extends StatefulWidget {
  const ViewNonExecutivePage({Key? key}) : super(key: key);


  @override
  State<ViewNonExecutivePage> createState() => _ViewNonExecutivePageState();
}

class _ViewNonExecutivePageState extends State<ViewNonExecutivePage> {
  final _formKey = GlobalKey<FormState>();
  String numbersgroup = '10';
  var numbersgrouplist = ['10', '25', '50', '100',];




  String name = "";// search bar



  final TextEditingController search = TextEditingController();

  void clearText() {
    search.clear();
  }
  String membertype = "Non-Executive";

  String sno = "";

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }
  List<Map<String, dynamic>> data=[];
  Future<void> getData() async {
    print('Attempting to make HTTP request...');
    try {
      final url = Uri.parse('http://mybudgetbook.in/GIBADMINAPI/womens_executive.php?member_type=$membertype');
      print(url);
      final response = await http.get(url);
      print("ResponseStatus: ${response.statusCode}");
      print("Response: ${response.body}");
      // http.Response response = await http.get(url);
      //  var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("ResponseData: $responseData");
        final List<dynamic> itemGroups = responseData;
        setState(() {});
        data = itemGroups.cast<Map<String, dynamic>>();
        print('Data: $data');
        print("Id: ${data[0]["ID"]}");
      } else {
        print('Error: ${response.statusCode}');
      }
      print('HTTP request completed. Status code: ${response.statusCode}');
    } catch (e) {
      print('Error making HTTP request: $e');
      throw e; // rethrow the error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(route: "/members_non_executivepage",
        body: Form(
          key: _formKey,
          child: Center(
              child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                  children: [
                                    const SizedBox(height: 30,),
                                    Wrap(
                                      children: [
                                        //view non members start
                                        Text("View Non Executive Members", style: Theme.of(context).textTheme.headlineMedium,)],),

                                    const SizedBox(height: 20,),

                                    //Go back elevated button start
                                    /*  Align(alignment: Alignment.topRight,
                                      child: ElevatedButton(onPressed: () {
                                        if (_formKey.currentState!
                                            .validate()) {}Navigator.pop(context);}, child: const Text("Go back")),),*/
                                    // Go back elevated button end
                                    //show dropdown button start
                                    const SizedBox(height: 25,),
                                    Wrap(
                                      runSpacing: 20,spacing: 20,
                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(width: 300,
                                          child: TextFormField(
                                            onChanged: (val){
                                              setState(() {
                                                name = val;
                                              });
                                            },
                                            controller: search,
                                            decoration: const InputDecoration(
                                              prefixIcon: Icon(Icons.search),
                                              border: OutlineInputBorder(),
                                              hintText: 'Search ',
                                            ),

                                          ),
                                        ),
                                        const SizedBox(width: 20,height: 5,),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(),
                                            onPressed: (){
                                              if(_formKey.currentState!.validate()){}
                                              Navigator.pop(context);},
                                            child:const Text("Go Back",
                                              style: TextStyle(fontSize: 10),)),
                                        const SizedBox(width: 20,height: 5,),

                                      ],
                                    ),


                                    /*    Row(
                                      //  mainAxisAlignment: MainAxisAlignment.start,
                                        children: [const Text("Show",), const SizedBox(height: 20,),
                                          //dropdown button numbersgroup starts
                                          Padding(
                                              padding: const EdgeInsets.all(
                                                  15.0),
                                              child: Container(
                                                  height: 30,
                                                  width: 90,
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 12,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5.0),),
                                                  child: DropdownButtonHideUnderline(
                                                      child: DropdownButton(
                                                        value: numbersgroup,
                                                        //elevation: 20,
                                                        icon: const Icon(Icons.arrow_drop_down),
                                                        isExpanded: true, items: numbersgrouplist.map((String numbers) {
                                                        return DropdownMenuItem(value: numbers, child: Text(numbers));}
                                                      ).toList(),
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            numbersgroup = newValue.toString();});},)
                                                  )
                                              )
                                          ),
                                          //dropdown button numbersgroup end
                                          // entries text start
                                          const Text('Entries'),
                                          const SizedBox(width: 20,),
                                          // search
                                          const SizedBox(height: 7,),]),
                                    // entry text end

                                    //TextFormField Search starts
                                    Align(alignment: Alignment.topRight,
                                      child: SizedBox(width: 380,
                                        child: TextFormField(
                                          onChanged: (val){         //search bar
                                            setState(() {
                                              name = val ;
                                            });
                                          },
                                          controller: search,
                                          decoration: const InputDecoration(
                                            prefixIcon: Icon(Icons.search,
                                              color: Colors.green,),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12))), hintText: 'Search ',),
                                        ),
                                      ),
                                    ),*/
                                    //TextFormField Search end

                                    // Table starting
                                    const SizedBox(height: 27,),

                                    Container(
                                              child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                child: Table(
                                                  border: TableBorder.all(),
                                                  defaultColumnWidth: const FixedColumnWidth(190.0),
                                                  columnWidths: const<int, TableColumnWidth>{
                                                    0:FixedColumnWidth(70),2:FixedColumnWidth(100), 5:FixedColumnWidth(70)},
                                                  //  5:FixedColumnWidth(140),},
                                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                                  children: [
                                                    TableRow(
                                                        children: [
                                                          //s.no
                                                          TableCell(child: Center(child: Column(children: [
                                                            const SizedBox(height: 8,),
                                                            Text('S.No', style: Theme
                                                                .of(context)
                                                                .textTheme
                                                                .headlineMedium),
                                                            const SizedBox(height: 8,),
                                                          ],),)),
                                                          //name
                                                          TableCell(child: Center(child: Text('Name', style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headlineMedium),),),
                                                          // user id
                                                          TableCell(child: Center(child: Text('User Id', style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headlineMedium),),),
                                                          // email
                                                          TableCell(child: Center(child: Text('Email', style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headlineMedium),),),
                                                          // mobile
                                                          TableCell(child: Center(child: Text('Mobile', style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .headlineMedium),),),
                                                          // Edit
                                                          TableCell(child:  Center(child: Text('Edit', style: Theme.of(context).textTheme.headlineMedium),),),
                                                        ]
                                                    ),
                                                    for (var i = 0; i < data.length; i++) ...[
                                                      if( data[i]["first_name"].toString().toLowerCase().startsWith(name.toLowerCase()))

                                                      //   if( storedocs[i]["Company Name"].toString().toLowerCase().startsWith(name.toLowerCase()))

                                                        TableRow(
                                                            decoration: BoxDecoration(color: Colors.grey[200]),
                                                            children:[
                                                              //s.no
                                                              TableCell(child:Row(
                                                                children: [
                                                                  //       const SizedBox(width: 4,),
                                                                  //   IconButton( onPressed: () {}, icon:const Icon(Icons.add_circle,color: Colors.blue,)),
                                                                  // const SizedBox(width: 8,),
                                                                  Text("     "'${i+1}',),
                                                                  const SizedBox(width: 4,),
                                                                ],
                                                              ),),
                                                              // name
                                                              TableCell(child:Center(child: Column(children:  [ const SizedBox(height: 8,), Text('${data[i]["first_name"]}',), const SizedBox(height: 8,),])),),
                                                              //User id
                                                              const TableCell(child:Center(child: Text('2345678',)),),
                                                              // email
                                                              TableCell(child:Center(child: Text('${data[i]["email"]}',),),),
                                                              //mobile
                                                              TableCell(child:Center(child: Text('${data[i]["mobile"]}',),),),
                                                              TableCell(child: Center(
                                                                child: Column(
                                                                  children:  [
                                                                    const SizedBox(height: 8,),
                                                                    IconButton(onPressed: (){
                                                                      Navigator.push(context,
                                                                          MaterialPageRoute(builder: (context) =>  UpdateRegisterationPage(currentID: data[i]["id"])));
                                                                    },
                                                                        icon:const Icon(Icons.edit_note,color: Colors.blue,)),
                                                                    const SizedBox(height: 8,),
                                                                  ],),)),

                                                            ]
                                                        ),


                                                    ]
                                                  ],
                                                ),
                                                // Table end
                                              ))
                                    /* StreamBuilder(
    stream: nonexecutive,
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        print("Something went Wrong");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      final List storedocs = [];
      snapshot.data!.docs.map((DocumentSnapshot document) {
        Map a = document.data() as Map<String, dynamic>;
        storedocs.add(a);
        a['id'] = document.id;
      }).toList();
      ListView.builder(
          itemCount: storedocs.length,
          itemBuilder: (context, index) {
            return Container();
          });

        return PaginatedDataTable(columns: [DataColumn(label: Text("Hello")),
          DataColumn(label: Text("Hello")),
          DataColumn(label: Text("Hello"))], source: _data);}



    )*/]
                              ),)))
                  ]
              )
          ),
        )
    );
  }

}/*
class MyData extends DataTableSource {
  late String firstname;
  late String email;
  late String mobile;
  String membertype = 'Non Executive Wing';
  late Stream<QuerySnapshot> nonexecutive =
  FirebaseFirestore.instance.collection('Register')
   // .where("First Name", isEqualTo: firstname)
      .snapshots();

  // Generate some made-up data
  final List<Map<String, dynamic>> storedocs = List.generate(
      100, (i) => {
        "First Name":i,
        "Email": "Item $i",
        "Mobile": Random().nextInt(10000)
      });


  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => storedocs.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int i) {
    return DataRow(cells: [
      DataCell(Text(storedocs[i]['First Name'].toString())),
      DataCell(Text(storedocs[i]["Email"])),
      DataCell(Text(storedocs[i]["Mobile"].toString())),
    ]);
  }
}*/
/*
class DataTableDemo extends StatefulWidget {
  const DataTableDemo({Key? key}) : super(key: key);

  @override
  State<DataTableDemo> createState() => _DataTableDemoState();
}

class _RestorableDessertSelections extends RestorableProperty<Set<int>> {
  Set<int> _dessertSelections = {};

  /// Returns whether or not a dessert row is selected by index.
  bool isSelected(int index) => _dessertSelections.contains(index);

  /// Takes a list of [_Dessert]s and saves the row indices of selected rows
  /// into a [Set].
  void setDessertSelections(List<_Dessert> desserts) {
    final updatedSet = <int>{};
    for (var i = 0; i < desserts.length; i += 1) {
      var dessert = desserts[i];
      if (dessert.selected) {
        updatedSet.add(i);
      }
    }
    _dessertSelections = updatedSet;
    notifyListeners();
  }

  @override
  Set<int> createDefaultValue() => _dessertSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _dessertSelections = {
      ...selectedItemIndices.map<int>((dynamic id) => id as int),
    };
    return _dessertSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _dessertSelections = value;
  }

  @override
  Object toPrimitives() => _dessertSelections.toList();
}

class _DataTableDemoState extends State<DataTableDemo> with RestorationMixin {
  final _RestorableDessertSelections _dessertSelections =
  _RestorableDessertSelections();
  final RestorableInt _rowIndex = RestorableInt(0);
  final RestorableInt _rowsPerPage =
  RestorableInt(PaginatedDataTable.defaultRowsPerPage);
  final RestorableBool _sortAscending = RestorableBool(true);
  final RestorableIntN _sortColumnIndex = RestorableIntN(null);
  _DessertDataSource? _dessertsDataSource;

  @override
  String get restorationId => 'data_table_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_dessertSelections, 'selected_row_indices');
    registerForRestoration(_rowIndex, 'current_row_index');
    registerForRestoration(_rowsPerPage, 'rows_per_page');
    registerForRestoration(_sortAscending, 'sort_ascending');
    registerForRestoration(_sortColumnIndex, 'sort_column_index');

   // _dessertsDataSource ??= _DessertDataSource(context);
    switch (_sortColumnIndex.value) {
      case 0:
        _dessertsDataSource!._sort<String>((d) => d.name, _sortAscending.value);
        break;
      case 1:
        _dessertsDataSource!
            ._sort<num>((d) => d.calories, _sortAscending.value);
        break;
      case 2:
        _dessertsDataSource!._sort<num>((d) => d.fat, _sortAscending.value);
        break;
      case 3:
        _dessertsDataSource!._sort<num>((d) => d.carbs, _sortAscending.value);
        break;
      case 4:
        _dessertsDataSource!._sort<num>((d) => d.protein, _sortAscending.value);
        break;
      case 5:
        _dessertsDataSource!._sort<num>((d) => d.sodium, _sortAscending.value);
        break;
      case 6:
        _dessertsDataSource!._sort<num>((d) => d.calcium, _sortAscending.value);
        break;
      case 7:
        _dessertsDataSource!._sort<num>((d) => d.iron, _sortAscending.value);
        break;
    }
    _dessertsDataSource!.updateSelectedDesserts(_dessertSelections);
    _dessertsDataSource!.addListener(_updateSelectedDessertRowListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  //  _dessertsDataSource ??= _DessertDataSource(context)!;
    _dessertsDataSource!.addListener(_updateSelectedDessertRowListener);
  }

  void _updateSelectedDessertRowListener() {
    _dessertSelections.setDessertSelections(_dessertsDataSource!._desserts);
  }

  void _sort<T>(
      Comparable<T> Function(_Dessert d) getField,
      int columnIndex,
      bool ascending,
      ) {
    _dessertsDataSource!._sort<T>(getField, ascending);
    setState(() {
      _sortColumnIndex.value = columnIndex;
      _sortAscending.value = ascending;
    });
  }

  @override
  void dispose() {
    _rowsPerPage.dispose();
    _sortColumnIndex.dispose();
    _sortAscending.dispose();
    _dessertsDataSource!.removeListener(_updateSelectedDessertRowListener);
    _dessertsDataSource!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // final localizations = GalleryLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("localizations.demoDataTableTitle"),
      ),
      body: Scrollbar(
        child: ListView(
          restorationId: 'data_table_list_view',
          padding: const EdgeInsets.all(16),
          children: [
            PaginatedDataTable(
              header: Text("localizations.dataTableHeader"),
              rowsPerPage: _rowsPerPage.value,
              onRowsPerPageChanged: (value) {
                setState(() {
                  _rowsPerPage.value = value!;
                });
              },
              initialFirstRowIndex: _rowIndex.value,
              onPageChanged: (rowIndex) {
                setState(() {
                  _rowIndex.value = rowIndex;
                });
              },
              sortColumnIndex: _sortColumnIndex.value,
              sortAscending: _sortAscending.value,
              onSelectAll: _dessertsDataSource!._selectAll,
              columns: [
                DataColumn(
                  label: Text("localizations.dataTableColumnDessert"),
                  onSort: (columnIndex, ascending) =>
                      _sort<String>((d) => d.name, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text("localizations.dataTableColumnCalories"),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.calories, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text("localizations.dataTableColumnFat"),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.fat, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text("localizations.dataTableColumnCarbs"),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.carbs, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text("localizations.dataTableColumnProtein"),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.protein, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text("localizations.dataTableColumnSodium"),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.sodium, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text("localizations.dataTableColumnCalcium"),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.calcium, columnIndex, ascending),
                ),
                DataColumn(
                  label: Text("localizations.dataTableColumnIron"),
                  numeric: true,
                  onSort: (columnIndex, ascending) =>
                      _sort<num>((d) => d.iron, columnIndex, ascending),
                ),
              ],
              source: _dessertsDataSource!,
            ),
          ],
        ),
      ),
    );
  }
}

class _Dessert {
  _Dessert(
      this.name,
      this.calories,
      this.fat,
      this.carbs,
      this.protein,
      this.sodium,
      this.calcium,
      this.iron,
      );

  final String name;
  final int calories;
  final double fat;
  final int carbs;
  final double protein;
  final int sodium;
  final int calcium;
  final int iron;
  bool selected = false;
}

class _DessertDataSource extends DataTableSource {
  _DessertDataSource(this.context) {
    //final localizations = GalleryLocalizations.of(context);
    var localizations;
    _desserts = <_Dessert>[
      _Dessert(
        localizations.dataTableRowFrozenYogurt,
        159,
        6.0,
        24,
        4.0,
        87,
        14,
        1,
      ),
      _Dessert(
        localizations.dataTableRowIceCreamSandwich,
        237,
        9.0,
        37,
        4.3,
        129,
        8,
        1,
      ),
      _Dessert(
        localizations.dataTableRowEclair,
        262,
        16.0,
        24,
        6.0,
        337,
        6,
        7,
      ),
      _Dessert(
        localizations.dataTableRowCupcake,
        305,
        3.7,
        67,
        4.3,
        413,
        3,
        8,
      ),
      _Dessert(
        localizations.dataTableRowGingerbread,
        356,
        16.0,
        49,
        3.9,
        327,
        7,
        16,
      ),
      _Dessert(
        localizations.dataTableRowJellyBean,
        375,
        0.0,
        94,
        0.0,
        50,
        0,
        0,
      ),
      _Dessert(
        localizations.dataTableRowLollipop,
        392,
        0.2,
        98,
        0.0,
        38,
        0,
        2,
      ),
      _Dessert(
        localizations.dataTableRowHoneycomb,
        408,
        3.2,
        87,
        6.5,
        562,
        0,
        45,
      ),
      _Dessert(
        localizations.dataTableRowDonut,
        452,
        25.0,
        51,
        4.9,
        326,
        2,
        22,
      ),
      _Dessert(
        localizations.dataTableRowApplePie,
        518,
        26.0,
        65,
        7.0,
        54,
        12,
        6,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowFrozenYogurt,
        ),
        168,
        6.0,
        26,
        4.0,
        87,
        14,
        1,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowIceCreamSandwich,
        ),
        246,
        9.0,
        39,
        4.3,
        129,
        8,
        1,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowEclair,
        ),
        271,
        16.0,
        26,
        6.0,
        337,
        6,
        7,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowCupcake,
        ),
        314,
        3.7,
        69,
        4.3,
        413,
        3,
        8,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowGingerbread,
        ),
        345,
        16.0,
        51,
        3.9,
        327,
        7,
        16,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowJellyBean,
        ),
        364,
        0.0,
        96,
        0.0,
        50,
        0,
        0,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowLollipop,
        ),
        401,
        0.2,
        100,
        0.0,
        38,
        0,
        2,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowHoneycomb,
        ),
        417,
        3.2,
        89,
        6.5,
        562,
        0,
        45,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowDonut,
        ),
        461,
        25.0,
        53,
        4.9,
        326,
        2,
        22,
      ),
      _Dessert(
        localizations.dataTableRowWithSugar(
          localizations.dataTableRowApplePie,
        ),
        527,
        26.0,
        67,
        7.0,
        54,
        12,
        6,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowFrozenYogurt,
        ),
        223,
        6.0,
        36,
        4.0,
        87,
        14,
        1,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowIceCreamSandwich,
        ),
        301,
        9.0,
        49,
        4.3,
        129,
        8,
        1,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowEclair,
        ),
        326,
        16.0,
        36,
        6.0,
        337,
        6,
        7,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowCupcake,
        ),
        369,
        3.7,
        79,
        4.3,
        413,
        3,
        8,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowGingerbread,
        ),
        420,
        16.0,
        61,
        3.9,
        327,
        7,
        16,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowJellyBean,
        ),
        439,
        0.0,
        106,
        0.0,
        50,
        0,
        0,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowLollipop,
        ),
        456,
        0.2,
        110,
        0.0,
        38,
        0,
        2,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowHoneycomb,
        ),
        472,
        3.2,
        99,
        6.5,
        562,
        0,
        45,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowDonut,
        ),
        516,
        25.0,
        63,
        4.9,
        326,
        2,
        22,
      ),
      _Dessert(
        localizations.dataTableRowWithHoney(
          localizations.dataTableRowApplePie,
        ),
        582,
        26.0,
        77,
        7.0,
        54,
        12,
        6,
      ),
    ];
  }

  final BuildContext context;
  late List<_Dessert> _desserts;

  void _sort<T>(Comparable<T> Function(_Dessert d) getField, bool ascending) {
    _desserts.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
    notifyListeners();
  }

  int _selectedCount = 0;

  void updateSelectedDesserts(_RestorableDessertSelections selectedRows) {
    _selectedCount = 0;
    for (var i = 0; i < _desserts.length; i += 1) {
      var dessert = _desserts[i];
      if (selectedRows.isSelected(i)) {
        dessert.selected = true;
        _selectedCount += 1;
      } else {
        dessert.selected = false;
      }
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final format = NumberFormat.decimalPercentPattern(
    //  locale: GalleryOptions.of(context).locale.toString(),
      decimalDigits: 0,
    );
    assert(index >= 0);
    if (index >= _desserts.length) return null;
    final dessert = _desserts[index];
    return DataRow.byIndex(
      index: index,
      selected: dessert.selected,
      onSelectChanged: (value) {
        if (dessert.selected != value) {
          _selectedCount += value! ? 1 : -1;
          assert(_selectedCount >= 0);
          dessert.selected = value;
          notifyListeners();
        }
      },
      cells: [
        DataCell(Text(dessert.name)),
        DataCell(Text('${dessert.calories}')),
        DataCell(Text(dessert.fat.toStringAsFixed(1))),
        DataCell(Text('${dessert.carbs}')),
        DataCell(Text(dessert.protein.toStringAsFixed(1))),
        DataCell(Text('${dessert.sodium}')),
        DataCell(Text(format.format(dessert.calcium / 100))),
        DataCell(Text(format.format(dessert.iron / 100))),
      ],
    );
  }

  @override
  int get rowCount => _desserts.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;

  void _selectAll(bool? checked) {
    for (final dessert in _desserts) {
      dessert.selected = checked ?? false;
    }
    _selectedCount = checked! ? _desserts.length : 0;
    notifyListeners();
  }
}

class GalleryLocalizations {
}*/



