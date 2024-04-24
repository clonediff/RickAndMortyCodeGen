import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rick_and_morty_code_gen/bloc/character_bloc.dart';
import 'package:rick_and_morty_code_gen/data/models/character.dart';
import 'package:rick_and_morty_code_gen/ui/widgets/custom_list_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late CharactersResponse _currentResponse;
  List<Character> _currentCharacters = [];
  int _currentPage = 1;
  String _currentSearchString = '';

  final RefreshController refreshController = RefreshController();
  bool _isPagination = false;

  Timer? searchDebounce;

  @override
  void initState() {
    if (_currentCharacters.isEmpty) {
      context
          .read<CharacterBloc>()
          .add(const CharacterEvent.fetch(name: '', page: 1));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CharacterBloc>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 15, bottom: 6, left: 16, right: 16),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(86, 86, 86, 0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              hintText: 'Search Name',
              hintStyle: const TextStyle(color: Colors.white),
            ),
            onChanged: (value) {
              _currentPage = 1;
              _currentCharacters = [];
              _currentSearchString = value;

              searchDebounce?.cancel();
              searchDebounce = Timer(const Duration(milliseconds: 500), () {
                context
                    .read<CharacterBloc>()
                    .add(CharacterEvent.fetch(name: value, page: 1));
              });
            },
          ),
        ),
        Expanded(
          child: state.when(
            loading: () => !_isPagination
                ? const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Loading...'),
                      ],
                    ),
                  )
                : _customListView(_currentCharacters),
            loaded: (characterLoaded) {
              _currentResponse = characterLoaded;
              if (_isPagination) {
                _currentCharacters.addAll(_currentResponse.results);
                refreshController.loadComplete();
                _isPagination = false;
              } else {
                _currentCharacters = _currentResponse.results.toList();
              }
              return _currentCharacters.isNotEmpty
                  ? _customListView(_currentCharacters)
                  : const SizedBox();
            },
            error: () => const Text('Nothing found...'),
          ),
        ),
      ],
    );
  }

  Widget _customListView(List<Character> curCharacters) {
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: () {
        _isPagination = true;
        _currentPage++;
        if (_currentPage <= _currentResponse.info.pages) {
          context.read<CharacterBloc>().add(CharacterEvent.fetch(
              name: _currentSearchString, page: _currentPage));
        } else {
          refreshController.loadNoData();
        }
      },
      child: ListView.separated(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
          child: CustomListTile(
            character: curCharacters[index],
          ),
        ),
        separatorBuilder: (_, index) => const SizedBox(height: 5),
        itemCount: curCharacters.length,
        shrinkWrap: true,
      ),
    );
  }
}
