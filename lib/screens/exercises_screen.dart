import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitto/l10n/generated/app_localizations.dart';
import 'package:fitto/models/exercises/exercise.dart';
import 'package:fitto/providers/exercises.dart';
import 'package:fitto/widgets/core/app_bar.dart';
import 'package:fitto/widgets/exercises/filter_row.dart';
import 'package:fitto/widgets/exercises/list_tile.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  static const routeName = '/exercises';

  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    final exercisesList = Provider.of<ExercisesProvider>(context).filteredExercises;

    return Scaffold(
      appBar: EmptyAppBar(AppLocalizations.of(context).exercises),
      body: Column(
        children: [
          const FilterRow(),
          Expanded(
            child: exercisesList.isEmpty
                ? const Center(
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _ExercisesList(exerciseList: exercisesList),
          ),
        ],
      ),
    );
  }
}

class _ExercisesList extends StatelessWidget {
  const _ExercisesList({required this.exerciseList});

  final List<Exercise> exerciseList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider(thickness: 1);
      },
      itemCount: exerciseList.length,
      itemBuilder: (context, index) => ExerciseListTile(exercise: exerciseList[index]),
    );
  }
}
