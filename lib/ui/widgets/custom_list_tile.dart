import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_code_gen/data/models/character.dart';
import 'package:rick_and_morty_code_gen/ui/widgets/character_status.dart';

class CustomListTile extends StatelessWidget {
  final Character character;

  const CustomListTile({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: MediaQuery.of(context).size.height / 7,
        color: const Color.fromRGBO(86, 86, 86, 0.8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: character.image,
              placeholder: (context, url) =>
                  const CircularProgressIndicator(color: Colors.grey),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.9,
                    child: Text(
                      character.name,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CharacterStatus(
                      liveState: character.status == 'Alive'
                          ? LiveState.alive
                          : character.status == 'Dead'
                              ? LiveState.dead
                              : LiveState.unknown),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Species: ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              character.species,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gender: ',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              character.gender,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
