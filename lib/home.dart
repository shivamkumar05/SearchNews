import 'package:flutter/material.dart';
import 'package:chaleno/chaleno.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'News/category.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 56, 105, 142),
        title: GestureDetector(
          //child: Row(
          //     children: [
          //       Flexible(
          //         child: TextField(
          //           style: TextStyle(color: Colors.white),
          //           decoration: InputDecoration(
          //             filled: true,
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(25.0),
          //               borderSide: BorderSide.none,
          //             ),
          //             hintText: 'Search for web...',
          //             hintStyle: TextStyle(color: Colors.white),
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.mic),
          //         onPressed: () {},
          //       ),
          //     ],
          //   ),
          // ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if ((searchController.text).replaceAll(" ", "") == "") {
                    print("Blank search");
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen(
                                  Query: searchController.text,
                                )));
                  }
                },
                child: Container(
                  child: const Icon(
                    Icons.search,
                    color: Colors.blueAccent,
                  ),
                  margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    //value store input of searchBar
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryScreen(
                                  Query: value,
                                )));
                  },
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: "Search Here"),
                ),
              )
            ],
          ),
        ),
        // body:Container(
        //       //Search Wala Container

        //       padding: const EdgeInsets.symmetric(horizontal: 8),
        //       margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        //       decoration: BoxDecoration(
        //           color: Colors.white, borderRadius: BorderRadius.circular(24)),
        //       child: Row(
        //         children: [
        //           GestureDetector(
        //             onTap: () {
        //               if ((searchController.text).replaceAll(" ", "") == "") {
        //                 print("Blank search");
        //               } else {
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => CategoryScreen(
        //                               Query: searchController.text,
        //                             )));
        //               }
        //             },
        //             child: Container(
        //               child: const Icon(
        //                 Icons.search,
        //                 color: Colors.blueAccent,
        //               ),
        //               margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
        //             ),
        //           ),
        //           Expanded(
        //             child: TextField(
        //               controller: searchController,
        //               textInputAction: TextInputAction.search,
        //               onSubmitted: (value) {
        //                 //value store input of searchBar
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => CategoryScreen(
        //                               Query: value,
        //                             )));
        //               },
        //               decoration: const InputDecoration(
        //                   border: InputBorder.none, hintText: "Search Here"),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:chaleno/chaleno.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// void main(List<String> arguments) {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'URL Launcher Demo',
//       home: MyHomePage(),
//     );
//   }
// }

class ScrapPage extends StatefulWidget {
  @override
  _ScrapPageState createState() => _ScrapPageState();
}

class _ScrapPageState extends State<ScrapPage> {
  final _searchController = TextEditingController();
  List<String> _urls = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _scrapData(String url) async {
    if (!url.startsWith('https://')) {
      url = 'https://' + url;
    }
    var response = await Chaleno().load(url);

    List<Result>? results = response!.getElementsByTagName('a');
    var n = results!.length;

    List<String> urls = [];

    for (var i = 0; i < n; i++) {
      String href = results[i].attr('href') ?? '';
      if (href.startsWith('https://')) {
        urls.add(href);
      }
    }

    setState(() {
      _urls = urls;
    });
  }

  void _launchURL(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebViewPage(url)),
    );
  }

  String _stripHtmlTags(String html) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return html.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('URL Launcher Demo'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter a URL to scrape',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _scrapData(_searchController.text); // Call _scrapData here
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _urls.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.all(8),
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 450,
                          height: 90,
                          // width: 10,
                          child: ListTile(
                            title: Text(
                              _urls[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: FutureBuilder<String>(
                              future:
                                  Chaleno().load(_urls[index]).then((response) {
                                List<Result>? results =
                                    response?.getElementsByTagName('meta');
                                var n = results?.length ?? 0;

                                for (var i = 0; i < n; i++) {
                                  var name = results![i].attr('name');
                                  if (name != null &&
                                      name.toLowerCase() == 'description') {
                                    String description =
                                        results[i].attr('content') ?? '';
                                    return _stripHtmlTags(description);
                                  }
                                }

                                return '';
                              }),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  String description = snapshot.data!;
                                  if (description.length > 150) {
                                    description =
                                        description.substring(0, 170) + '...';
                                  }
                                  return Text(description);
                                } else {
                                  return Text('Loading...');
                                }
                              },
                            ),
                            onTap: () {
                              _launchURL(_urls[index]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(url),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
