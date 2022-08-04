
import 'package:equatable/equatable.dart';

import '../../models/task.dart';
import '../bloc_exports.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);

  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit){
    final state = this.state;
    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..add(event.task),
      removedTasks: state.removedTasks,
    ));
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit){
    final state = this.state;
    final task = event.task;
    final int index =state.pendingTasks.indexOf(task);
    List<Task> allTasks = List.from(state.pendingTasks)..remove(task);
    task.isDone == false
     ? allTasks.insert(index, task.copyWith(isDone: true))
     : allTasks.insert(index, task.copyWith(isDone: false));
  
  emit(TasksState(pendingTasks: allTasks,
  removedTasks: state.removedTasks));
  }
  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit){
        final state = this.state;
    emit(TasksState(pendingTasks: state.pendingTasks,
    removedTasks: List.from(state.removedTasks)..remove(event.task),
    ));
  }
  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit){
        final state = this.state;
    emit(TasksState(pendingTasks: List.from(state.pendingTasks)..remove(event.task),
    removedTasks: List.from(state.removedTasks)..add(event.task.copyWith(isDeleted: true)), //making isDeleted true
    ));
  }
  
  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }
  
  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }
}
