import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_code_gen/bloc/character_bloc.dart';
import 'package:rick_and_morty_code_gen/data/repositories/character_repo.dart';
import 'package:rick_and_morty_code_gen/ui/pages/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;
  final repository = const CharacterRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: Text(
          title,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body: BlocProvider(
        create: (context) => CharacterBloc(characterRepo: repository),
        child: Container(
            decoration: const BoxDecoration(color: Colors.black87),
            child: const SearchPage()),
      ),
    );
  }
}
