import 'package:flutter/material.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({Key? key}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  // Data dummy untuk messages
  final List<Message> messages = [
    Message(
      name: 'Martina',
      username: '@MartinaCraig',
      message: 'Halo, bisakah kamu bertemu dengan saya di cafe?',
      date: '22/08/25',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      isRead: false,
    ),
    Message(
      name: 'John Doe',
      username: '@johndoe',
      message: 'Thanks for your help yesterday!',
      date: '21/08/25',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      isRead: true,
    ),
    Message(
      name: 'Sarah Smith',
      username: '@sarahsmith',
      message: 'Can we reschedule our meeting?',
      date: '20/08/25',
      avatarUrl: 'https://i.pravatar.cc/150?img=25',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB0BEC5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF607D8B),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Inbox',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: messages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessageItem(messages[index]);
              },
            ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildMessageItem(Message message) {
    return InkWell(
      onTap: () {
        // TODO: Navigasi ke detail chat
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening chat with ${message.name}'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        color:
            message.isRead ? const Color(0xFFCFD8DC) : const Color(0xFFE0E7EB),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(message.avatarUrl),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 12),
            // Message Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name and Username
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              message.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: message.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                message.username,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Date
                      Text(
                        message.date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Message Preview
                  Text(
                    message.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight:
                          message.isRead ? FontWeight.normal : FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFF607D8B),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, false, 0),
          _buildNavItem(Icons.search, false, 1),
          _buildNavItem(Icons.add_box, false, 2),
          _buildNavItem(Icons.notifications, false, 3),
          _buildNavItem(Icons.chat_bubble, true, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, int index) {
    return GestureDetector(
      onTap: () {
        // Jangan navigate jika sudah di halaman yang aktif
        if (isActive) return;

        // Navigasi sesuai index
        switch (index) {
          case 0:
            // Home - Kembali ke HomePage
            Navigator.pop(context);
            break;
          case 1:
            // Search
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Search feature coming soon!'),
                duration: Duration(seconds: 1),
              ),
            );
            break;
          case 2:
            // Focs Mode
            // TODO: Navigate to FocsCScreen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Focs Mode'),
                duration: Duration(seconds: 1),
              ),
            );
            break;
          case 3:
            // Notifications
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications feature coming soon!'),
                duration: Duration(seconds: 1),
              ),
            );
            break;
          case 4:
            // Messages - Already on this page
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.white70,
              size: 28,
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Model untuk Message
class Message {
  final String name;
  final String username;
  final String message;
  final String date;
  final String avatarUrl;
  final bool isRead;

  Message({
    required this.name,
    required this.username,
    required this.message,
    required this.date,
    required this.avatarUrl,
    this.isRead = false,
  });
}
