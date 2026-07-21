import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HostEventsTabBar extends StatelessWidget {
  final String activeTab;
  final ValueChanged<String> onTabSelected;

  const HostEventsTabBar({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ["Upcoming", "Past", "Cancel"];

    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1E222B),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = activeTab == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(tab),
              behavior: HitTestBehavior.opaque,
              child: Container(
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [
                            Color(0xFFF28F31), // Orange/yellow
                            Color(0xFF72E84F), // Lime green
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? Text(
                        tab,
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      )
                    : ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFF28F31),
                            Color(0xFF72E84F),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        blendMode: BlendMode.srcIn,
                        child: Text(
                          tab,
                          style: TextStyle(
                            fontFamily: "SF Pro Rounded",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
