import 'package:flutter/material.dart';

class ProjectDiagramCard extends StatelessWidget {
  const ProjectDiagramCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Project Diagram",
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
            Padding(
                padding: const EdgeInsets.all(18),
                child: ClipRRect(borderRadius: BorderRadius.circular(15.0), child: Image.asset('assets/diagram.png'))),
          ],
        ),
      ),
    );
  }
}
