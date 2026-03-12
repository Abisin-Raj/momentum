import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/core/services/settings_service.dart';

class GymTeamScreen extends ConsumerStatefulWidget {
  const GymTeamScreen({super.key});

  @override
  ConsumerState<GymTeamScreen> createState() => _GymTeamScreenState();
}

class _GymTeamScreenState extends ConsumerState<GymTeamScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();
    setState(() => _isTyping = true);

    // 1. Add user message to UI (In a real app, this would be saved to DB)
    // For this prototype, we'll simulate a group chat with both Gemini and ChatGPT.

    try {
      final geminiKey = await ref.read(settingsServiceProvider).getGeminiKey();
      final gemini2Key = await ref.read(settingsServiceProvider).getGemini2Key();
      final groqKey = await ref.read(settingsServiceProvider).getGroqKey();

      // Simulate group chat responses
      if (geminiKey != null && geminiKey.isNotEmpty) {
        // Build Gemini Alpha response logic here
      }
      
      if (gemini2Key != null && gemini2Key.isNotEmpty) {
        // Build Gemini Beta response logic here
      }

      if (groqKey != null && groqKey.isNotEmpty) {
        // Build Groq Speedster response logic here
      }

    } catch (e) {
      debugPrint('Error in Gym Team Chat: $e');
    } finally {
      if (mounted) setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('GYM TEAM', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text('Gemini & Groq Agents', style: TextStyle(fontSize: 10, letterSpacing: 1.2)),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSystemMessage(
                  'Welcome to the Gym Team! Your Gemini and Groq experts are ready to help you reach your goals.',
                ),
                _buildChatMessage(
                  role: 'Gemini Alpha',
                  message: 'Hey Athlete! I specialize in data analysis and form. How was your workout today?',
                  isAi: true,
                  color: Colors.blueAccent,
                ),
                _buildChatMessage(
                  role: 'Gemini Beta',
                  message: 'I can help with nutrition planning and motivation. Let’s get started!',
                  isAi: true,
                  color: Colors.cyanAccent,
                ),
                _buildChatMessage(
                  role: 'Groq Speedster',
                  message: 'I\'m here for lightning-fast responses and quick tips. What\'s on your mind?',
                  isAi: true,
                  color: Colors.orangeAccent,
                ),
              ],
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(minHeight: 2),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildSystemMessage(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildChatMessage({
    required String role,
    required String message,
    required bool isAi,
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAi 
              ? color?.withValues(alpha: 0.1) ?? colorScheme.surfaceContainerHighest
              : colorScheme.primary,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: isAi ? const Radius.circular(0) : const Radius.circular(16),
            bottomRight: isAi ? const Radius.circular(16) : const Radius.circular(0),
          ),
          border: isAi ? Border.all(color: color?.withValues(alpha: 0.3) ?? Colors.transparent) : null,
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isAi)
              Text(
                role.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color ?? colorScheme.primary,
                  letterSpacing: 1.0,
                ),
              ),
            if (isAi) const SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(
                color: isAi ? colorScheme.onSurface : colorScheme.onPrimary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Message your team...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
