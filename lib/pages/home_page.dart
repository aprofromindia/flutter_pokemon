import 'package:flutter/material.dart';
import 'package:flutter_pokemon/generated/i18n.dart';
import 'package:flutter_pokemon/pages/detail_page.dart';
import 'package:flutter_pokemon/providers/app_provider.dart';
import 'package:flutter_pokemon/redux/app_state.dart';
import 'package:flutter_pokemon/redux/pokemons_state.dart';
import 'package:flutter_pokemon/redux/pokemons_state.dart' as ps;
import 'package:flutter_pokemon/redux/selected_pokemon_state.dart' as sps;
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

  _showAlert(BuildContext context, String s) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(S.of(context).error),
            content: Text(s),
            actions: <Widget>[
              FlatButton(
                child: Text(S.of(context).ok),
                onPressed: Navigator.of(context).pop,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _HomeVM>(
        onInitialBuild: (vm) => vm.loadPokemons(),
        converter: (store) => _HomeVM.fromStore(store),
        onWillChange: (vm) {
          if (vm.ex != null) _showAlert(context, vm.ex.toString());
        },
        builder: (_, vm) {
          return Scaffold(
              appBar: AppBar(title: Text('Pokemons')),
              body: SafeArea(
                  child: vm.isLoading
                      ? _showLoading()
                      : (vm.ex == null ? _showList(vm) : Center())));
        });
  }
}

class _HomeVM {
  final List<Pokemon> pokemons;
  final bool isLoading;
  final Exception ex;
  final Function(int) selectPokemon;
  final Function() loadPokemons;

  _HomeVM.fromStore(Store<AppState> store)
      : this.pokemons = store.state.pokemonsState.pokemons,
        this.isLoading = store.state.pokemonsState.isLoading,
        this.ex = store.state.pokemonsState.ex,
        this.selectPokemon =
            ((i) => store.dispatch(sps.selectPokemon(i, AppProvider.client))),
        this.loadPokemons =
            (() => store.dispatch(ps.loadPokemons(AppProvider.client)));
}
