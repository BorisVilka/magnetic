import 'package:Magnetic.am/web_view_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = context.watch<WebViewState>();
    double _w = MediaQuery.of(context).size.width;
    return Container(
      height: _w / 6.5,
      color: Colors.white,
      child: Column(
        children: [
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: Colors.white,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: state.goBack,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: _w / 14,
                  )),
              IconButton(
                  onPressed: state.reload,
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.black,
                    size: _w / 14,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}
