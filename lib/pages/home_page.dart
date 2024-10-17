import 'package:flutter/material.dart';
import 'package:tes2_project/components/container1.dart';
import 'package:tes2_project/components/container2.dart';
import 'package:tes2_project/components/container3.dart';
import 'package:tes2_project/components/container4.dart';
import 'package:tes2_project/components/costumerService.dart';
import 'package:tes2_project/components/dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          bottom: const TabBar(

            tabs: [
              Tab(child: Text("Control Center",style: TextStyle(
                fontSize: 11,
              ),), icon: Icon(Icons.admin_panel_settings),),
              Tab(child: Text("Energy Dashboard",style: TextStyle(
                  fontSize: 11,
                  ),
                ), icon: Icon(Icons.price_change)
              ),
              Tab(child: Text("Costumer Service",style: TextStyle(
                fontSize: 11,
              ),
              ), icon: Icon(Icons.headset_mic)),
            ],
          ),
          title: const Center(child: Text('Home Page')),

        ),
        body: TabBarView(
          children: [
            GridView.count(
              crossAxisCount: 2,
              children: const [
                Container1(),
                Container2(),
                Container3(),
                Container4(),
              ],
            ),
            const Dashboard(),
            const CostumerService(),
          ],
        ),
      ),
    );
  }

}