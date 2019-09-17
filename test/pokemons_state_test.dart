import 'package:flutter_pokemon/redux/pokemons_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class MockClient extends Mock implements Client {}

void main() {
  group('Pokemons State', () {
    Store<PokemonsState> store;

    setUp(() {
      store = Store(pokemonsReducer,
          initialState: PokemonsState(), middleware: [thunkMiddleware]);
    });

    test('fetch pokemons shouled set isLoading to true', () {
      assert(store.state.isLoading == false);

      store.dispatch(FetchPokemons());

      expect(store.state.isLoading, true);
    });

    test('add pokemons when error, exception is not null', () {
      store.dispatch(AddPokemons(ex: Exception('test exception')));

      expect(store.state.ex, isNotNull);
      expect(store.state.pokemons, isEmpty);
    });

    test('add Pokemons success should add list of pokemons to the store', () {
      final client = MockClient();

      when(client.get(argThat(isInstanceOf<String>()))).thenAnswer((_) async =>
          Response(
              '{"results": [{"name": "p1", "url": "u1"}, {"name": "p2", "url": "u2"}]}',
              200));

      store.dispatch(loadPokemons(client));
      expect(store.state.pokemons.length, 2);
    });
  });
}
