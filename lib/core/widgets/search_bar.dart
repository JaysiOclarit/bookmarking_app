import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final VoidCallback onClose;

  const AnimatedSearchBar(
      {super.key, required this.onChanged, required this.onClose});

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _widthAnimation = Tween<double>(begin: 48, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void toggleSearch() {
    setState(() {
      if (isExpanded) {
        _controller.reverse();
        _textController.clear();
        widget.onChanged('');
        FocusScope.of(context).unfocus();
        widget.onClose(); // Call the close callback
      } else {
        _controller.forward();
      }
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        return Container(
          height: 48,
          width: _widthAnimation.value,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 167, 223, 216),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(isExpanded ? Icons.close : Icons.search,
                    color: Colors.white),
                onPressed: toggleSearch,
              ),
              if (isExpanded)
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: widget.onChanged,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.teal,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 8),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
