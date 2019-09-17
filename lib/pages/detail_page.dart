import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pokemon/redux/app_state.dart';
import 'package:flutter_pokemon/redux/selected_pokemon_state.dart';
import 'package:flutter_pokemon/utils/strings.dart';
import 'package:flutter_pokemon/views/pokemon_view.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class DetailPage extends StatelessWidget {
  Widget _showLoader() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _showPokemonView(PokemonDetail pokemon) {
    return PokemonView(pokemon: pokemon);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _DetailVM>(
        converter: (store) => _DetailVM.fromStore(store),
        builder: (_, vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text('${Strings.capitalize(vm.title)}'),
            ),
            body: SafeArea(
              child: Center(
                child:
                    vm.isLoading ? _showLoader() : _showPokemonView(vm.pokemon),
              ),
            ),
          );
        });
  }
}

class _DetailVM {
  final String title;
  final PokemonDetail pokemon;
  final bool isLoading;
  final Exception ex;

  _DetailVM.fromStore(Store<AppState> store)
      : this.title = store.state.selectedPokemonState.title,
        this.pokemon = store.state.selectedPokemonState.pokemon,
        this.isLoading = store.state.selectedPokemonState.isLoading,
        this.ex = store.state.selectedPokemonState.ex;
}
