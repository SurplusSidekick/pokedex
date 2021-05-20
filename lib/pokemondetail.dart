import 'package:flutter/material.dart';
import 'package:pokedex/Pokemon.dart';

import 'main.dart';

class PokeDetail extends StatelessWidget {
  final Pokemon pokemon;

  PokeDetail({this.pokemon});

  bodyWidget(BuildContext context) => Stack(
        children: [
          Positioned(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width * .90,
            left: MediaQuery.of(context).size.width * .05,
            top: MediaQuery.of(context).size.height * .1,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 70.0,
                    ),
                    Text(
                      pokemon.name,
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                    Text("Height: ${pokemon.height}"),
                    Text("Weight: ${pokemon.weight}"),
                    Text(
                      "Types",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: pokemon.type
                          .map(
                            (item) => FilterChip(
                                backgroundColor: Colors.amber,
                                label: Text(item),
                                onSelected: (b) {
                                  Navigator.pop(context, item);
                                }),
                          )
                          .toList(),
                    ),
                    Text(
                      "Weakness",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 5.0,
                      runSpacing: 5.0,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: pokemon.weaknesses
                          .map((item) => FilterChip(
                              backgroundColor: Colors.red,
                              label: Text(
                                item,
                                style: TextStyle(color: Colors.white),
                              ),
                              onSelected: (b) {}))
                          .toList(),
                    ),
                    Text(
                      "Next Evolutions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    pokemon.nextEvolution == null
                        ? Text("-- Final Form --")
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: pokemon.nextEvolution
                                .map((item) => FilterChip(
                                    backgroundColor: Colors.green,
                                    label: Text(
                                      item.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onSelected: (b) {}))
                                .toList(),
                          )
                  ],
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Hero(
                  tag: pokemon.img,
                  child: Container(
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(pokemon.img))))))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.cyan,
        title: Text(pokemon.name),
      ),
      body: bodyWidget(context),
    );
  }
}
