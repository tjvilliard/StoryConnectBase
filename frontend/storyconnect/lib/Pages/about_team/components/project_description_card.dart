import 'package:flutter/material.dart';

class ProjectDescriptionCard extends StatelessWidget {
  const ProjectDescriptionCard({
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
                  "About the Project",
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
            Padding(
                padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18, top: 8),
                child: Text(
                  """Storyconnect integrates Firebase for secure authentication and image storage, a robust Postgres database, and a Django backend, ensuring efficient data management and user experience. With its Flutter frontend, the platform offers a seamless and responsive interface for both mobile and web users, enhancing accessibility and user engagement. Hosted on AWS, StoryConnect guarantees reliable and scalable infrastructure, supporting the platform's diverse functionalities ranging from reader-writer interactions to sophisticated book suggestion algorithms. This blend of technologies not only resolves the disjointed experiences prevalent in existing platforms but also empowers writers with advanced tools like a 'Continuity Checker' and 'Road-UnBlocker,' while providing readers and publishers with a dynamic community for feedback, discovery, and collaboration. The platform's aim is to harmonize the creative process for writers and the reading experience for readers, thereby cultivating a vibrant ecosystem for literature enthusiasts.""",
                  style: Theme.of(context).textTheme.bodyMedium,
                )),
          ],
        ),
      ),
    );
  }
}
