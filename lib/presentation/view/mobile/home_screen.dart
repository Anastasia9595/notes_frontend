import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_laravel/buisness_logic/model/note.dart';
import 'package:notes_laravel/buisness_logic/select_note_cubit/select_note_cubit.dart';

import 'package:notes_laravel/helpers/constants.dart';
import 'package:notes_laravel/presentation/components/custom_alertdialog.dart';
import 'package:notes_laravel/presentation/components/listtilenote_component.dart';
import 'package:notes_laravel/presentation/widgets/floatinaction_button_widget.dart';

import '../../../buisness_logic/notes_cubit/note_cubit.dart';
import '../../../buisness_logic/notes_cubit/note_state.dart';
import '../../../buisness_logic/login_cubit/login_cubit.dart';
import '../../../helpers/utils.dart';

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});
  Widget buildSwipeLeftAction() => Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      );
  Widget buildSwipeRightAction() => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 32,
        ),
      );

  bool isNoteSelected(BuildContext context, Note note) {
    if (context.read<NoteCubit>().state.selectedNotestoDeleteList != null) {
      return context.read<NoteCubit>().state.selectedNotestoDeleteList?.contains(note) ?? false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // context.read<NoteCubit>().updateNotesLocal(context.read<LoginCubit>().state.user.token);

    return Scaffold(
        backgroundColor: kBackgroundColorDark,
        appBar: AppBar(
          backgroundColor: kBackgroundColorDark,
          elevation: 0,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // String token = context.read<LoginCubit>().state.user.token;
                // context.read<NoteCubit>().deleteMultipleNotesLocal(token);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                return Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'All Notes ${state.notesList.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.notesList.length,
                    itemBuilder: (context, index) {
                      if (state.notesList.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else {
                        return Dismissible(
                            background: buildSwipeLeftAction(),
                            secondaryBackground: buildSwipeRightAction(),
                            confirmDismiss: (direction) => Future.delayed(
                                  const Duration(milliseconds: 200),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => CustomAlrtDialog(
                                      backgroundColor: Colors.blueGrey.shade100,
                                      iconBackgroundColor: Colors.blueGrey.shade100,
                                      icon: Icons.delete,
                                      title: 'Delete Note',
                                      titleColor: Colors.black,
                                      content: const Text('Are you sure you want to delete this note?'),
                                      functions: [
                                        () {
                                          Navigator.of(context).pop(false);
                                        },
                                        () {
                                          String token = context.read<LoginCubit>().state.user.token;
                                          context.read<NoteCubit>().deleteNoteLocal(state.notesList[index].id, token);
                                          Navigator.of(context).pop(true);
                                        }
                                      ],
                                      functionNames: const ['No', 'Yes'],
                                    ),
                                  ),
                                ),
                            key: Key(state.notesList[index].toString()),
                            child: InkWell(
                              onTap: () {
                                // context.read<NoteCubit>().setNoteToSelectedFromList(state.notesList[index]);
                                context.read<NoteCubit>().addNoteToRemovedList(state.notesList[index]);
                                log(
                                  'note added to removed list: ${state.selectedNotestoDeleteList?.length} ${state.selectedNotestoDeleteList?.map((e) => e.id).toList()}',
                                );
                              },
                              child: ListTileNoteComponent(
                                note: state.notesList[index],
                              ),
                            ));
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: const CustomFloatinActionButton(
          backgroundcolor: Colors.amber,
          icon: Icons.add,
          iconcolor: Colors.black,
        ));
  }
}
