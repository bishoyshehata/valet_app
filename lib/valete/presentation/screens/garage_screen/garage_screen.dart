import 'package:flutter/material.dart';
import 'package:valet_app/valete/presentation/components/custom_app_bar.dart';
import 'package:valet_app/valete/presentation/resources/assets_manager.dart';
import 'package:valet_app/valete/presentation/resources/font_manager.dart';
import 'package:valet_app/valete/presentation/resources/values_manager.dart';
import '../../resources/colors_manager.dart';

enum VehicleType { car, motorcycle, bicycle, truck }

class GarageScreen extends StatefulWidget {
  @override
  _GarageScreenState createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  bool showExtraSlots = false;
  VehicleType selectedVehicleType = VehicleType.car;

  final List<ParkingSlot> extraSlots = List.generate(
    8,
    (index) => ParkingSlot(id: 19 + index, isOccupied: index.isEven),
  );

  final List<ParkingSlot> slots = List.generate(
    18,
    (index) => ParkingSlot(
      id: index + 1,
      isOccupied: [2, 4, 5, 7, 8, 11, 12, 14, 15].contains(index + 1),
      isSelected: (index + 1) == 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: CustomAppBar(
        title: "موقف السيارات",
        centerTitle: true,
        titleColor: ColorManager.white,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    showExtraSlots
                        ? 'إخفاء الأماكن الإضافية'
                        : 'عرض الأماكن الإضافية',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: FontSize.s17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Switch(
                    value: showExtraSlots,
                    onChanged: (val) {
                      setState(() => showExtraSlots = val);
                    },
                    activeColor: ColorManager.primary,
                  ),
                ],
              ),
            ),
          ),

          if (showExtraSlots) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'الأماكن الإضافية',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: FontSize.s20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(AppPadding.p10),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return MiniParkingSlotWidget(slot: extraSlots[index]);
                }, childCount: extraSlots.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 100, // تصغير ارتفاع العناصر
                ),
              ),
            ),
          ],

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                'الجراج الرئيسي',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: FontSize.s20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return ParkingSlotWidget(slot: slots[index]);
              }, childCount: slots.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 100, // التحكم في ارتفاع العنصر
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParkingSlot {
  final int id;
  final bool isOccupied;
  final bool isSelected;

  ParkingSlot({
    required this.id,
    this.isOccupied = false,
    this.isSelected = false,
  });
}

class ParkingSlotWidget extends StatelessWidget {
  final ParkingSlot slot;

  const ParkingSlotWidget({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    final bool isOccupied = slot.isOccupied;
    final bool isSelected = slot.isSelected;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color:
            isOccupied
                ? ColorManager.primary.withOpacity(0.8)
                : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? ColorManager.white : Colors.grey.shade600,
          width: isSelected ? 3 : 1.5,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isOccupied)
            Positioned(
              bottom: 8,
              child: Image.asset(
                AssetsManager.car,
                height: AppSizeHeight.s50,
                fit: BoxFit.contain,
              ),
            ),
          Positioned(
            top: 8,
            child: Text(
              'P${slot.id.toString().padLeft(2, '0')}',
              style: TextStyle(
                color:
                    isSelected ? ColorManager.background : ColorManager.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!isOccupied)
            Positioned(
              bottom: 12,
              child: Icon(
                Icons.local_parking,
                color: isSelected ? Colors.cyanAccent : ColorManager.primary,
                size: AppSizeHeight.s40,
              ),
            ),
        ],
      ),
    );
  }
}

class MiniParkingSlotWidget extends StatelessWidget {
  final ParkingSlot slot;

  const MiniParkingSlotWidget({super.key, required this.slot});

  @override
  Widget build(BuildContext context) {
    final bool isOccupied = slot.isOccupied;
    final bool isSelected = slot.isSelected;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color:
            isOccupied
                ? ColorManager.primary.withOpacity(0.8)
                : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? ColorManager.primary : Colors.grey.shade600,
          width: isSelected ? 3 : 1.5,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isOccupied)
            Positioned(
              bottom: 8,
              child: Image.asset(
                AssetsManager.car,
                height: AppSizeHeight.s40,
                fit: BoxFit.contain,
              ),
            ),
          Positioned(
            top: 8,
            child: Text(
              'P${slot.id.toString().padLeft(2, '0')}',
              style: TextStyle(
                color:
                    isSelected ? ColorManager.background : ColorManager.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!isOccupied)
            Positioned(
              bottom: 12,
              child: Icon(
                Icons.local_parking,
                color: isSelected ? Colors.cyanAccent : ColorManager.primary,
                size: AppSizeHeight.s25,
              ),
            ),
        ],
      ),
    );
  }
}
