import 'package:flutter/material.dart';
import 'package:quotes_pagination/models/quotes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Fetched Quotes
  List<Quotes> _quotes = [];
  bool loading = true;
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    QuoteServiceHander.getQuotes(
      0,
    ).then((data) {
      setState(() {
        _quotes = data;
        loading = false;
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        currentIndex++;
        QuoteServiceHander.getQuotes(currentIndex).then((value) {
          setState(() {
            _quotes.addAll(value);
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9FA),
      appBar: AppBar(
        title: const Text('Quotes'),
        backgroundColor: const Color(0xff304FFE),
      ),
      body: (loading)
          ? const CProgress()
          : ListView.builder(
              controller: _scrollController,
              itemBuilder: ((context, index) {
                return (index == _quotes.length)
                    ? const CProgress()
                    : QuoteTile(
                        quote: _quotes[index],
                      );
              }),
              itemCount: _quotes.length + 1,
            ),
    );
  }
}

class QuoteTile extends StatelessWidget {
  final Quotes quote;
  const QuoteTile({
    Key? key,
    required this.quote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildQuote(),
          _buildWriter(),
          _buildTags(),
          _buildActionBar(),
        ],
      ),
    );
  }

  Widget _buildQuote() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        quote.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xff212121),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildWriter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            '- ${quote.author}',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff212121),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      children: quote.tags
          .map(
            (e) => Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xff304FFE),
                ),
              ),
              child: Text(
                '#$e',
                style: const TextStyle(
                  color: Color(0xff304FFE),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildActionBar() {
    return Row(
      children: [
        _buildIcon(
          Icons.favorite_border_rounded,
          Colors.red,
        ),
        _buildIcon(
          Icons.comment_outlined,
          Colors.blue,
        ),
        _buildIcon(
          Icons.share,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildIcon(IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        icon,
        size: 22,
        color: color,
      ),
    );
  }
}

class CProgress extends StatelessWidget {
  const CProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
