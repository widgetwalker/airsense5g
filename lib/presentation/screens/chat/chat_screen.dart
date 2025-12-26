import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isLoading;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isLoading = false,
  });
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(
      ChatMessage(
        id: '0',
        text: 'Hello! I\'m your Air Quality Assistant. I can help you with:\n\n• Understanding AQI levels\n• Health recommendations\n• Pollutant information\n• Historical data analysis\n\nHow can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Replies
          if (_messages.length == 1) _buildQuickReplies(),
          
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),

          // Typing Indicator
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    child: Icon(Icons.smart_toy, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTypingDot(0),
                        const SizedBox(width: 4),
                        _buildTypingDot(1),
                        const SizedBox(width: 4),
                        _buildTypingDot(2),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  mini: true,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    final quickReplies = [
      'What is AQI?',
      'Is it safe to go outside?',
      'Health tips',
      'Show pollutants',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: quickReplies.map((reply) {
          return ActionChip(
            label: Text(reply),
            onPressed: () => _sendQuickReply(reply),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.smart_toy, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isUser
                          ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                          : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: (value + index * 0.3) % 1.0,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  final Dio _dio = Dio();
  Map<String, dynamic>? _latestSensorData;

  Future<void> _fetchSensorData() async {
    try {
      // connecting to localhost (change to 10.0.2.2 for Android Emulator)
      final response = await _dio.get('http://localhost:5000/api/data');
      if (response.statusCode == 200) {
        _latestSensorData = response.data;
      }
    } catch (e) {
      debugPrint('Error fetching sensor data: $e');
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Get AI response
    _getAIResponse(text);
  }

  Future<void> _getAIResponse(String query) async {
    // Fetch latest data before responding
    await _fetchSensorData();

    // Simulate thinking delay for better UX
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    String responseText = _generateResponse(query);

    setState(() {
      _isTyping = false;
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: responseText,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
    _scrollToBottom();
  }

  void _sendQuickReply(String text) {
    _messageController.text = text;
    _sendMessage();
  }

  String _generateResponse(String query) {
    final lowerQuery = query.toLowerCase();
    
    // Formatting helper
    String getVal(String key) {
        if (_latestSensorData == null || !_latestSensorData!.containsKey(key)) return 'N/A';
        return _latestSensorData![key].toString();
    }

    if (lowerQuery.contains('aqi') || lowerQuery.contains('air quality index')) {
      final aqi = getVal('aqi'); // Assuming 'aqi' is in the payload or we calculate it. 
      // If direct AQI isn't available, we might construct it or fallback. 
      // For now, let's assume raw values are what we show or we show a generic message if missing.
      return 'Current Air Quality Data:\nAQI: $aqi\n\n(Note: 0-50 Good, 51-100 Moderate, >100 Unhealthy)';
    } else if (lowerQuery.contains('safe') || lowerQuery.contains('outside')) {
       final pm25 = double.tryParse(getVal('pm2_5')) ?? 0;
       String safetyMsg = pm25 > 35 ? 'Unhealthy 🔴. Stay indoors.' : 'Safe ✅. Enjoy the outdoors!';
       return 'Safety Assessment based on PM2.5 ($pm25 µg/m³):\n$safetyMsg';
    } else if (lowerQuery.contains('health') || lowerQuery.contains('tip')) {
      return 'Real-time Health Tips:\n• Monitor PM2.5 (${getVal('pm2_5')} µg/m³)\n• Monitor CO2 (${getVal('co2')} ppm)\n\nIf levels are high, use an air purifier and ensure proper ventilation.';
    } else if (lowerQuery.contains('pollutant')) {
      return 'Real-time Pollutants:\n\n• PM2.5: ${getVal('pm2_5')} µg/m³\n• PM10: ${getVal('pm10')} µg/m³\n• CO2: ${getVal('co2')} ppm\n• TVOC: ${getVal('tvoc')} ppb\n• Humidity: ${getVal('humidity')} %\n• Temperature: ${getVal('temperature')} °C';
    } else if (lowerQuery.contains('forecast') || lowerQuery.contains('predict') || lowerQuery.contains('tomorrow')) {
      // Fetch forecast from API
      _fetchForecast(lowerQuery);
      return '📊 Fetching forecast data...';
    } else {
      return 'I can help you with:\n• Current air quality (ask "AQI" or "pollutants")\n• Safety assessment (ask "is it safe?")\n• Health tips\n• Forecasts (ask "forecast" or "tomorrow")\n\n(Data Source: Live MQTT + ML Predictions)';
    }
  }

  Future<void> _fetchForecast(String query) async {
    try {
      String endpoint = 'http://localhost:5000/api/predict';
      
      // Determine which forecast to fetch
      if (query.contains('24') || query.contains('hour') || query.contains('tomorrow')) {
        endpoint = 'http://localhost:5000/api/forecast/24h';
      } else if (query.contains('week') || query.contains('7 day')) {
        endpoint = 'http://localhost:5000/api/forecast/week';
      }
      
      final response = await _dio.get(endpoint);
      
      if (response.statusCode == 200) {
        String forecastText = _formatForecastResponse(response.data, endpoint);
        
        // Add forecast message to chat
        if (mounted) {
          setState(() {
            _isTyping = false;
            _messages.add(
              ChatMessage(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                text: forecastText,
                isUser: false,
                timestamp: DateTime.now(),
              ),
            );
          });
          _scrollToBottom();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add(
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              text: '⚠️ Forecast unavailable. Make sure:\n1. mqtt_pipeline.py is running\n2. ML models are trained (run train_model.py)',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
        _scrollToBottom();
      }
    }
  }

  String _formatForecastResponse(Map<String, dynamic> data, String endpoint) {
    if (endpoint.contains('24h')) {
      // Format 24-hour forecast
      final forecast = data['forecast'] as List;
      final first = forecast[0]['values'];
      final mid = forecast[11]['values'];
      final last = forecast[23]['values'];
      
      return '📊 24-Hour Forecast:\n\n'
          'Next Hour:\n'
          '• PM2.5: ${first['pm2_5']} µg/m³\n'
          '• PM10: ${first['pm10']} µg/m³\n'
          '• CO2: ${first['co2']} ppm\n\n'
          'In 12 Hours:\n'
          '• PM2.5: ${mid['pm2_5']} µg/m³\n'
          '• PM10: ${mid['pm10']} µg/m³\n\n'
          'In 24 Hours:\n'
          '• PM2.5: ${last['pm2_5']} µg/m³\n'
          '• PM10: ${last['pm10']} µg/m³\n\n'
          '💡 Trend: ${_getTrend(first['pm2_5'], last['pm2_5'])}';
    } else if (endpoint.contains('week')) {
      // Format 7-day forecast
      final forecast = data['forecast'] as List;
      String weekText = '📅 7-Day Forecast:\n\n';
      
      for (var day in forecast.take(3)) {
        final values = day['values'];
        weekText += 'Day ${day['day']} (${day['date']}):\n'
            '• PM2.5: ${values['pm2_5']} µg/m³\n'
            '• PM10: ${values['pm10']} µg/m³\n\n';
      }
      
      weekText += '💡 View full forecast in Forecast tab';
      return weekText;
    } else {
      // Format single prediction
      final pred = data['predictions'];
      return '🔮 Next Hour Prediction:\n\n'
          '• PM2.5: ${pred['pm2_5']} µg/m³\n'
          '• PM10: ${pred['pm10']} µg/m³\n'
          '• CO2: ${pred['co2']} ppm\n'
          '• TVOC: ${pred['tvoc']} ppb\n'
          '• Temperature: ${pred['temperature']} °C\n'
          '• Humidity: ${pred['humidity']} %';
    }
  }

  String _getTrend(dynamic start, dynamic end) {
    final startVal = start is num ? start.toDouble() : double.tryParse(start.toString()) ?? 0;
    final endVal = end is num ? end.toDouble() : double.tryParse(end.toString()) ?? 0;
    
    if (endVal < startVal * 0.9) return 'Improving ✅';
    if (endVal > startVal * 1.1) return 'Worsening ⚠️';
    return 'Stable ➡️';
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text('Are you sure you want to clear all messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  ChatMessage(
                    id: '0',
                    text: 'Hello! How can I help you today?',
                    isUser: false,
                    timestamp: DateTime.now(),
                  ),
                );
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
