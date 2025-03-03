import 'package:flutter/material.dart';
import 'package:whatshop_vendor/tools/colors.dart';

import '../tools/variables.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //double widthSize = getWidthSize(context);
    //double heightSize = getHeightSize(context);
    int crossAxisCount = getCrossAxisCount(context);
    double childAspectRatio = getChildAspectRatio(context);

    return Scaffold(
        body: SafeArea(child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.view_headline)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.remove_red_eye_rounded)),
                ],
              ),
              Divider(height: 1,color: Colors.grey,),
              SizedBox(height: 10,),
              Text('Xosh Geldiniz',style: TextStyle(
                  color: grayText,
                  fontSize: 15,
                  fontWeight: FontWeight.w100
              ),),
              SizedBox(height: 20,),


              Text('Fatima Ahmadova',style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mehsullarim',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                  ),),
                  GestureDetector(
                    onTap: (){},
                    child: Row(
                      children: [
                        Text('Vaxta gore',style: TextStyle(
                            fontSize: 15,
                            color: grayText,
                            fontWeight: FontWeight.w100
                        ),),
                        Icon(Icons.keyboard_arrow_down_rounded)
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: childAspectRatio
                      ),
                      itemCount: 10,
                      itemBuilder: (context,index){
                        return Container(
                          color: Colors.lightBlueAccent,
                          height: 200,
                          width: 200,
                          child: Center(child: Text("mehsul")),
                        );
                      }),
                ),
              ),
            ],
          ),
        )));
  }
}
