import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_pokemon/redux/app_state.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redux/redux.dart';

part 'pokemons_state.g.dart';

final pokemonUrl = 'https://pokeapi.co/api/v2/pokemon';
final resultsKey = 'results';

@JsonSerializable()
class Pokemon {
  final String name;
  final String url;

  Pokemon(this.name, this.url);

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);
}

// state
@immutable
class PokemonsState {
  final List<Pokemon> pokemons;
  final bool isLoading;
  final Exception ex;

  const PokemonsState(
      {this.pokemons = const [], this.isLoading = false, this.ex});

  PokemonsState copyWith(
      {List<Pokemon> pokemons, bool isLoading, Exception ex}) {
    return PokemonsState(
        pokemons: pokemons ?? this.pokemons,
        isLoading: isLoading ?? this.isLoading,
        ex: ex ?? this.ex);
  }
}

// reducer
PokemonsState pokemonsReducer(PokemonsState state, action) {
  switch (action.runtimeType) {
    case FetchPokemons:
      return state.copyWith(isLoading: true);
    case AddPokemons:
      if (action.ex == null)
        return state.copyWith(
            pokemons: action.payload, isLoading: false, ex: null);

      return state.copyWith(ex: action.ex, isLoading: false);
  }
  return state;
}

// actions
class FetchPokemons {}

class AddPokemons {
  final List<Pokemon> payload;
  final Exception ex;

  AddPokemons({this.payload, this.ex});
}

// thunks
loadPokemons(Client client) {
  return (Store<AppState> store) async {
    store.dispatch(FetchPokemons());
    try {
      final res = await client.get(pokemonUrl);
      if (res.statusCode == HttpStatus.ok) {
        final pokemons = jsonDecode(res.body)[resultsKey];
        store.dispatch(AddPokemons(
            payload:
                List<Pokemon>.from(pokemons.map((i) => Pokemon.fromJson(i)))));
      } else {
        throw HttpException(res.reasonPhrase);
      }
    } on Exception catch (e) {
      store.dispatch(AddPokemons(ex: e));
    }
  };
}
