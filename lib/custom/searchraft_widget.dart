import 'package:flutter/material.dart';
import 'package:flutter_raft/utils/constant.dart';

class SearchRaftWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchRaftWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchRaftWidgetState createState() => _SearchRaftWidgetState();
}

class _SearchRaftWidgetState extends State<SearchRaftWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final styleActive = TextStyle(color: Colors.black);
    // final styleHint = TextStyle(color: Colors.black54);
    // final style = widget.text.isEmpty ? styleHint : styleActive;
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              controller: controller,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                ),
                suffixIcon: widget.text.isNotEmpty
                    ? GestureDetector(
                        child: Icon(
                          Icons.close,
                        ),
                        onTap: () {
                          controller.clear();
                          widget.onChanged('');
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                      )
                    : null,
                hintText: widget.hintText,
                border: InputBorder.none,
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
