import 'package:flutter/material.dart';

import 'bottom_sheet_filter.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => const BottomSheetFilter(),
            ),
          ),
        ],
      ),
    );
  }
}
