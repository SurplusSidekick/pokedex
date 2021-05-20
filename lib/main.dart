import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pokedex/Pokemon.dart';
import 'package:pokedex/pokemondetail.dart';

void main() => runApp(MaterialApp(
      title: "Pokedex",
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url = Uri.https("raw.githubusercontent.com",
      "Biuni/PokemonGO-Pokedex/master/pokedex.json");
  PokeHub pokeHub;
  Set filteredTypes = Set();

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  handleSearch(String val) {
    deleteFilter();
    print(val.length);
    if(val.length >= 3) {
      setState(() {
        pokeHub.filterByName(val);
      });
    } else {
      setState(() {
        pokeHub.filterByName('');
      });
    }
  }

  deleteFilter() {
    pokeHub.restoreFrombackup();
    filteredTypes = Set();
    setState(() {});
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    setState(() {});
  }

  navigateAndDisplayDetails(BuildContext context, Pokemon poke) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PokeDetail(pokemon: poke)),
    );

    // After the details screen add selected types to filterlist
    // and show the filtered result.
    print(result);

    //add filter to Set
    if (result != null) {
      filteredTypes.add(result);
    }

    setState(() => pokeHub.filterByType(filteredTypes));
  }

  Icon customIcon = Icon(Icons.search);
  Widget customSearch = Text("Pokedex");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (this.customIcon.icon == Icons.search) {
                  print("here");
                  this.customIcon = Icon(Icons.cancel);
                  this.customSearch = TextField(
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    onChanged: (val) => handleSearch(val),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.white)),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  );
                } else {
                  this.customIcon = Icon(Icons.search);
                  this.customSearch = Text("Pokedex");
                }
              });
            },
            icon: customIcon,
          )
        ],
        centerTitle: true,
        title: customSearch,
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: filteredTypes
                        .map(
                          (item) => FilterChip(
                              backgroundColor: Colors.redAccent,
                              label: Text(item),
                              onSelected: (b) {
                                Navigator.pop(context, item);
                              }),
                        )
                        .toList(),
                  ),
                  Padding(
                    padding: filteredTypes.length > 0
                        ? EdgeInsets.fromLTRB(0.0, 50, 0.0, 0.0)
                        : EdgeInsets.all(0.0),
                    child: GridView.count(
                        crossAxisCount: 2,
                        children: pokeHub.pokemon
                            .map(
                              (poke) => Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: InkWell(
                                    onTap: () => navigateAndDisplayDetails(
                                        context, poke),
                                    child: Hero(
                                      tag: poke.img,
                                      child: Card(
                                        elevation: 3.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                              height: 100.0,
                                              width: 100.0,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          poke.img))),
                                            ),
                                            Text(poke.name,
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            )
                            .toList()),
                  )
                ],
              ),
            ),
      //drawer: Drawer(),
      floatingActionButton: filteredTypes.length > 0 ? FloatingActionButton(
        onPressed: () => deleteFilter(),
        backgroundColor: Colors.cyan,
        child: Icon(Icons.delete_forever),
      ) : Container(),
    );
  }
}
