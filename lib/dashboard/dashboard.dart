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
    TempStudentReq(),
    TempStudetInfo(),
    HomePage(),
  ];
  var tabNames = const [
    "Homepage",
    "Studet Request",
    "Studet Information",
    "Pranto",
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
              text: 'Home',
            ),
            GButton(
              icon: Icons.feed,
              text: 'Feed',
            ),
            GButton(
              icon: Icons.notification_add,
              text: 'Noti',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
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
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 255, 184, 0), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
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
      ),
    );
  }
}
