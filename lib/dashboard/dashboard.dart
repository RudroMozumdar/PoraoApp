import 'package:porao_app/common/all_import.dart';
import 'package:porao_app/common/colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

final PageController pageController = PageController();
var currentTab = 0;

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var tabs = const [
    HomePage(),
    CreatePost(),
    MessagesThreads(),
    MyPosts(),
  ];
  var tabNames = const [
    "Homepage",
    "Ask and Search",
    "Threads & Messages",
    "My Posts",
  ];

  // Nav Bar -----------------------------------------------------------------------------------------
  Widget _navBar() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
        ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30)),
          color: primaryColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: GNav(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            tabBorderRadius: 25,
            gap: 0,
            tabs: const [
              GButton(
                icon: Icons.home_rounded,
                iconColor: Colors.black,
                iconActiveColor: Colors.white,
                iconSize: 40,
              ),
              GButton(
                icon: Icons.search,
                iconColor: Colors.black,
                iconActiveColor: Colors.white,
                iconSize: 40,
              ),
              GButton(
                icon: Icons.message,
                iconColor: Colors.black,
                iconActiveColor: Colors.white,
                iconSize: 40,
              ),
              GButton(
                icon: Icons.notifications,
                iconColor: Colors.black,
                iconActiveColor: Colors.white,
                iconSize: 40,
              ),
            ],
            selectedIndex: currentTab,
            onTabChange: (tabIndex) {
              pageController.animateToPage(
                tabIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastEaseInToSlowEaseOut,
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        // App Bar
        appBar: AppBar(
          centerTitle: true,
          title: const Padding(
            padding:  EdgeInsets.only(bottom: 30),
            child:  Text(
              "Porao",
              style: TextStyle(
                  fontFamily: "IrishGrover",
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 4),
                      blurRadius: 10.0,
                      color: Color.fromARGB(255, 100, 100, 100),
                    )
                  ]),
            ),
          ),
          toolbarHeight: 110,
          backgroundColor: primaryColor,
          leadingWidth: 110,
          leading: Container(
            margin: const EdgeInsets.only(left: 20, top: 40),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: IconButton(
                onPressed: () {
                  //....... to be added
                },
                icon: const Text(
                  "বাংলা",
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 30, top: 40),
              child: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                }, 
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            )
          ],
        ),

        // Body
        body: Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45),
              topRight: Radius.circular(45),
            )
          ),
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          child: PageView(
            controller: pageController,
            children: tabs,
            onPageChanged: (pageIndex) {
              setState(() {
                currentTab = pageIndex;
              });
            },
          ),
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
