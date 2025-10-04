import 'dart:async';
import 'dart:convert';
import 'package:asmaulhusna/asmaulhusna.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Noor al-Quloob',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Tabs(),
    );
  }
}

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
 title: const Text(
            "Noor al-Quloob",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,   
           bottom: const TabBar(
            tabs: [
              Tab(text: "99 names of Allah"),
              Tab(text: "Hadith"),
              Tab(text: "Azkar"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [namesofallah(), Hadith(), Azkar()],
        ),
      ),
    );
  }
}

class namesofallah extends StatefulWidget {
  const namesofallah({Key? key}) : super(key: key);

  @override
  State<namesofallah> createState() => _namesofallahState();
}

List<Text> nintynineNamesInEnglish() {
  List<Text> names = [];
  int i = 1;
  getEveryEnglishName().forEach((element) {
    names.add(Text('${i.toString()} - $element'));
    i++;
  });
  return names;
}

class _namesofallahState extends State<namesofallah> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg8.jpg"), fit: BoxFit.cover,
        )),
        width: double.infinity,
        height: double.infinity,
        child: PageView.builder(
         
          itemCount: 99,
          itemBuilder: (context, index) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    getArabicName(index + 1),
                    style: GoogleFonts.amiri(fontSize: 40, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                   SizedBox(height: 10),
                  Text(
                    getEnglishName(index + 1),
                    style: TextStyle(fontSize: 24, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                   SizedBox(height: 10),
                  Text(
                    getDescritption(index + 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                   SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Hadith extends StatefulWidget {
  const Hadith({super.key});

  @override
  State<Hadith> createState() => _HadithState();
}

class _HadithState extends State<Hadith> {
  late Map mapresp = {};
  late List listresp = [];
  Future scan() async {
    var apikey =
        "\$2y\$10\$MdvmkF8IO03GeB49PKhcCOtfVdEEF5izh2XMEslCp4NmkPrQ7zu";
    http.Response response = await http.get(Uri.parse("https://www.hadithapi.com/api/books?apiKey=$apikey"));

    if (response.statusCode == 200) {
      setState(() {
       
        mapresp = jsonDecode(response.body);
        listresp = mapresp["books"];
      });
    }
  }

  @override
  void initState() {
  
    super.initState();
   scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("احادیث کی کتابیں", style: TextStyle(fontFamily: "jameel",fontSize: 20), ),
        ),
        titleTextStyle: TextStyle(color: Colors.white),
               backgroundColor: const Color(0xFF1E2A47), 

      ),
      body: listresp.isNotEmpty
          ? ListView.builder(
              itemCount: listresp == null ? 0 : listresp.length,
              itemBuilder: (context, index) {
             return ListTile(
  onTap: () {
    var bookslug = listresp[index]["bookSlug"];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Hadithchapter(bookslug),
      ),
    );
  },
  title: Text(listresp[index]["bookName"]),
  subtitle: Text(listresp[index]["writerName"]),
  leading: CircleAvatar(
    child: Text(listresp[index]["id"].toString()),
  ),
  trailing: Column(
    children: [
      Text(listresp[index]["hadiths_count"]),
      Text(listresp[index]["chapters_count"]),
    ],
  ),
);

              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class Hadithchapter extends StatefulWidget {
  var bookslug;
  Hadithchapter(this.bookslug, {super.key});

  @override
  State<Hadithchapter> createState() => _HadithchapterState();
}

class _HadithchapterState extends State<Hadithchapter> {
  late Map mapresp1 = {};
  late List listresp1 = [];
  Future scan() async {
    var bookname = widget.bookslug;
    var apikey =
        "\$2y\$10\$MdvmkF8IO03GeB49PKhcCOtfVdEEF5izh2XMEslCp4NmkPrQ7zu";
    http.Response response = await http.get(Uri.parse(
        "https://www.hadithapi.com/api/$bookname/chapters?apiKey=$apikey"));

    if (response.statusCode == 200) {
      setState(() {
        mapresp1 = jsonDecode(response.body);
        listresp1 = mapresp1["chapters"];
      });
    }
  }

  @override
  void initState() {
   
    super.initState();
   scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("ابواب حدیث", style: TextStyle(
      fontFamily: "jameel",fontSize: 20),
        ),),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: const Color(0xFF1E2A47),
      ),
      body: listresp1.isNotEmpty
          ? ListView.builder(
              itemCount: listresp1 == null ? 0 : 
              listresp1.length,
              itemBuilder: (context, index) 
              {
                
               return ListTile(
  onTap: () {
    var bookslug = listresp1[index]["bookSlug"];
    var chapnum = listresp1[index]["chapterNumber"];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Hadithscreen(bookslug, chapnum),
      ),
    );
  },
  title: Text(
    listresp1[index]["chapterArabic"],
    style: GoogleFonts.amiriQuran(),
    textDirection: TextDirection.rtl,
  ),
  subtitle: Text(
    listresp1[index]["chapterUrdu"],
    style: const TextStyle(fontFamily: "jameel"),
    textDirection: TextDirection.rtl,
  ),
  trailing: CircleAvatar(
    child: Text(listresp1[index]["id"].toString()),
  ),
);

              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class Hadithscreen extends StatefulWidget {
  var bookslug;
  var chapnum;
  Hadithscreen(this.bookslug, this.chapnum, {super.key});

  @override
  State<Hadithscreen> createState() => _HadithscreenState();
}

class _HadithscreenState extends State<Hadithscreen> {
  late Map mapresp2 = {};
  late List listresp2 = [];
  Future scan() async {
    var bookname = widget.bookslug;
    var chapnum = widget.chapnum;
    var apikey =
        "\$2y\$10\$MdvmkF8IO03GeB49PKhcCOtfVdEEF5izh2XMEslCp4NmkPrQ7zu";
    http.Response response = await http.get(Uri.parse(
        "https://www.hadithapi.com/api/hadiths?apiKey=$apikey&book=$bookname&chapter=$chapnum&paginate=100000"));

    if (response.statusCode == 200) {
      setState(() {
         mapresp2 = jsonDecode(response.body);
        listresp2 = mapresp2["hadiths"]["data"];
      });
    }
  }

  @override
  void initState() {
    
    super.initState();
   scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("احادیث",style: TextStyle(
      fontFamily: "jameel",
      fontSize: 24,) ),
         
        ),
        titleTextStyle: TextStyle(color: Colors.white),
        backgroundColor: const Color(0xFF1E2A47),
      ),
      body: listresp2.isNotEmpty
          ? ListView.builder(
              itemCount: listresp2 == null ? 0 : listresp2.length,
              itemBuilder: (context, index) {
              return ListTile(
title: Column(
  crossAxisAlignment: CrossAxisAlignment.end,
  children: [
    Text(
      listresp2[index]["hadithNumber"].toString(),
      textDirection: TextDirection.ltr,
      style: GoogleFonts.amiriQuran(),
    ),
    const SizedBox(height: 8),
   Text(
  (listresp2[index]["headingArabic"] ?? "").toString(),
  textDirection: TextDirection.ltr,
  style: GoogleFonts.amiriQuran(),
),

    const SizedBox(height: 8),
  ],
),

  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Text(
        listresp2[index]["hadithArabic"],
        textDirection: TextDirection.rtl,
        style: GoogleFonts.amiri(),
      ),
      const SizedBox(height: 8),
      Text(
        listresp2[index]["hadithUrdu"],
        textDirection: TextDirection.rtl,
        style: const TextStyle(fontFamily: "jameel"),
      ),
      const SizedBox(height: 8),
      Text(listresp2[index]["hadithEnglish"]),
    ],
  ),
);

              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}


 
               

class Azkar extends StatefulWidget {
  const Azkar({super.key});

  @override
  State<Azkar> createState() => _AzkarState();
}

class _AzkarState extends State<Azkar> {
  List chapters = [];

  @override
  void initState() {
    super.initState();
    loadChapters();
  }

  Future<void> loadChapters() async {
    String data = await rootBundle.loadString('assets/images/hisn-ul-muslim.json');
    setState(() {
      chapters = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اذکار ', style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 22,)),

        centerTitle: true,
        backgroundColor: const Color(0xFF2F4156), 
      ),
      body: chapters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chapters.length,
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      chapter['english_name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(chapter['arabic_name']),
                  
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AzkarDetailScreen(chapter),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class AzkarDetailScreen extends StatelessWidget {
  var chapter;
   AzkarDetailScreen(this.chapter,{super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
    chapter['english_name'], 
    style: const TextStyle(
      color: Colors.white, 
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
        backgroundColor: const Color(0xFF2F4156), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              color: Colors.white, 
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    
                    Text(
                      chapter['dua_arabic'] ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        fontFamily: 'NotoNaskhArabic',
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 6),
                  
                    Text(
                      chapter['translation'] ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'NotoNaskhArabic',
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}