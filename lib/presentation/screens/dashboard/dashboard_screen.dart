import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_quality_guardian/presentation/providers/dashboard_provider.dart';
import 'package:air_quality_guardian/presentation/screens/dashboard/widgets/aqi_gauge.dart';
import 'package:air_quality_guardian/presentation/screens/dashboard/widgets/risk_card.dart';
import 'package:air_quality_guardian/presentation/screens/dashboard/widgets/suggestions_card.dart';
import 'package:air_quality_guardian/presentation/widgets/aqi/pollutant_bar.dart';
import 'package:air_quality_guardian/core/constants/aqi_constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchDashboardData();
      // Set mock health profile
      context.read<DashboardProvider>().setHealthProfile(
        [AqiConstants.conditionAsthma],
        4,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading data',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => provider.fetchDashboardData(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.currentSensor == null) {
            return const Center(
              child: Text('No data available'),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          provider.currentSensor!.name,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // AQI Gauge
                  Center(
                    child: AqiGauge(
                      value: provider.currentSensor!.currentAqi,
                      size: 220,
                      onTap: () {
                        // TODO: Show pollutant details
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Last Updated
                  Center(
                    child: Text(
                      'Last updated: ${_formatTime(provider.currentSensor!.lastUpdated)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Risk Assessment
                  RiskCard(
                    riskLevel: provider.riskLevel,
                    riskColor: provider.riskColor,
                    explanation:
                        'Based on your asthma condition and current AQI levels',
                  ),
                  const SizedBox(height: 16),

                  // Health Suggestions
                  SuggestionsCard(
                    suggestions: provider.healthSuggestions,
                  ),
                  const SizedBox(height: 16),

                  // Pollutant Breakdown
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pollutant Levels',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          PollutantBar(
                            pollutantName: AqiConstants.pollutantPM25,
                            value:
                                provider.currentSensor!.pollutants['PM2.5'] ??
                                    0,
                            unit: 'µg/m³',
                            whoGuideline: AqiConstants.whoGuidelinePM25,
                          ),
                          PollutantBar(
                            pollutantName: AqiConstants.pollutantPM10,
                            value:
                                provider.currentSensor!.pollutants['PM10'] ?? 0,
                            unit: 'µg/m³',
                            whoGuideline: AqiConstants.whoGuidelinePM10,
                          ),
                          PollutantBar(
                            pollutantName: AqiConstants.pollutantO3,
                            value:
                                provider.currentSensor!.pollutants['O3'] ?? 0,
                            unit: 'ppb',
                            whoGuideline: AqiConstants.whoGuidelineO3,
                          ),
                          PollutantBar(
                            pollutantName: AqiConstants.pollutantNO2,
                            value:
                                provider.currentSensor!.pollutants['NO2'] ?? 0,
                            unit: 'ppb',
                            whoGuideline: AqiConstants.whoGuidelineNO2,
                          ),
                          PollutantBar(
                            pollutantName: AqiConstants.pollutantSO2,
                            value:
                                provider.currentSensor!.pollutants['SO2'] ?? 0,
                            unit: 'ppb',
                            whoGuideline: AqiConstants.whoGuidelineSO2,
                          ),
                          PollutantBar(
                            pollutantName: AqiConstants.pollutantCO,
                            value:
                                provider.currentSensor!.pollutants['CO'] ?? 0,
                            unit: 'ppm',
                            whoGuideline: AqiConstants.whoGuidelineCO,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}
