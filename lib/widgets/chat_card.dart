import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';

class ChatCard extends StatefulWidget {
  final String name;
  final double rating;
  final int trips;
  final String memberSince;
  final VoidCallback onTap;
  final bool isPinned;
  final Function(bool)? onPinnedChanged;

  const ChatCard({
    super.key,
    required this.name,
    required this.rating,
    required this.trips,
    required this.memberSince,
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
              // Informações do motorista
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 14,
                          color: AppColors.starFilled,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.rating} · ${widget.trips} viagens',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Membro desde ${widget.memberSince}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
