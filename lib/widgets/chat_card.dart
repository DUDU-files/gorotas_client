import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';
import 'package:intl/intl.dart';

class ChatCard extends StatefulWidget {
  final String name;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final VoidCallback onTap;
  final bool isPinned;
  final Function(bool)? onPinnedChanged;

  const ChatCard({
    super.key,
    required this.name,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    required this.onTap,
    this.isPinned = false,
    this.onPinnedChanged,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  late bool _isPinned;

  @override
  void initState() {
    super.initState();
    _isPinned = widget.isPinned;
  }

  void _togglePin() {
    setState(() {
      _isPinned = !_isPinned;
    });
    widget.onPinnedChanged?.call(_isPinned);
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(time.year, time.month, time.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(time);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Ontem';
    } else {
      return DateFormat('dd/MM').format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondaryBlue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.person,
                  size: 30,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 16),
              // Informações do chat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.lastMessageTime != null)
                          Text(
                            _formatTime(widget.lastMessageTime),
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.unreadCount > 0
                                  ? AppColors.primaryOrange
                                  : AppColors.white.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.lastMessage ?? 'Nenhuma mensagem',
                            style: TextStyle(
                              fontSize: 13,
                              color: widget.unreadCount > 0
                                  ? AppColors.white
                                  : AppColors.white.withOpacity(0.7),
                              fontWeight: widget.unreadCount > 0
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryOrange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              widget.unreadCount.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Botão de pin (fixar/desafixar)
              GestureDetector(
                onTap: _togglePin,
                child: Icon(
                  _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  size: 24,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
