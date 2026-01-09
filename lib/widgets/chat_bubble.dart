import 'package:flutter/material.dart';
import 'package:vans/exports.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isUserMessage;
  final bool isRead;

  const ChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isUserMessage,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUserMessage
              ? AppColors.primaryOrange
              : AppColors.secondaryBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: isUserMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isUserMessage ? AppColors.white : AppColors.primaryBlue,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: isUserMessage
                        ? AppColors.white.withOpacity(0.8)
                        : AppColors.primaryGray,
                    fontSize: 10,
                  ),
                ),
                if (isUserMessage) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
