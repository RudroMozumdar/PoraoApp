import 'package:porao_app/common/all_import.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PageController _pageController = PageController();
  var tabs = const [
    HomePage(),
    StudentRequests(),
    MessagesThreads(),
    MyPosts(),
  ];
  var tabNames = const [
    "Homepage",
    "Ask and Search",
    "Threads & Messages",
    "My Posts",
  ];
  var _currentTab = 0;

  // Nav Bar -----------------------------------------------------------------------------------------
  Widget _navBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(25)), // Adjust the value as needed
        color: primaryColor, // Background color
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GNav(
          tabBackgroundColor: seconderyColor,
          padding: const EdgeInsets.all(14),
          tabBorderRadius: 25,
          gap: 8,
          tabs: const [
            GButton(
              icon: Icons.home_rounded,
            ),
            GButton(
              icon: Icons.search,
            ),
            GButton(
              icon: Icons.message,
            ),
            GButton(
              icon: Icons.notifications,
            ),
          ],
          selectedIndex: _currentTab,
          onTabChange: (tabIndex) {
            _pageController.animateToPage(
              tabIndex,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastEaseInToSlowEaseOut,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // App Bar
        appBar: CustomAppBar(title: tabNames[_currentTab]),

        // Body
        body: PageView(
          controller: _pageController,
          children: tabs,
          onPageChanged: (pageIndex) {
            setState(() {
              _currentTab = pageIndex;
            });
          },
        ),

        // Nav Bar
        bottomNavigationBar: _navBar(),
        endDrawer: CustomDrawer(
          username: Auth().currentUser?.email ?? 'User Email',
        ),
      ),
    );
  }
}
