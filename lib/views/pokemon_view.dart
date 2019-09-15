import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokemon/redux/selected_pokemon_state.dart';
import 'package:flutter_pokemon/utils/strings.dart';

class PokemonView extends StatelessWidget {
  final PokemonDetail pokemon;

  const PokemonView({Key key, this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network('${pokemon.sprites['front_default']}',
              fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${Strings.capitalize(pokemon.name)}',
              style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20),
            ),
          ),
          Text.rich(TextSpan(
              text: 'Height',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                    text: ' - ${pokemon.height}',
                    style: TextStyle(fontWeight: FontWeight.normal))
              ]))
        ],
      ),
    );
  }
}
