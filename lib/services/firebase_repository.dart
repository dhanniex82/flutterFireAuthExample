import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/project.dart';

class FirebaseRepo {
  //FirebaseRepo(this._project);
  //final FirebaseFirestore _firestore;
  final _project = FirebaseFirestore.instance.collection('projects');

  // CREATE/add Project
  Future<void> addProject(Project project) {
    return _project.add(project.toMap());
  }

  // READ Project
  Stream<List<Project>> getProject() {
    return _project.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => Project.fromSnapshot(e)).toList();
    });
  }

  // UPDATE/EDIT Project
  Future<void> updateProject(String projectId, Project newData) {
    final projectRef = _project.doc(projectId);
    return projectRef
        .update(newData.toMapUpdate())
        .then((_) => print('project $projectId updated'))
        .catchError(
            (error) => print('failed to update project $projectId : $error'));
  }

  // DELETE Project
  Future<void> deleteProject(String projectId) async {
    final projectRef = _project.doc(projectId);
    final colRef = projectRef.collection('tallies').doc();
    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          transaction.delete(colRef);
          transaction.delete(projectRef);
        })
        .then((value) => print('project $projectId and sub collection deleted'))
        .catchError((error) => print('failed to delete $projectId: $error'));
  }

// get single project
  Future<Project> getProjectDetail(String projectID) async {
    DocumentSnapshot doc = await _project.doc(projectID).get();
    return Project.fromSnapshot(doc);
  }
}
