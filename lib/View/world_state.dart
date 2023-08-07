import 'package:covid_tracker/Model/WorldStateModel.dart';
import 'package:covid_tracker/Services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import 'countries_list.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({Key? key}) : super(key: key);

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
      duration: const Duration( seconds: 5),
      vsync: this)..repeat();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  final colorList = <Color> [
   const  Color(0xff4285F4),
   const  Color(0xff1aa260),
   const  Color(0xffde5246)
  ];
  @override
  Widget build(BuildContext context) {
    StateServices stateServices = StateServices();
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(' Covid-19' , style: TextStyle( fontWeight: FontWeight.w900 , fontStyle: FontStyle.italic, fontSize: 25),)
      ),
      body: SafeArea(
        
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
        children: [
          SizedBox( height: MediaQuery.of(context).size.height * .01,),

          FutureBuilder(
            future: stateServices.fetchWorldStateRecords(),
              builder: (context ,AsyncSnapshot<WorldStateModel> snapshot ){
            if(!snapshot.hasData){
              return Expanded(
                flex: 1,
                  child: SpinKitFadingCircle(
                    color:  Colors.white,
                    size:  50.0,
                    controller: _controller,
                  )
              );
            }
            else{
            return Column(
              children: [
                PieChart(
                  dataMap:  {
                    " Total ": double.parse(snapshot.data!.cases!.toString()),
                    " Recovered ": double.parse(snapshot.data!.recovered!.toString()),
                    " Deaths " : double.parse(snapshot.data!.deaths!.toString()),
                  },
                  chartValuesOptions:  const ChartValuesOptions(
                    showChartValuesInPercentage: true,
                  ),
                  chartRadius: MediaQuery.of(context).size.width/3.2,
                  legendOptions:const  LegendOptions(
                      legendPosition: LegendPosition.left
                  ),
                  animationDuration:const  Duration(milliseconds: 1300),
                  chartType: ChartType.ring,
                  colorList: colorList,
                ),
                Padding(
                  padding:   EdgeInsets.symmetric( vertical: MediaQuery.of(context).size.height * .06),
                  child: Card(
                    child: Column(
                      children: [
                        ReusableRow(title: 'Total ', value: snapshot.data!.cases.toString()),
                        ReusableRow(title: ' Recovered  ', value: snapshot.data!.recovered.toString()),
                        ReusableRow(title: 'Deaths  ', value: snapshot.data!.deaths.toString()),
                        ReusableRow(title: 'Active  ', value: snapshot.data!.active.toString()),
                        ReusableRow(title: 'critical', value: snapshot.data!.critical.toString()),
                        ReusableRow(title: ' Today Deaths  ', value: snapshot.data!.todayDeaths.toString()),
                        ReusableRow(title: ' Today Recovered ', value: snapshot.data!.todayRecovered.toString()),

                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap : (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  const CountriesList()) );
    },
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color:  const Color(0xff1aa260),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Center(
                        child: Text(' Track Countries '),
                      )
                  ),
                ),
              ],
            );
            }
            }),
        ],
      ),
          )),
    );
  }
}
class ReusableRow extends StatelessWidget {
  String title , value ;
   ReusableRow({Key? key , required this.title , required this.value}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5 , right: 5 , bottom: 5, top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(title),
            Text(value),
            ],
          ),
          const SizedBox( height: 2),
         const  Divider()
        ],
      ),
    );
  }
}
