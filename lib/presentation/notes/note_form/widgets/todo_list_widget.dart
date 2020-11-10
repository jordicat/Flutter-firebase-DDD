import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_ddd_notes/domain/notes/value_objects.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
import 'package:kt_dart/kt.dart';
import 'package:provider/provider.dart';

import '../../../../application/notes/note_form/note_form_bloc.dart';
import '../../misc/build_context_x.dart';
import '../misc/todo_item_presentation_classes.dart';

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
          return ImplicitlyAnimatedReorderableList<TodoItemPrimitive>(
            shrinkWrap: true,
           //  removeDuration: const Duration(),
            items: formTodos.value.asList(),
            areItemsTheSame: (oldItem, newItem) => oldItem.id == newItem.id,
            onReorderFinished: (item, from, to, newItems) {
              context.fromTodos = newItems.toImmutableList();
              context
                  .bloc<NoteFormBloc>()
                  .add(NoteFormEvent.todosChanged(context.fromTodos));
            },
            itemBuilder: (context, animation, item, index) {
              return Reorderable(
                builder: (context, animation, inDrag) {
                  return ScaleTransition(
                    scale:
                        Tween<double>(begin: 1, end: 1.05).animate(animation),
                    child: TodoTile(
                      index: index,
                      elevation: animation.value * 4,
                    ),
                  );
                },
                key: ValueKey(item.id),
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
  final double elevation;

  const TodoTile({
    @required this.index,
    double elevation,
    Key key,
  })  : elevation = elevation ?? 0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final todo =
        context.fromTodos.getOrElse(index, (_) => TodoItemPrimitive.empty());
    final textEditingController = useTextEditingController(text: todo.name);

    return Slidable(
      actionPane: const SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            context.fromTodos = context.fromTodos.minusElement(todo);
            context
                .bloc<NoteFormBloc>()
                .add(NoteFormEvent.todosChanged(context.fromTodos));
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 2,
        ),
        child: Material(
          elevation: elevation,
          animationDuration: const Duration(milliseconds: 50),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: Checkbox(
                value: todo.done,
                onChanged: (value) {
                  context.fromTodos = context.fromTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(done: value)
                        : listTodo,
                  );
                  context.bloc<NoteFormBloc>().add(NoteFormEvent.todosChanged(
                        context.fromTodos,
                      ));
                },
              ),
              trailing: const Handle(
                child: Icon(Icons.list),
              ),
              title: TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Todo',
                  counterText: '',
                  border: InputBorder.none,
                ),
                maxLength: TodoName.maxLength,
                controller: textEditingController,
                onChanged: (value) {
                  context.fromTodos = context.fromTodos.map(
                    (listTodo) => listTodo == todo
                        ? todo.copyWith(name: value)
                        : listTodo,
                  );
                  context.bloc<NoteFormBloc>().add(NoteFormEvent.todosChanged(
                        context.fromTodos,
                      ));
                },
                validator: (_) {
                  return context
                      .bloc<NoteFormBloc>()
                      .state
                      .note
                      .todos
                      .value
                      .fold(
                        (failure) => null,
                        (todoList) => todoList[index].name.value.fold(
                              (f) => f.maybeMap(
                                empty: (_) => 'Cannot be empty',
                                exceedingLength: (_) => 'Too long',
                                multiline: (_) => 'Has to be single line',
                                orElse: () => null,
                              ),
                              (_) => null,
                            ),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
