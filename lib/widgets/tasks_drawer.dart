import 'package:flutter/material.dart';

import '../blocs/bloc_exports.dart';
import '../blocs/switch_bloc/switch_bloc.dart';
import '../screens/recycle_bin_screen.dart';
import '../screens/tabs_screen.dart';
import '../test_data.dart';

class TasksDrawer extends StatelessWidget {
  const TasksDrawer({Key? key}) : super(key: key);

  _switchToDarkTheme(BuildContext context, bool isDarkTheme) {
    if (isDarkTheme) {
      context.read<SwitchBloc>().add(SwitchOnEvent());
    } else {
      context.read<SwitchBloc>(). add(SwitchOffEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Text(
                'Task Drawer',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            BlocBuilder<TasksBloc, TasksState>(
              builder: ((context, state) {
                return GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    TabsScreen.path,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.folder_special),
                    title: const Text('My Tasks'),
                    trailing: Text(
                      '${state.pendingTasks.length} | ${state.completedTasks.length}',
                    ),
                  ),
                );
              }),
            ),
            const Divider(),
            BlocBuilder<TasksBloc, TasksState>(
              builder: ((context, state) {
                return GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(
                    context,
                    RecycleBinScreen.path,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Recycle Bin'),
                    trailing: Text('${state.removedTasks.length}'),
                  ),
                );
              }),
            ),
            const Divider(),
            const Expanded(child: SizedBox()),
              BlocBuilder<SwitchBloc, SwitchState>(
                builder: (context, state) {
                  return ListTile(
                    leading: Switch(
                      value: state.switchValue,
                      onChanged: (newValue) =>
                      _switchToDarkTheme(context, newValue),
                    ),
                    title: state.switchValue ? const Text('Switch to Light Theme') : const Text('Switch to Dark Theme'),
                    onTap: () => _switchToDarkTheme(context, !TestData.isDarkTheme),
                  );
                },
              ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
