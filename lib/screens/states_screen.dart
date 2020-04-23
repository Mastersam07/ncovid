import 'package:flutter/material.dart';
import 'package:tojuwa/utils/constants.dart';

bool isPinned = false;
bool isSearching = false;

class States extends StatefulWidget {
  States({this.statesList});
  final List statesList;
  @override
  _StatesState createState() => _StatesState();
}

class _StatesState extends State<States> {
  List filteredStates = [];
  final searchInputController = TextEditingController();

  void findState(value) {
    filteredStates = widget.statesList
        .where(
          (state) =>
          (state['state'].toLowerCase()).contains(value.toLowerCase()),
    )
        .toList();
    // assign filteredCountries to a list of all the countries containing the entered query
  }

// toggle appbar icon
  GestureDetector toggleAppBarIcon() {
    GestureDetector displayedIcon;
    if (isSearching) {
      displayedIcon = GestureDetector(
        child: Icon(
          Icons.cancel,
        ),
        onTap: () {
          setState(() {
            isSearching = !isSearching;
            filteredStates = widget.statesList;
            // reassign filteredCountries to the initial value when the searchbar is collapsed
          });
        },
      );
    } else {
      displayedIcon = GestureDetector(
        child: Icon(
          Icons.search,
        ),
        onTap: () {
          setState(() {
            isSearching = !isSearching;
          });
        },
      );
    }
    return displayedIcon;
  }

  @override
  void initState() {
    filteredStates = widget.statesList;
    // assign countriesList to a mutable variable so that I can edit it when changing states
    filteredStates.forEach((state) {
      state['isFollowed'] = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
//            color: widget.isDark ? kBoxDarkColor : Colors.grey[100],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.search),
              SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: searchInputController,
                  autofocus: true,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Search state...',
                  ),
                  onChanged: (value) {
                    setState(() {
                      value == ''
                          ? filteredStates = widget.statesList
                          : findState(
                          (value.toLowerCase()).capitalize(),);
                    });
                  },
                ),
              )
            ],
          ),
        )
            : Text('Affected Countries'),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: toggleAppBarIcon(),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: filteredStates.length,
              itemBuilder: (context, index) {
                var state = filteredStates[index];
                return StateDetails(
//                  isDark: widget.isDark,
                  state: state,
                  follow: () {
                    setState(() {
                      state['isFollowed'] = !state['isFollowed'];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StateDetails extends StatelessWidget {
  StateDetails(
      {@required this.state, @required this.follow});

  final Map state;
  final Function follow;
//  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
//        color: isDark ? kBoxDarkColor : kBoxLightColor,
        borderRadius: kBoxesRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image(
                image: NetworkImage(state['stateInfo']['flag']),
                height: 20,
                width: 25,
              ),
              Text(
                state['state'].toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 5),
          Divider(color: Colors.blueGrey[200], thickness: .5),
          SizedBox(height: 15),
          Text('Total cases: ${state['cases']}',
              style: TextStyle(fontSize: 18)),
          Text('Total in admission: ${state['admitted']}',
              style: TextStyle(fontSize: 18)),
          Text('Total recovered: ${state['recovered']}',
              style: TextStyle(fontSize: 18)),
          Text('Today deaths: ${state['deaths']}',
              style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
