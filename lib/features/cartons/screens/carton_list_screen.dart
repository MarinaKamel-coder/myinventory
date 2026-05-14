import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermoms/app/theme/app_colors.dart';
import 'package:supermoms/features/cartons/screens/carton_detail_screen.dart';
import 'package:supermoms/shared/widgets/app_room_filter.dart';
import 'package:supermoms/shared/widgets/app_search_field.dart';
import 'package:supermoms/src/models/room.dart';
import 'package:supermoms/src/providers/carton_provider.dart';

class CartonListScreen extends StatefulWidget {
  const CartonListScreen({
    super.key,
    this.showBackButton = false,
  });

  final bool showBackButton;

  @override
  State<CartonListScreen> createState() => _CartonListScreenState();
}

class _CartonListScreenState extends State<CartonListScreen> {
  String searchQuery = '';
  Room? selectedRoom;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CartonProvider>();

    final cartons = provider.cartons.where((box) {
      final matchesSearch = box.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesRoom =
          selectedRoom == null || box.room == selectedRoom;

      return matchesSearch && matchesRoom;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: const Text(
          'Tous les cartons',
          style: TextStyle(
            color: AppColors.textMain,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.textMain,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [
                AppSearchField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),

                const SizedBox(height: 12),

                AppRoomFilter(
                  selectedRoom: selectedRoom,
                  onChanged: (room) {
                    setState(() {
                      selectedRoom = room;
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: cartons.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),

                    itemCount: cartons.length,

                    itemBuilder: (context, index) {
                      final box = cartons[index];

                      final totalItems = box.items.fold<int>(
                        0,
                        (sum, item) => sum + item.quantity,
                      );

                      return _buildCartonItem(
                        context,
                        box.name,
                        box.room,
                        totalItems,
                        box.fragile,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CartonDetailScreen(box: box),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 60,
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 16),

          Text(
            "Aucun carton trouvé",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartonItem(
    BuildContext context,
    String title,
    Room room,
    int itemsCount,
    bool isFragile,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Row(
            children: [
              Container(
                width: 55,
                height: 55,
                alignment: Alignment.center,

                decoration: BoxDecoration(
                  gradient: AppColors.mainGradient,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Text(
                  room.icon,
                  style: const TextStyle(fontSize: 26),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textMain,
                            ),

                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        if (isFragile)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),

                            child: Icon(
                              Icons.warning_amber_rounded,
                              color: AppColors.statsOrange,
                              size: 20,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${room.label} • $itemsCount ${itemsCount > 1 ? 'objets' : 'objet'}",

                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}