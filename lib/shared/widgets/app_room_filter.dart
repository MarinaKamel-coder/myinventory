import 'package:flutter/material.dart';
import 'package:supermoms/src/models/room.dart';

class AppRoomFilter extends StatelessWidget {
  const AppRoomFilter({
    required this.selectedRoom,
    required this.onChanged,
    super.key,
  });

  final Room? selectedRoom;
  final ValueChanged<Room?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Room?>(
      value: selectedRoom,

      decoration: InputDecoration(
        hintText: 'Filtrer par pièce',

        filled: true,
        fillColor: Colors.grey.shade100,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),

      items: [

        const DropdownMenuItem(
          value: null,
          child: Text('Toutes les pièces'),
        ),

        ...Room.values.map(
          (room) => DropdownMenuItem(
            value: room,
            child: Text('${room.icon} ${room.label}'),
          ),
        ),
      ],

      onChanged: onChanged,
    );
  }
}