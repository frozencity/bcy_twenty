import 'package:bcy_twenty/data/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarcampSponsor extends StatefulWidget {
  @override
  _BarcampSponsorState createState() => _BarcampSponsorState();
}

class _BarcampSponsorState extends State<BarcampSponsor> {

  var sponsorStream = Consumer<List<Sponsor>>(
      builder: (_,spList,__){

        if (spList==null) {return CircularProgressIndicator();}

        var _SponsorTitleList = spList.map((sp){
          return sp.title;
        }).toList();

        var _SponsorImageList = spList.map((sp){
          return sp.image;
        }).toList();

        return ListView.builder(
          itemCount: _SponsorTitleList.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            _SponsorTitleList[index],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          margin: EdgeInsets.all(16),
                        ),
                        Container(
                          width: double.infinity,
                          height: 300,
                          padding: EdgeInsets.all(16),
                          child: Image(
                            image: NetworkImage(
                              _SponsorImageList[index],
                            ),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 2.0),
                        ]),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

  @override
  Widget build(BuildContext context) {
    return sponsorStream;
  }
}
