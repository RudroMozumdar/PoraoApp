import 'package:porao_app/common/all_import.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({super.key});

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  String formatTimeDifference(Duration difference) {
    final seconds = difference.inSeconds;
    final minutes = difference.inMinutes;
    final hours = difference.inHours;
    final days = difference.inDays;

    if (days > 0) {
      return '$days day${days > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours hr${hours > 1 ? 's' : ''}';
    } else if (minutes > 0) {
      return '$minutes min${minutes > 1 ? 's' : ''}';
    } else {
      return '$seconds sec${seconds > 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        return ListView.builder(
          itemCount: snapshot.data?.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot postAuthor = snapshot.data!.docs[index];
            final timestamp = postAuthor['createdAt'] as Timestamp;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: seconderyColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(postAuthor['title']),
                      subtitle: Text(postAuthor['content']),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(formatTimeDifference(
                          DateTime.now().difference(timestamp.toDate()))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_upward_rounded),
                        ),
                        Text(postAuthor['upvotes'].length.toString()),
                        const SizedBox(width: 5),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_downward_rounded),
                        ),
                        Text(postAuthor['downvotes'].length.toString()),
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.comment),
                        ),
                        const SizedBox(width: 30),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
