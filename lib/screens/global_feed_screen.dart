import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlobalFeedScreen extends StatefulWidget {
  const GlobalFeedScreen({super.key});

  @override
  State<GlobalFeedScreen> createState() => _GlobalFeedScreenState();
}

class _GlobalFeedScreenState extends State<GlobalFeedScreen> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Feed'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            // child: Stack(
            //   children: [
            //     // Watermark for the quotation mark
            //     Positioned.fill(
            //       child: Align(
            //         alignment: Alignment.center,
            //         child: Text(
            //           '“',
            //           style: TextStyle(
            //             fontSize: 300,
            //             color:
            //                 Theme.of(context).brightness == Brightness.dark
            //                     ? Colors.white.withOpacity(0.05)
            //                     : Colors.black.withOpacity(0.05),
            //             fontWeight: FontWeight.bold,
            //             // fontFamily:
            //           ),
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.all(24.0),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.stretch,
            //         children: [
            //           Expanded(
            //             child: Align(
            //               alignment: Alignment.center,
            //               child: Text(
            //                 '"Hello, World!"',
            //                 style: Theme.of(
            //                   context,
            //                 ).textTheme.headlineMedium?.copyWith(
            //                   color:
            //                       Theme.of(
            //                         context,
            //                       ).textTheme.headlineMedium?.color,
            //                 ),
            //                 textAlign: TextAlign.center,
            //               ),
            //             ),
            //           ),
            //           const SizedBox(height: 16.0),
            //           Align(
            //             alignment: Alignment.bottomRight,
            //             child: Text(
            //               '- Author Name',
            //               style: Theme.of(
            //                 context,
            //               ).textTheme.titleMedium?.copyWith(
            //                 fontWeight: FontWeight.bold,
            //                 color:
            //                     Theme.of(context).textTheme.titleMedium?.color,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-quote'),
        tooltip: 'Add New Quote',
        child: const Icon(Icons.add),
      ),
    );
  }
}
