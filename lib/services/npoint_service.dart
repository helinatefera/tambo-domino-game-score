import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/leaderboard_entry.dart';
import '../utils/npoint_config.dart';

class NPointService {
  /// Fetch the leaderboard from npoint.io
  static Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    try {
      if (NPointConfig.binId == 'YOUR_BIN_ID_HERE') {
        debugPrint('NPoint.io not configured. Please set Bin ID.');
        return [];
      }

      final response = await http.get(
        Uri.parse(NPointConfig.url),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // npoint.io returns the raw JSON we saved.
        // We expect structure: { "record": [...] }
        final record = data['record'];
        
        if (record is List) {
          return record
              .map((entry) => LeaderboardEntry.fromJson(entry))
              .toList()
            ..sort((a, b) {
              // Sort by win count first, then by total score
              if (b.winCount != a.winCount) {
                return b.winCount.compareTo(a.winCount);
              }
              return b.totalScore.compareTo(a.totalScore);
            });
        }
      } else {
        debugPrint('Failed to fetch leaderboard: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching leaderboard from npoint.io: $e');
    }
    return [];
  }

  /// Save the leaderboard to npoint.io (keeping only top 10)
  static Future<bool> saveLeaderboard(List<LeaderboardEntry> leaderboard) async {
    try {
      if (NPointConfig.binId == 'YOUR_BIN_ID_HERE') {
        debugPrint('NPoint.io not configured. Please set Bin ID.');
        return false;
      }

      // Sort and keep only top 10
      leaderboard.sort((a, b) {
        if (b.winCount != a.winCount) {
          return b.winCount.compareTo(a.winCount);
        }
        return b.totalScore.compareTo(a.totalScore);
      });

      final top10 = leaderboard.take(10).toList();
      
      // Convert to JSON
      final jsonData = {
        "record": top10.map((e) => e.toJson()).toList()
      };

      final response = await http.post(
        Uri.parse(NPointConfig.url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        debugPrint('Successfully saved top 10 leaderboard to npoint.io');
        return true;
      } else {
        debugPrint('Failed to save leaderboard: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error saving leaderboard to npoint.io: $e');
      return false;
    }
  }

  /// Add or update a winner in the leaderboard
  static Future<bool> addWinner(String playerName, int finalScore) async {
    try {
      // Fetch current leaderboard
      List<LeaderboardEntry> leaderboard = await fetchLeaderboard();

      // Find existing entry
      final existingIndex = leaderboard.indexWhere(
        (entry) => entry.playerName.toLowerCase() == playerName.toLowerCase(),
      );

      if (existingIndex >= 0) {
        // Update existing entry
        final existing = leaderboard[existingIndex];
        leaderboard[existingIndex] = LeaderboardEntry(
          playerName: existing.playerName,
          winCount: existing.winCount + 1,
          totalScore: existing.totalScore + finalScore,
          lastWinDate: DateTime.now(),
          firstWinDate: existing.firstWinDate,
        );
      } else {
        // Add new entry
        leaderboard.add(
          LeaderboardEntry(
            playerName: playerName,
            winCount: 1,
            totalScore: finalScore,
            lastWinDate: DateTime.now(),
            firstWinDate: DateTime.now(),
          ),
        );
      }

      // Save back to npoint.io (will keep only top 10)
      return await saveLeaderboard(leaderboard);
    } catch (e) {
      debugPrint('Error adding winner to leaderboard: $e');
      return false;
    }
  }
}
