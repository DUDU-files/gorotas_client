import 'package:flutter/material.dart';
import 'package:vans/colors/app_colors.dart';

class PassageCard extends StatelessWidget {
  final String origin;
  final String destination;
  final String type; // "Van" ou "Lotação"
  final double price;
  final String date;
  final int availableSeats;
  final String duration;
  final String departureTime;
  final List<String> availableTimes;
  final List<String> availableDates; // Próximas datas disponíveis (dd/MM)
  final double rating;
  final VoidCallback onMoreInfo;
  final VoidCallback onBuyTicket;

  const PassageCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.type,
    required this.price,
    required this.date,
    required this.availableSeats,
    required this.duration,
    required this.departureTime,
    required this.availableTimes,
    this.availableDates = const [],
    required this.rating,
    required this.onMoreInfo,
    required this.onBuyTicket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rota
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '$origin → $destination',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Tipo
          Text(
            type,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primaryGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Informações principais (preço, data, assentos)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Preço
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'R\$$price',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              // Data
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: AppColors.primaryGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    availableDates.isNotEmpty
                        ? availableDates.take(3).join(', ')
                        : date,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGray,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Próximas datas disponíveis (só mostra se tiver mais de 1 data)
          if (availableDates.length > 1) ...[
            const SizedBox(height: 8),
            Text(
              'Próximas viagens:',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGray,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: availableDates.length > 5
                    ? 5
                    : availableDates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? AppColors.primaryOrange
                          : AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      availableDates[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: index == 0
                            ? AppColors.white
                            : AppColors.primaryBlue,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Assentos disponíveis e duração
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.event_seat,
                    size: 14,
                    color: AppColors.primaryGray,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$availableSeats vagas disponíveis',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGray,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: AppColors.primaryGray),
                  const SizedBox(width: 4),
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGray,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horário
          Text(
            'Horário${availableTimes.length > 1 ? 's' : ''}:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGray,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            children: availableTimes.map((time) {
              return Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Divider
          Divider(color: AppColors.backgroudGray, height: 1),
          const SizedBox(height: 16),

          // Avaliação e Botões
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: AppColors.starFilled, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Botões lado a lado
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onMoreInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Mais Informações',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onBuyTicket,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                    ),
                    child: const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Comprar Passagem',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
