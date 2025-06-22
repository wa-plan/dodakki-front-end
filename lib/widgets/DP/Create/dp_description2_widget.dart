import 'package:flutter/material.dart';

class Description2 extends StatelessWidget {
  final Color color;

  const Description2(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> smartItems = [
      {"letter": "S", "title": "Specific", "desc": "명확하고 구체적인 목표"},
      {"letter": "M", "title": "Measurable", "desc": "측정 가능한 목표"},
      {"letter": "A", "title": "Attainable", "desc": "달성 가능한 목표"},
      {"letter": "R", "title": "Realistic", "desc": "현실적인 목표"},
      {"letter": "T", "title": "Timely", "desc": "마감기한이 있는 목표"},
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: ExpansionTile(
        backgroundColor: const Color(0xff2A2A2A),
        collapsedBackgroundColor: const Color(0xff2A2A2A),
        childrenPadding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        tilePadding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        iconColor: const Color(0xffAAAAAA),
        collapsedIconColor: const Color(0xffAAAAAA),
        shape: const Border(),
        title: const Text(
          'SMART 기법을 참고해보세요',
          style: TextStyle(
            color: Color(0xffAAAAAA),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: smartItems
            .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _buildSmartItem(
                    letter: item["letter"]!,
                    title: item["title"]!,
                    description: item["desc"]!,
                    color: color,
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSmartItem({
    required String letter,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      children: [
        Text(
          letter,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
         Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
       
      ],
    );
  }
}
