import 'package:dartz/dartz.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import '../../../../application/notes/note_form/note_form_bloc.dart';
import '../misc/todo_item_presentation_classes.dart';
import '../../misc/build_context_x.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      listener: (context, state) {
        if (state.note.todos.isFull) {
          FlushbarHelper.createAction(
            message: "Want longer lists? Activate premium 🤑",
            button: FlatButton(
              onPressed: () {},
              child: const Text(
                'Buy now!',
                style: TextStyle(
                  color: Colors.yellow,
                ),
              ),
            ),
            duration: const Duration(seconds: 5),
          ).show(context);
        }
      },
      child: Consumer<FormTodos>(
        builder: (context, formTodos, child) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: formTodos.value.size,
            itemBuilder: (context, index) {
              return TodoTile(
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}

class TodoTile extends HookWidget {
  final int index;

  const TodoTile({
    @required this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo =
        context.fromTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());

    return ListTile(
      leading: Checkbox(
        value: todo.done,
        onChanged: (value) {
          context.fromTodos = context.fromTodos.map(
            (listTodo) =>
                listTodo == todo ? todo.copyWith(done: value) : listTodo,
          );
          context.bloc<NoteFormBloc>().add(NoteFormEvent.todosChanged(
                context.fromTodos,
              ));
        },
      ),
      title: Text(todo.name),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          context.fromTodos = context.fromTodos.minusElement(todo);
          context.bloc<NoteFormBloc>().add(
                NoteFormEvent.todosChanged(context.fromTodos),
              );
        },
      ),
    );
  }
}
