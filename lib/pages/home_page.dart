import 'package:flutter/material.dart';
import 'package:flutter_pokemon/pages/detail_page.dart';
import 'package:flutter_pokemon/redux/app_state.dart';
import 'package:flutter_pokemon/redux/pokemons_state.dart';
import 'package:flutter_pokemon/redux/pokemons_state.dart' as ps;
import 'package:flutter_pokemon/redux/selected_pokemon_state.dart' as sp;
import 'package:flutter_pokemon/utils/strings.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomePage extends StatelessWidget {
  Widget _showLoading() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _showList(_HomeVM vm) {
    return ListView.builder(
        itemCount: vm.pokemons.length,
        itemBuilder: (context, int i) {
          return Card(
            child: ListTile(
              title: Text('${Strings.capitalize(vm.pokemons[i].name)}'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () {
                vm.selectPokemon(i);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DetailPage()));
              },
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _HomeVM>(
        onInitialBuild: (vm) => vm.loadPokemons(),
        converter: (store) => _HomeVM.fromStore(store),
        builder: (context, vm) {
          return Scaffold(
              appBar: AppBar(title: Text('Pokemons')),
              body: SafeArea(
                  child: vm.isLoading ? _showLoading() : _showList(vm)));
        });
  }
}

class _HomeVM {
  final List<Pokemon> pokemons;
  final bool isLoading;
  final Function(int) selectPokemon;
  final Function() loadPokemons;

  _HomeVM.fromStore(Store<AppState> store)
      : this.pokemons = store.state.pokemonsState.pokemons,
        this.isLoading = store.state.pokemonsState.isLoading,
        this.selectPokemon = ((i) => store.dispatch(sp.selectPokemon(i))),
        this.loadPokemons = (() => store.dispatch(ps.loadPokemons));
}
