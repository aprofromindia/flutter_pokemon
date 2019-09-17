import 'package:flutter/foundation.dart';
import 'package:flutter_pokemon/redux/pokemons_state.dart';
import 'package:flutter_pokemon/redux/selected_pokemon_state.dart';

@immutable
class AppState {
  final PokemonsState pokemonsState;
  final SelectedPokemonState selectedPokemonState;

  AppState(
      {this.pokemonsState = const PokemonsState(),
      this.selectedPokemonState = const SelectedPokemonState()});
}

AppState appState(AppState state, action) {
  return AppState(
      pokemonsState: pokemonsReducer(state.pokemonsState, action),
      selectedPokemonState:
          selectedPokemonReducer(state.selectedPokemonState, action));
}
