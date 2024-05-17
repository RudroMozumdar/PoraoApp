import 'package:porao_app/common/all_import.dart';

class ReviewDialog extends StatefulWidget {
  const ReviewDialog({super.key});

  @override
  State<ReviewDialog> createState() => _ReviewDialogState();
}

class _ReviewDialogState extends State<ReviewDialog> {
  double _userRating = 0.0;
  final TextEditingController _reviewController = TextEditingController();

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Write a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar.builder(
                initialRating: _userRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _userRating = rating;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  hintText: 'Write your review here...',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                // Handle submission (e.g., save the review)
                final reviewText = _reviewController.text;
                print('Rating: $_userRating, Review: $reviewText');
                Navigator.pop(context);
              },
              child: const Text('SUBMIT'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showReviewDialog(context);
          },
          child: const Text('Write a Review'),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ReviewDialog(),
  ));
}
