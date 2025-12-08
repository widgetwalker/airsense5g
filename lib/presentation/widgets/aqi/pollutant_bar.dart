import 'package:flutter/material.dart';
import 'package:air_quality_guardian/core/utils/aqi_utils.dart';
import 'package:air_quality_guardian/core/constants/aqi_constants.dart';

class PollutantBar extends StatelessWidget {
  final String pollutantName;
  final double value;
  final String unit;
  final double whoGuideline;

  const PollutantBar({
    required this.pollutantName, required this.value, required this.unit, required this.whoGuideline, super.key,
  });

  @override
  Widget build(BuildContext context) {
    final status = AqiUtils.getPollutantStatus(pollutantName, value);
    final percentage = (value / (whoGuideline * 3)).clamp(0.0, 1.0);
    
    Color statusColor;
    if (status == 'good') {
      statusColor = AqiConstants.colorGood;
    } else if (status == 'moderate') {
      statusColor = AqiConstants.colorModerate;
    } else {
      statusColor = AqiConstants.colorUnhealthy;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pollutantName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${value.toStringAsFixed(1)} $unit',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              // Background bar
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Progress bar
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'WHO Guideline: ${whoGuideline.toStringAsFixed(1)} $unit',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }
}
