import 'package:state_notifier/state_notifier.dart';

import 'project.dart';
import '../services/firebase_repository.dart';

class ProjectList extends StateNotifier<List<Project>> {
  ProjectList([List<Project> initialProjectList])
      : super(initialProjectList ?? []);

  void getAllProject() {
    List<Project> projects = [];
    FirebaseRepo()..getProject().listen((item) => projects.addAll(item));
    state = [
      ...projects,
    ];
  }
}
