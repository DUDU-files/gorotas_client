import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vans/exports.dart';

class Payment extends StatefulWidget {
  final Map<String, dynamic> data;

  const Payment({super.key, required this.data});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final double _walletBalance = 2000.00;
  bool _useWallet = false;
  bool _isProcessing = false;

  double get ticketPrice => (widget.data['ticketPrice'] ?? 0.0).toDouble();
  String get origin => widget.data['origin'] ?? '';
  String get destination => widget.data['destination'] ?? '';
  String get routeId => widget.data['routeId'] ?? '';
  String get vehicleType => widget.data['vehicleType'] ?? 'Veículo';
  String get driverName => widget.data['driverName'] ?? 'Motorista';
  String get driverId => widget.data['driverId'] ?? '';
  String get departureTime => widget.data['departureTime'] ?? '07:00';

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    if (userProvider.userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: Usuário não autenticado')),
      );
      setState(() => _isProcessing = false);
      return;
    }

    // Data atual formatada
    final now = DateTime.now();
    final dateFormatted = DateFormat('dd/MM/yyyy').format(now);

    // Gerar número do assento aleatório
    final seatNumber = '${(now.millisecond % 20) + 1}A';

    // Criar ticket no Firebase
    final ticket = await ticketProvider.buyTicket(
      routeId: routeId,
      clientId: userProvider.userId!,
      origin: origin,
      destination: destination,
      vehicleType: vehicleType,
      price: ticketPrice,
      date: dateFormatted,
      time: departureTime,
      driverName: driverName,
      driverId: driverId,
      seatNumber: seatNumber,
    );

    setState(() => _isProcessing = false);

    if (ticket != null) {
      _showSuccessModal(context, ticket.id, dateFormatted, seatNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao processar pagamento')),
      );
    }
  }

  void _showSuccessModal(
    BuildContext context,
    String ticketId,
    String date,
    String seatNumber,
  ) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícone de sucesso
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: AppColors.white, size: 48),
            ),
            const SizedBox(height: 20),

            // Título
            const Text(
              'Sucesso!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Descrição
            const Text(
              'Pagamento realizado.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.primaryGray),
            ),
            const SizedBox(height: 24),

            // Botão Baixar Comprovante
            SizedBox(
              width: double.infinity,
              child: ConfirmationButton(
                label: 'Baixar Comprovante',
                onPressed: () {
                  Navigator.pop(context);
                  final navProvider = Provider.of<NavigationProvider>(
                    context,
                    listen: false,
                  );
                  navProvider.navigateTo(
                    AppScreen.receipt,
                    data: {
                      'origin': origin,
                      'destination': destination,
                      'type': vehicleType,
                      'price': ticketPrice,
                      'date': date,
                      'time': departureTime,
                      'passengerName': userProvider.userName ?? 'Cliente',
                      'passengerId': userProvider.userId ?? '',
                      'seatNumber': seatNumber,
                      'driverName': driverName,
                      'ticketId': ticketId,
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Botão Ir para Minhas Viagens
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  final navProvider = Provider.of<NavigationProvider>(
                    context,
                    listen: false,
                  );
                  navProvider.navigateTo(AppScreen.tickets);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryBlue),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Ver Minhas Viagens',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção: Métodos de Pagamento
            const Text(
              'Métodos de Pagamento',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Saldo da Carteira
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.lightGray, width: 1),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minha carteira(R\$)',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryGray,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'R\$ ${_walletBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Checkbox(
                        value: _useWallet,
                        onChanged: (value) {
                          setState(() {
                            _useWallet = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryOrange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Método de pagamento: Cartão
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.lightGray, width: 1),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.credit_card,
                    color: AppColors.primaryGray,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Visa-0000',
                    style: TextStyle(fontSize: 13, color: AppColors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Seção: Adicionar Métodos de Pagamento
            const Text(
              'Adicionar Métodos de Pagamento',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 12),

            // Botão: Adicionar Cartão
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddCardScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.credit_card),
                label: const Text('Adicionar Cartão'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Botão: Adicionar Saldo via Pix
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddPixScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text('Adicionar Saldo via Pix'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Resumo do pagamento
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroudGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.lightGray),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Valor da passagem:',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryGray,
                        ),
                      ),
                      Text(
                        'R\$ ${ticketPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.lightGray),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total a pagar:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      Text(
                        'R\$ ${ticketPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botão de Pagar
            SizedBox(
              width: double.infinity,
              child: _isProcessing
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryOrange,
                      ),
                    )
                  : ConfirmationButton(
                      label: 'Finalizar Pagamento',
                      onPressed: () {
                        if (_useWallet) {
                          _processPayment();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Selecione um método de pagamento'),
                            ),
                          );
                        }
                      },
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
