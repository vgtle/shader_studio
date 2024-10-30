import 'package:flutter/material.dart';

class DynamicIsland extends StatelessWidget {
  const DynamicIsland(
      {super.key,
      required this.listening,
      required this.loading,
      required this.recognizedWords,
      required this.answer});

  final bool listening;
  final bool loading;
  final List<String> recognizedWords;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      left: listening && recognizedWords.isNotEmpty ? 22 : 140,
      right: listening && recognizedWords.isNotEmpty ? 22 : 140,
      top: 11,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: AnimatedSize(
          alignment: AlignmentDirectional.topCenter,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          child: Row(
            children: [
              if (loading) ...[
                const SizedBox(
                  width: 75,
                  height: 37,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.4,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                )
              ] else if (listening && recognizedWords.isNotEmpty) ...[
                Expanded(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.only(
                        top: listening && recognizedWords.isNotEmpty && !loading
                            ? 36
                            : 0),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        answer.isNotEmpty ? answer : recognizedWords.join(' '),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 30,
                        softWrap: true,
                      ),
                    ),
                  ),
                ),
              ] else
                const Expanded(
                  child: SizedBox(
                    height: 37,
                    width: 2000,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
