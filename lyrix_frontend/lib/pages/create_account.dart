import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Name'),
          _textEntry('ex. John Doe'),
          _label('Preffered Username'),
          _textEntry(''),
          _label('New Password'),
          _textEntry('Make it strong!'),

          Container(
            margin: EdgeInsets.only(top: 20, left: 180),
            alignment: Alignment.center,
            height: 45,
            width: 130,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.green
                ]
              ),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text(
              'Confirm',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
          )
        ],
      ),
    );
  }

  Column _label(String label){
    return Column(
            children: [
              SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left:30),
                child: Text(
                  label,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 49, 49, 49),
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  ),
                )
              )
            ],
    );
  }

  Container _textEntry(String example){
    return Container(
            margin: EdgeInsets.only(top: 0, left: 20, right: 20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 161, 146, 146),
                  blurRadius: 10,
                  spreadRadius: 0.0,
                )
              ]
            ),
            child: TextField(
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(15),
                hintText: example,
                hintStyle: TextStyle(
                  color: const Color.fromARGB(255, 194, 186, 186),
                ),
                /*prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset('assets/icons/Search.svg'),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset('assets/icons/Filter.svg'),
                ),
                */
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            )
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        "Create Account",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      leading: GestureDetector(
        onTap: (){
          
        },
        child: Container(
          margin: EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 20,
            width: 20,
          ),
        )

      ),
      actions: [
        GestureDetector(
          onTap: (){
            
          },
          child: Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            width: 15,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              'assets/icons/dots.svg',
              height: 20,
              width: 20,
            ),
          ),
        )
      ],
    );
  }
}