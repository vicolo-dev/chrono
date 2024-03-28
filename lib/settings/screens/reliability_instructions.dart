// import 'dart:convert';
//
// import 'package:clock_app/navigation/widgets/app_top_bar.dart';
// import 'package:clock_app/settings/types/vendor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:http/http.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class ReliabilityInstructionsScreen extends StatefulWidget {
//   const ReliabilityInstructionsScreen({super.key, required this.vendor});
//
//   final Vendor vendor;
//
//   @override
//   State<ReliabilityInstructionsScreen> createState() =>
//       _SettingGroupScreenState();
// }
//
// class _SettingGroupScreenState extends State<ReliabilityInstructionsScreen> {
//   late final Future<String> _htmlDataFuture;
//   @override
//   void initState() {
//     super.initState();
//     _htmlDataFuture = _initHtml();
//   }
//
//   Future<String> _initHtml() async {
//     final Response response = await get(
//         Uri.parse('https://dontkillmyapp.com/api/v2${widget.vendor.url}.json'));
//     if (response.statusCode == 200) {
//       // If the server did return a 200 OK response,
//       // then parse the JSON.
//       final json = jsonDecode(response.body);
//       return json["user_solution"];
//     } else {
//       // If the server did not return a 200 OK response,
//       // then throw an exception.
//       throw Exception('Failed to load page');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     final ColorScheme colorScheme = theme.colorScheme;
//     final TextTheme textTheme = theme.textTheme;
//     return Scaffold(
//       appBar: AppTopBar(
//         title: Text(widget.vendor.name,
//             style: textTheme.titleMedium?.copyWith(
//               color: colorScheme.onBackground.withOpacity(0.6),
//             )),
//       ),
//       body: FutureBuilder<String>(
//         future: _htmlDataFuture,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final htmlData = snapshot.data!;
//             return SingleChildScrollView(
//               child: Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: Column(
//                   children: [
//                     Html(
//                       data: htmlData,
//                       onLinkTap: (url, _, __) async {
//                         if (url != null) {
//                           await launchUrl(Uri.parse(url),
//                               mode: LaunchMode.inAppBrowserView);
//                         }
//                       },
//                     ),
//                     const Text(
//                         "Vendor instructions are provided by dontkillmyapp.com"),
//                     TextButton(
//                       onPressed: () async {
//                         await launchUrl(Uri.parse(
//                             "https://dontkillmyapp.com${widget.vendor.url}"));
//                       },
//                       child: const Text("Read more"),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Text('${snapshot.error}');
//           }
//
//           // By default, show a loading spinner.
//           return const SizedBox(
//             width: double.infinity,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 CircularProgressIndicator(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
