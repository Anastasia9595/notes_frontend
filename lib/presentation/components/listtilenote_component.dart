import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_laravel/buisness_logic/select_note_cubit/select_note_cubit.dart';
import 'package:notes_laravel/helpers/utils.dart';

import '../../buisness_logic/model/note.dart';

import '../../helpers/constants.dart';

class ListTileNoteComponent extends StatelessWidget {
  const ListTileNoteComponent({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: kBackgroundColorDark,
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.grey.shade600),
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.20,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      overflow: TextOverflow.ellipsis,
                      note.title,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 10, top: 5),
                        child: Text(
                          note.description,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        )),
                  ),
                  Expanded(
                    child: IconButton(
                        onPressed: () {},
                        icon: note.isFavorite
                            ? const Icon(
                                Icons.star,
                                color: Colors.white,
                              )
                            : const Icon(
                                Icons.star_border_outlined,
                                color: Colors.white,
                              )),
                  )
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5, bottom: 10),
                    child: Text(
                      Utils.convertDateTimeDisplay(note.updatedAt),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10.0, bottom: 10),
                    child: Icon(
                      Icons.access_time,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        BlocBuilder<SelectNoteCubit, SelectNoteState>(
          builder: (context, state) {
            return Visibility(
              visible: note.isNoteSelected && state.isNoteSelected ? true : false,
              child: const Icon(Icons.check_circle, color: Colors.red, size: 30),
            );
          },
        )
      ],
    );
  }
}
