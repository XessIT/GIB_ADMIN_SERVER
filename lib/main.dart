import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:gibadmin/about.dart';
//import 'package:gibadmin/dashboardpage/gtog_report.dart';
//import 'package:gibadmin/dashboardpage/guest_reort.dart';
import 'package:gibadmin/gib_achivements/gib_achivements_view_photos.dart';
import 'package:gibadmin/members/member_guest.dart';
import 'package:gibadmin/reports/gtog_report.dart';
import 'package:gibadmin/reports/honoring_report.dart';
import 'package:gibadmin/reports/indivutual_report.dart';
import 'package:gibadmin/ads_pages/list_ad_page.dart';
import 'package:gibadmin/meeting/meeting_history.dart';
import 'package:gibadmin/meeting/meeting_upcoming_coming.dart';
import 'package:gibadmin/meeting/meeting_report.dart';
import 'package:gibadmin/members/members_nonexecutive_members.dart';
import 'package:gibadmin/reports/members_reports.dart';
import 'package:gibadmin/reports/report_guest_report.dart';
import 'package:gibadmin/reports/business_report.dart';
import 'package:gibadmin/settings/add_business_category.dart';
import 'package:gibadmin/members/member_block_unblock_list.dart';
import 'package:gibadmin/members/new_member_aproval.dart';
import 'package:gibadmin/reward/reward.dart';
import 'package:gibadmin/settings/add_member_category.dart';
import 'package:gibadmin/settings/add_member_type.dart';
import 'package:gibadmin/settings/pagination.dart';
import 'package:gibadmin/settings/settings.dart';
import 'package:gibadmin/settings/settings_add_meeting_type.dart';
import 'package:gibadmin/subscription/subscription_set_person.dart';
import 'package:gibadmin/superAdmin.dart';
import 'package:gibadmin/super_user.dart';
import 'package:gibadmin/today_attendance/today_attendance.dart';
import 'package:gibadmin/subscription/subscription.dart';
import 'package:gibadmin/subscription/subscription_edit_delete.dart';
import 'package:gibadmin/subscription/subscription_edit_editpage.dart';
import 'package:gibadmin/members/womens_executive_members.dart';
import 'package:gibadmin/members/womens_nonExecutive_members.dart';
import 'package:gibadmin/reports/thanks_report.dart';
import 'package:gibadmin/gallery/view_photos_gallery.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ads_pages/add_ads.dart';
import 'current_meeting_attendance.dart';
//import 'dashboardpage/honor_report.dart';
import 'login.dart';
import 'meeting/qr_creations.dart';
import 'members/executive_member_updation.dart';
import 'members/new_member_registration.dart';
import 'settings/add_member_role.dart';
import 'gallery/add_photos.dart';
//import 'dashboardpage/business_report.dart';
import 'meeting/create_meeting.dart';
import 'dashboardpage/dashboard.dart';
import 'gib/allocated_team_view.dart';
import 'gib/allocation_details.dart';
import 'gib/team_creations.dart';
import 'gib_achivements/gib_achievement_add_photos.dart';
import 'members/member_update_registration.dart';
import 'members/view_executive_members.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'members/executive_member_updation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
            debugShowCheckedModeBanner: false,
          );
        } else {
          if (snapshot.data == true) {
            return FutureBuilder<String?>(
              future: getMobileNumber(),
              builder: (context, mobileSnapshot) {
                if (mobileSnapshot.connectionState == ConnectionState.waiting) {
                  return const MaterialApp(
                    home: Scaffold(
                        body: Center(child: CircularProgressIndicator())),
                    debugShowCheckedModeBanner: false,
                  );
                } else {
                  String? mobileNo = mobileSnapshot.data;
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'GIB Admin',
                    home: MainScreenPage(mobile: mobileNo ?? ''),
                    theme: ThemeData(
                      /// app bar 18
                      /// inside body heding  16
                      /// inside text 14
                      /// body for black
                      /// label for white
                      /// headline for medium  green

                      textTheme: GoogleFonts.aBeeZeeTextTheme().copyWith(
                        headlineSmall: const TextStyle(
                            fontSize: 16.0, color: Colors.green),
                        headlineMedium: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                        headlineLarge:
                            const TextStyle(fontSize: 16.0, color: Colors.blue),

                        bodySmall:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        bodyMedium: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        bodyLarge: const TextStyle(
                            fontSize: 18.0, color: Colors.black),

                        displayLarge:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        displayMedium: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        displaySmall: const TextStyle(
                            fontSize: 14,
                            color: Colors.white), // Assuming this is for labels
                      ),
                      outlinedButtonTheme: OutlinedButtonThemeData(
                          style: OutlinedButton.styleFrom(
                              elevation: 4,
                              shadowColor: Colors.blue,
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.orange,
                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)  ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              textStyle: const TextStyle(fontSize: 15))),
                      elevatedButtonTheme: ElevatedButtonThemeData(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green.shade800,
                              elevation: 4,
                              shadowColor: Colors.pink,
                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)  ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 50),
                              textStyle: const TextStyle(fontSize: 15))),
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    onGenerateRoute: (settings) {
                      final page = _getPageWidget(settings);
                      if (page != null) {
                        return PageRouteBuilder(
                          settings: settings,
                          pageBuilder: (_, __, ___) => page,
                          transitionsBuilder: (_, anim, __, child) {
                            return FadeTransition(
                              opacity: anim,
                              child: child,
                            );
                          },
                        );
                      }
                      return null;
                    },
                  );
                }
              },
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'GIB Admin',
              home: AdminLogin(),
              theme: ThemeData(
                /// app bar 18
                /// inside body heding  16
                /// inside text 14
                /// body for black
                /// label for white
                /// headline for medium  green

                textTheme: GoogleFonts.aBeeZeeTextTheme().copyWith(
                  headlineSmall: const TextStyle(
                      fontSize: 16.0, color: Colors.green),
                  headlineMedium: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                  headlineLarge:
                  const TextStyle(fontSize: 16.0, color: Colors.blue),

                  bodySmall:
                  const TextStyle(fontSize: 14, color: Colors.black),
                  bodyMedium: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  bodyLarge: const TextStyle(
                      fontSize: 18.0, color: Colors.black),

                  displayLarge:
                  const TextStyle(fontSize: 18, color: Colors.white),
                  displayMedium: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  displaySmall: const TextStyle(
                      fontSize: 14,
                      color: Colors.white), // Assuming this is for labels
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                        elevation: 4,
                        shadowColor: Colors.blue,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)  ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        textStyle: const TextStyle(fontSize: 15))),
                elevatedButtonTheme: ElevatedButtonThemeData(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green.shade800,
                        elevation: 4,
                        shadowColor: Colors.pink,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)  ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        textStyle: const TextStyle(fontSize: 15))),
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              onGenerateRoute: (settings) {
                final page = _getPageWidget(settings);
                if (page != null) {
                  return PageRouteBuilder(
                    settings: settings,
                    pageBuilder: (_, __, ___) => page,
                    transitionsBuilder: (_, anim, __, child) {
                      return FadeTransition(
                        opacity: anim,
                        child: child,
                      );
                    },
                  );
                }
                return null;
              },
            );
          }
        }
      },
    );
  }

  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }

  Future<String?> getMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userMobile');
  }
}

Widget? _getPageWidget(RouteSettings settings) {
  if (settings.name == null) {
    return null;
  }
  final uri = Uri.parse(settings.name!);
  switch (uri.path) {
    case '/':
      return MainScreenPage(mobile: '');
    case "/superAdmin":
      return const superAdmin();

    case "/new_member_approval":
      return const NewMemberApproval();
    case '/view_executive_members':
      return const ExecutiveMembers();
    case '/team_creation':
      return const TeamCreations();
    case '/allocation_details':
      return const AllocationDetails();
    case '/allocated_team_view':
      return const AllocatedTeamView();
    case '/add_ads':
      return const AddAdsPage();
    case '/add_photos':
      return const AddPhotos();
    case '/business_report':
    // return const BusinessReport();

    case '/new_member_registration':
      return const NewMemberRegistration();
    case '/rewards':
      return const Rewards();
    case '/subscription':
      return const Subscription();
    case '/today_attendance':
      return const TodayAttendance();
    case 'gib_achieve_add_photos':
      return const AchievementAddPhotos();
    case '/create_meeting':
      return const CreateMeeting();
    case '/showallpage':
    //   return const ShowAllPage();
    case '/member_wise_page':
    //  return const MemberWisePage();
    case '/add_member_role':
      return const AddMemeberRole();
    case '/add_business_category':
      return const AddBusinessCategory();
    // case '/executive_member_updation':
    //return const UpdateRegisteration();
    case "/updateregisterationpage":
      return const UpdateRegisterationPage(
        currentID: '',
      );
    case '/add_meeting_type':
      return const AddMeeting();
    case "/member_block_unblock":
      return const BlockAndUnBlock();
    case '/subscription_edit_delete':
      return const SubcriptionEditDelete();
    case '/dasguest_report_page':
    // return const DasGuestReport();
    case '/visitors_report_page':
      return const VisitorsReport();
    case "/womens_executive_members":
      return const WomensExecutiveMembers();
    case "/womensnon_executive_members":
      return const WomensNonExecutive();
    case "/upcomingmeeting_page":
      return const UpcomingMeeting();
    case "/members_non_executivepage":
      return const ViewNonExecutive();
    case "/meeting_history_page":
      return const MeetingHistory();
    case "/qr_creations_page":
      return const QRCreationsPage();
    case "/current_meeting_user_regitration":
      return const CurrentMeetingUserRegistration();
    case "aboutGib":
      return const AboutGib();
    case '/dasg2g_report_page':
      return const G2GReport();
    case "/business_report_page":
      return const BusinessReport();
    case "/visitors_report_page":
      return const VisitorsReport();
    case "/thanksnote_report_page":
      return const ThanksNoteReport();
    case "/view_images_gallery":
      return const ViewPhotos();
    case "/total_individual_report":
      return const TotalIndividual();
    case "/members_report_page":
      return const MembersReport();
    case "/gib_achievements_view_images_gallery":
      return const AchievementViewPhotos();
    case '/list_ads_page':
      return const ListAds();
    case '/add_member_type':
      return const AddMember();
    case '/add_pagination':
      return const Pagination();
    case "/settingspage":
      return const Setting();
    case "/current_meeting_page":
      return const CurrentMeetingAttendance();
    case "/add_member_category":
      return const MemberCategory();
    case "/super_user":
      return const SuperUser();
    case "/guest_page":
      return const Guest();
    case '/honoring_report':
      return const HonoringReport();
    case "/SetPersonSubscription":
      return const SetPersonSubscrption();
  }
  return null;
}

class MyScaffold extends StatefulWidget {
  const MyScaffold({
    Key? key,
    required this.route,
    required this.body,
  }) : super(key: key);

  final Widget body;
  final String route;

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  final List<AdminMenuItem> _sideBarItems = [
    //Dashboard
    const AdminMenuItem(
      title: 'DashBoard',
      route: "/",
      icon: Icons.dashboard,
    ),
    const AdminMenuItem(
      title: 'Super Admin',
      route: "/superAdmin",
      icon: Icons.dashboard,
    ),
    //Members
    const AdminMenuItem(
      title: 'Members',
      icon: Icons.person,
      children: [
        //New Member Approval
        AdminMenuItem(
          title: "New Member Approval",
          route: '/new_member_approval',
        ),
        //Member Registration
        AdminMenuItem(
          title: 'Member Registration',
          route: '/new_member_registration',
        ),
        //Member View /Edit
        AdminMenuItem(
          title: 'Member View /Edit',
          children: [
            //Executive
            AdminMenuItem(
              title: "Executive Men's Wing",
              route: '/view_executive_members',
            ),
            AdminMenuItem(
                title: "Executive Women's Wing",
                route: "/womens_executive_members"),
            //Non Executive
            AdminMenuItem(
              title: 'Non Executive',
              route: "/members_non_executivepage",
              //  icon: Icons.image,
            ),
            //Woman's Wing
          ],
        ),
        // Member Block and Unblock
        AdminMenuItem(
            title: 'Member Block and Unblock', route: "/member_block_unblock"),
        AdminMenuItem(title: 'Guest', route: "/guest_page"),
      ],
    ),
    //GiB Team
    const AdminMenuItem(title: 'GiB Team', icon: Icons.people_alt, children: [
      //Team Creations
      AdminMenuItem(title: 'Team Creations', route: '/team_creation'),
      //Team Allocation
      AdminMenuItem(title: 'Team Allocation', route: '/allocation_details'),
      //Allocated Team View
      AdminMenuItem(
          title: 'Allocated Team View', route: '/allocated_team_view'),
    ]),
    //Rewards
    /* const AdminMenuItem(
      title: 'Rewards',
      route: '/rewards',
      icon: Icons.money,
    ),*/
    //Subscription
    const AdminMenuItem(
        title: 'Subscription',
        icon: Icons.subscriptions,
        children: [
          AdminMenuItem(title: 'Subscription', route: '/subscription'),
          AdminMenuItem(
              title: 'Subscribe Edit/delete',
              route: '/subscription_edit_delete'),
          AdminMenuItem(
              title: 'Member Add To Subscription',
              route: "/SetPersonSubscription"),
        ]),
    //Meeting
    const AdminMenuItem(
        title: 'Meeting',
        icon: Icons.edit_note_sharp,
        children: [
          //Create Meeting
          AdminMenuItem(title: 'Create Meeting', route: '/create_meeting'),
          //Upcoming Meeting
          AdminMenuItem(
              title: 'Upcoming Meeting', route: "/upcomingmeeting_page"),
          //Meeting History
          AdminMenuItem(
              title: 'Meeting History', route: "/meeting_history_page"),
          //QR Creations
          AdminMenuItem(title: 'QR Creations', route: "/qr_creations_page"),
          //Current Meeting User Registration
          AdminMenuItem(
              title: 'Current Meeting User Registration',
              route: "/current_meeting_user_regitration"),
        ]),
    //Settings
    const AdminMenuItem(
        title: 'Settings',
        icon: Icons.settings_rounded,
        children: [
          //Add Business Category
          /*  AdminMenuItem(
              title: 'Add Business Category',
              route:'/add_business_category'),*/
          //View/Edit Category
          /* AdminMenuItem(
            title: 'Pagination',
            route: '/add_pagination'),*/
          //Add Meeting Type
          /*AdminMenuItem(
              title: 'Add Meeting Type',
              route:'/add_meeting_type'),*/
          //Add Member Role
          AdminMenuItem(title: 'Add Member Role', route: '/add_member_role'),
          AdminMenuItem(title: 'Add Member Type', route: '/add_member_type'),
          AdminMenuItem(
              title: 'Add Member Category', route: '/add_member_category'),
          AdminMenuItem(title: 'About ', route: "aboutGib"),
          AdminMenuItem(title: 'About Edit', route: "/EditAbout"),
        ]),
    //Gallery
    const AdminMenuItem(title: 'Gallery', icon: Icons.photo_album, children: [
      AdminMenuItem(title: 'Add Photos', route: '/add_photos'),
      AdminMenuItem(title: 'View Photos', route: "/view_images_gallery"),
    ]),
    //GIB Achievements
    const AdminMenuItem(
        title: 'GIB Achievements',
        icon: Icons.photo_album,
        children: [
          AdminMenuItem(title: 'Add Photos', route: 'gib_achieve_add_photos'),
          AdminMenuItem(
              title: 'View Photos',
              route: "/gib_achievements_view_images_gallery"),
        ]),
    //Ad's
    const AdminMenuItem(title: "Ad's", icon: Icons.leak_add, children: [
      AdminMenuItem(title: "Add-Ad's", route: '/add_ads'),
      AdminMenuItem(title: "List-Ad's", route: '/list_ads_page'),
    ]),
    //Show Attendance
    const AdminMenuItem(
      title: "Today Attendance",
      icon: Icons.view_carousel,
      route: '/today_attendance',
    ),
    //Current Meeting Attendance
    /* const AdminMenuItem(
      title: "Current Meeting Attendance",
      icon: Icons.view_carousel,
      route: '/current_meeting_page',
    ),*/
    //Reports
    const AdminMenuItem(title: 'Reports', icon: Icons.report, children: [
      //Business Report
      AdminMenuItem(title: 'Business Report', route: '/business_report_page'),
      //G2G Report
      AdminMenuItem(title: 'G2G Report', route: '/dasg2g_report_page'),
      //Guest Report
      AdminMenuItem(title: 'Guest Report', route: '/visitors_report_page'),
      //Honoring Report
      AdminMenuItem(title: 'Honoring Report', route: '/honoring_report'),
      AdminMenuItem(
          title: 'Individual Report', route: "/total_individual_report"),
      //Members Report
      AdminMenuItem(title: 'Members Report', route: "/members_report_page"),
    ]),

    /* const AdminMenuItem(
        title: 'Super User',
        icon: Icons.account_circle,
        route: '/super_user')*/
  ];

// AppBar Image [List]
  final List<AdminMenuItem> _adminMenuItems = const [
    AdminMenuItem(
      title: 'User Profile',
      icon: Icons.account_circle,
      route: '/',
    ),
    AdminMenuItem(
      title: 'Settings',
      icon: Icons.settings,
      route: '/',
    ),
    AdminMenuItem(
      title: 'Logout',
      icon: Icons.logout,
      route: '/',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white38,
      sideBar: SideBar(
        width: 330,
        backgroundColor: Colors.green.shade900,
        activeBackgroundColor: Colors.green.shade600,
        borderColor: Colors.green.shade900,
        iconColor: Colors.white,
        activeIconColor: Colors.green.shade900,
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          // fontWeight: FontWeight.bold
          //   fontWeight: FontWeight.bold
        ),
        activeTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          //    fontWeight: FontWeight.bold
          //  fontWeight: FontWeight.bold
        ),
        items: _sideBarItems,
        selectedRoute: widget.route,
        onSelected: (item) {
          Navigator.of(context).pushNamed(item.route!);
        },
        header: SizedBox(
          width: 500,
          height: 150,
          child: Container(
            color: Colors.green.shade900,
            // height: 130,
            // width: 500,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/handlogo.png"),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: widget.body,
        ),
      ),
    );
  }
}

class _TopPortion extends StatelessWidget {
  const _TopPortion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    /*Color(0xff0043ba), Color(0xff006df1)*/ Colors.blueGrey,
                    Colors.green.shade900
                  ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              )),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: 150,
            height: 200,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/handlogo.png")),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
