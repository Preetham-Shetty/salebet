import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesbets/presentation/screens/live/live_screen_helper.dart';
import 'package:video_player/video_player.dart';

class Live extends StatefulWidget {
  final String matchId;

  const Live({super.key, required this.matchId});

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  LiveScreenHelper helper = LiveScreenHelper();
  @override
  void initState() {
    super.initState();
    _loadCredits();
    _loadVideo();
  }

  Future<void> _loadCredits() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .get();
    setState(() {
      helper.userCredits = doc.data()?['credits'] ?? 0;
    });
  }

  Future<void> _loadVideo() async {
    helper.videoController =
        VideoPlayerController.network(helper.sampleVideoUrl)
          ..initialize().then((_) {
            setState(() {
              helper.isVideoReady = true;
            });
            helper.videoController.play();
          });
  }

  Future<void> _placeBet() async {
    final betAmount = int.tryParse(helper.betController.text) ?? 0;
    if (betAmount <= 0 || betAmount > helper.userCredits) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Invalid bet amount")));
      return;
    }

    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('user').doc(uid).update({
      'credits': helper.userCredits - betAmount,
    });

    setState(() {
      helper.userCredits -= betAmount;
      helper.betController.clear();
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Bet of $betAmount placed!")));
  }

  Future<void> _postComment() async {
    final text = helper.commentController.text.trim();
    if (text.isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser!.uid;
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('matches')
        .doc(widget.matchId)
        .collection('comments')
        .add({
          'uid': uid,
          'username': user?.displayName ?? "User",
          'comment': text,
          'timestamp': FieldValue.serverTimestamp(),
        });

    helper.commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    helper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Live Stream"),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                "Credits: ${helper.userCredits}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: helper.isVideoReady
                ? helper.videoController.value.aspectRatio
                : 16 / 9,
            child: helper.isVideoReady
                ? Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(helper.videoController),
                      _ControlsOverlay(controller: helper.videoController),
                      VideoProgressIndicator(
                        helper.videoController,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.amber,
                          bufferedColor: Colors.white24,
                          backgroundColor: Colors.white10,
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: helper.betController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter bet amount",
                      filled: true,
                      fillColor: Colors.white10,
                      hintStyle: const TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _placeBet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Bet"),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white30),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('matches')
                  .doc(widget.matchId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Text(
                          (data['username'] ?? "U")[0],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(
                        data['username'] ?? "User",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        data['comment'] ?? "",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: helper.commentController,
                      decoration: InputDecoration(
                        hintText: "Add a comment...",
                        filled: true,
                        fillColor: Colors.white10,
                        hintStyle: const TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.amber),
                    onPressed: _postComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  final VideoPlayerController controller;
  const _ControlsOverlay({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          controller.value.isPlaying ? controller.pause() : controller.play(),
      child: Stack(
        children: [
          if (!controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 64,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }
}
