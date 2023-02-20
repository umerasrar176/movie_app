import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class seatMapingScreen extends StatefulWidget {
  final String moviename;
  final String realeasdate;
  const seatMapingScreen({Key? key, required this.moviename, required this.realeasdate}) : super(key: key);

  @override
  State<seatMapingScreen> createState() => _seatMapingScreenState();
}

class _seatMapingScreenState extends State<seatMapingScreen> {
  final List<String> dates = [
    'Today',
    'Tomorrow',
    'Monday, 14th Feb',
    'Tuesday, 15th Feb',
    'Wednesday, 16th Feb',
    'Thursday, 17th Feb',
    'Friday, 18th Feb',
  ];

  int? _selectedChipIndex = 1;
  Widget _buildDateChip(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child:  Wrap(
        spacing: 5.0,
        children: List.generate(
            dates.length,
            (index) => ChoiceChip(
              label: Text(dates[index]),
              selected: _selectedChipIndex == index,
              selectedColor: Colors.blue,
              onSelected: (isSelected) {
                setState(() {
                  _selectedChipIndex = isSelected ? index : null;
                });
              },
          ),
        ).toList(),
      )
    );
  }

  Widget _buildSeatTemplate(String hallName, double price, String image) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: 200.0,
        height: 250.0,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: Text(
                hallName,
                style: const TextStyle(color: Colors.black, fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '\$${price.toString()}',
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeatTemplates() {
    return SizedBox(
      height: 220.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildSeatTemplate(
            'Hall 1',
            10.0,
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx6qy1AXvsgpYu8enYMYRkEsoSUuim7FMrEXLn2Kwz7Q&s'
          ),
          _buildSeatTemplate(
            'Hall 2',
            12.0,
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx6qy1AXvsgpYu8enYMYRkEsoSUuim7FMrEXLn2Kwz7Q&s'
          ),
          _buildSeatTemplate(
            'Hall 3',
            15.0,
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx6qy1AXvsgpYu8enYMYRkEsoSUuim7FMrEXLn2Kwz7Q&s'
          ),
          _buildSeatTemplate(
            'Hall 4',
            18.0,
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx6qy1AXvsgpYu8enYMYRkEsoSUuim7FMrEXLn2Kwz7Q&s'
          ),
          _buildSeatTemplate(
            'Hall 5',
            20.0,
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSx6qy1AXvsgpYu8enYMYRkEsoSUuim7FMrEXLn2Kwz7Q&s'
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Text(widget.moviename, style: const TextStyle(color: Colors.black),),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5.0),
          child: Text(
            "In Theaters on ${widget.realeasdate}",
            style: const TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
        ),
        //subtitle: Text("Release Date"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 130,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Date',
              style: TextStyle(fontSize: 20.0 , fontWeight: FontWeight.bold),
            ),
          ),
          // Scrollable row of different dates
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (context, index) {
                return _buildDateChip(dates[index]);
              },
            ),
          ),
          const SizedBox(
            height: 80,
          ),

          _buildSeatTemplates(),
        ],
      ),
    );
  }
}
