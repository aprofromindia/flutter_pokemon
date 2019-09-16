import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:redux/redux.dart';

import 'app_state.dart';

part 'selected_pokemon_state.g.dart';

@JsonSerializable()
class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final Map<String, String> sprites;

  PokemonDetail(this.id, this.name, this.height, this.sprites);

  factory PokemonDetail.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailFromJson(json);
}

// state
@immutable
class SelectedPokemonState {
  final String title;
  final PokemonDetail pokemon;
  final bool isLoading;
  final Exception ex;

  const SelectedPokemonState(
      {this.title = '', this.pokemon, this.isLoading = true, this.ex});

  SelectedPokemonState copyWith(
      {String title, PokemonDetail pokemon, bool isLoading, Exception ex}) {
    return SelectedPokemonState(
        title: title ?? this.title,
        pokemon: pokemon ?? this.pokemon,
        isLoading: isLoading ?? this.isLoading,
        ex: ex ?? this.ex);
  }
}

// reducer
SelectedPokemonState selectedPokemonState(SelectedPokemonState state, action) {
  switch (action.runtimeType) {
    case PokemonSelected:
      return state.copyWith(title: action.payload.title, isLoading: true);
    case AddPokemonDetail:
      return state.copyWith(isLoading: false, pokemon: action.payload);
  }
  return state;
}

// actions
class PokemonSelected {
  final PokemonSelectedPayload payload;

  PokemonSelected(this.payload);
}

class PokemonSelectedPayload {
  final int index;
  final String title;

  PokemonSelectedPayload(this.index, this.title);
}

class AddPokemonDetail {
  final PokemonDetail payload;
  final Exception ex;

  AddPokemonDetail({this.payload, this.ex});
}

// thunks
selectPokemon(int i, Client client) {
  return (Store<AppState> store) async {
    store.dispatch(PokemonSelected(
        PokemonSelectedPayload(i, store.state.pokemonsState.pokemons[i].name)));
    try {
      var res = await client.get(store.state.pokemonsState.pokemons[i].url);
      if (res.statusCode == HttpStatus.ok) {
        store.dispatch(AddPokemonDetail(
            payload: PokemonDetail.fromJson(jsonDecode(res.body))));
      } else
        throw HttpException(res.reasonPhrase);
    } on Exception catch (ex) {
      store.dispatch(AddPokemonDetail(ex: ex));
    }
  };
}
