import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:learnforge_app/core/theme/app_colors.dart' show AppColors;
import 'package:learnforge_app/core/widgets/gradient_button.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String challengeId;

  const ChallengeDetailScreen({Key? key, required this.challengeId})
    : super(key: key);

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late PageController _pageController;
  int _currentPage = 0;
  bool _isJoined = false;
  double _progress = 0.65;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _pageController = PageController();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _joinChallenge() {
    setState(() {
      _isJoined = true;
    });

    // Show success animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.neonGreen ?? Colors.green,
        content: Text(
          'Challenge Joined! Good luck!',
          style: TextStyle(color: AppColors.white, fontFamily: 'Inter'),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  void _submitSolution() {
    // Handle solution submission
    context.push('/challenge/${widget.challengeId}/submit');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dark900,
      body: Stack(
        children: [
          // Animated Background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  AppColors.neonPurple.withOpacity(0.15),
                  AppColors.neonCyan.withOpacity(0.1),
                  AppColors.dark900,
                ],
                stops: const [0.1, 0.4, 1.0],
              ),
            ),
          ),

          // Particle Background
          _ChallengeParticles(),

          CustomScrollView(
            slivers: [
              // App Bar with Challenge Image
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Background Image with Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1555949963-aa79dcee981c?w=800&q=80',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.dark900.withOpacity(0.8),
                              Colors.transparent,
                              AppColors.dark900.withOpacity(0.9),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                      // Challenge Badge
                      Positioned(
                        top: 100,
                        right: 20,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.neonPurple,
                                AppColors.neonPink,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.neonPurple.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            'EXPERT',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ).animate().scale(delay: 500.ms),
                      ),
                    ],
                  ),
                  collapseMode: CollapseMode.pin,
                ),
                pinned: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.share_rounded, color: AppColors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.bookmark_border_rounded,
                      color: AppColors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),

              // Challenge Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Stats
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'AI Chatbot Development',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                  ),
                                ).animate().slideX(
                                  begin: -0.3,
                                  end: 0,
                                  duration: 600.ms,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _buildStatItem(
                                      Icons.schedule_rounded,
                                      '7 Days',
                                      AppColors.neonCyan,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildStatItem(
                                      Icons.people_rounded,
                                      '2.4K Joined',
                                      AppColors.neonPurple,
                                    ),
                                    const SizedBox(width: 16),
                                    _buildStatItem(
                                      Icons.star_rounded,
                                      '500 XP',
                                      AppColors.neonPink,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Progress Section (if joined)
                      if (_isJoined) _buildProgressSection(),

                      // Challenge Description
                      _buildSection(
                        title: 'Challenge Overview',
                        icon: Icons.description_rounded,
                        color: AppColors.neonBlue,
                        child: Text(
                          'Build an intelligent AI chatbot using modern NLP techniques. Create a conversational agent that can understand context, maintain conversations, and provide helpful responses across various domains.',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.8),
                            fontSize: 16,
                            height: 1.6,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Requirements
                      _buildSection(
                        title: 'Requirements',
                        icon: Icons.checklist_rounded,
                        color: AppColors.neonGreen ?? Colors.green,
                        child: Column(
                          children: [
                            _buildRequirementItem(
                              'Implement natural language processing',
                            ),
                            _buildRequirementItem(
                              'Support multiple conversation contexts',
                            ),
                            _buildRequirementItem('Handle user authentication'),
                            _buildRequirementItem('Deploy to cloud platform'),
                            _buildRequirementItem(
                              'Write comprehensive documentation',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tech Stack
                      _buildSection(
                        title: 'Tech Stack',
                        icon: Icons.code_rounded,
                        color: AppColors.neonCyan,
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildTechChip('Python', AppColors.neonPurple),
                            _buildTechChip('TensorFlow', AppColors.neonPink),
                            _buildTechChip('React', AppColors.neonBlue),
                            _buildTechChip(
                              'Node.js',
                              AppColors.neonGreen ?? Colors.green,
                            ),
                            _buildTechChip('MongoDB', AppColors.neonCyan),
                            _buildTechChip(
                              'Docker',
                              AppColors.neonYellow ?? Colors.amber,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Prizes and Rewards
                      _buildSection(
                        title: '🏆 Prizes & Rewards',
                        icon: Icons.emoji_events_rounded,
                        color: AppColors.neonYellow ?? Colors.amber,
                        child: Column(
                          children: [
                            _buildPrizeItem(
                              '1st Place',
                              '₹50,000 + Featured on Platform',
                              Icons.workspace_premium_rounded,
                            ),
                            _buildPrizeItem(
                              '2nd Place',
                              '₹25,000 + Premium Subscription',
                              Icons.emoji_events_rounded,
                            ),
                            _buildPrizeItem(
                              '3rd Place',
                              '₹10,000 + Learning Resources',
                              Icons.star_rounded,
                            ),
                            _buildPrizeItem(
                              'All Participants',
                              'Certificate + 500 XP',
                              Icons.card_membership_rounded,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Timeline
                      _buildSection(
                        title: '⏰ Timeline',
                        icon: Icons.timeline_rounded,
                        color: AppColors.neonPurple,
                        child: Column(
                          children: [
                            _buildTimelineItem(
                              'Challenge Starts',
                              'Dec 15, 2024',
                              true,
                            ),
                            _buildTimelineItem(
                              'Submission Deadline',
                              'Dec 22, 2024',
                              false,
                            ),
                            _buildTimelineItem(
                              'Results Announcement',
                              'Dec 25, 2024',
                              false,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.dark900.withOpacity(0.9),
                    AppColors.dark900,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border(
                  top: BorderSide(color: AppColors.dark700, width: 1),
                ),
              ),
              child: Row(
                children: [
                  if (!_isJoined) ...[
                    Expanded(
                      child: GradientButton(
                        text: 'Join Challenge',
                        onPressed: _joinChallenge,
                        gradient: const LinearGradient(
                          colors: [AppColors.neonPurple, AppColors.neonPink],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      flex: 2,
                      child: GradientButton(
                        text: 'Submit Solution',
                        onPressed: _submitSolution,
                        gradient: const LinearGradient(
                          colors: [AppColors.neonCyan, AppColors.neonBlue],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: AppColors.neonPurple.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.forum_rounded,
                            color: AppColors.neonPurple,
                          ),
                          onPressed: () {
                            context.push(
                              '/challenge/${widget.challengeId}/discussion',
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: AppColors.white.withOpacity(0.8),
            fontSize: 14,
            fontFamily: 'Inter',
          ),
        ),
      ],
    ).animate().fadeIn(delay: 800.ms);
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonCyan.withOpacity(0.1),
            AppColors.neonPurple.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.neonCyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Progress',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: TextStyle(
                  color: AppColors.neonCyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.dark700,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                    height: 8,
                    width: MediaQuery.of(context).size.width * _progress * 0.7,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.neonCyan, AppColors.neonBlue],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 2000.ms,
                    color: AppColors.neonCyan.withOpacity(0.3),
                  ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Complete the remaining tasks to finish the challenge',
            style: TextStyle(
              color: AppColors.white.withOpacity(0.6),
              fontSize: 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    ).animate().slideY(begin: 0.5, end: 0, duration: 500.ms);
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.dark800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.dark700, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.neonGreen ?? Colors.green,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.white.withOpacity(0.8),
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechChip(String tech, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        tech,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildPrizeItem(String position, String prize, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  AppColors.neonYellow?.withOpacity(0.2) ??
                  Colors.amber.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.neonYellow ?? Colors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  prize,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String event, String date, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrent ? AppColors.neonPurple : AppColors.dark600,
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: AppColors.neonPurple.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event,
                  style: TextStyle(
                    color: isCurrent ? AppColors.neonPurple : AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: AppColors.white.withOpacity(0.6),
                    fontSize: 14,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced Particle Background for Challenge Screen
class _ChallengeParticles extends StatelessWidget {
  final List<Color> particleColors = [
    AppColors.neonPurple,
    AppColors.neonCyan,
    AppColors.neonPink,
    AppColors.neonBlue,
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return IgnorePointer(
      child: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: List.generate(
            15,
            (index) => Positioned(
              left: _getParticlePosition(screenSize.width, index, true),
              top: _getParticlePosition(screenSize.height, index, false),
              child: _ChallengeParticle(index: index),
            ),
          ),
        ),
      ),
    );
  }

  double _getParticlePosition(double max, int index, bool isWidth) {
    final basePosition = (index / 15) * max;
    final randomOffset = (index * 53) % (max * 0.25);
    return (basePosition + randomOffset) % max;
  }
}

class _ChallengeParticle extends StatelessWidget {
  final int index;
  final List<Color> colors = [
    AppColors.neonPurple,
    AppColors.neonCyan,
    AppColors.neonPink,
    AppColors.neonBlue,
  ];

  _ChallengeParticle({required this.index});

  @override
  Widget build(BuildContext context) {
    final color = colors[index % colors.length];
    final size = 1.0 + (index % 3).toDouble();

    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withOpacity(0.5),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(
          duration: (2200 + index * 400).ms,
          curve: Curves.easeInOut,
          begin: 0.2,
          end: 0.8,
        )
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1.8, 1.8),
          duration: (2800 + index * 500).ms,
          curve: Curves.easeInOut,
        )
        .move(
          duration: (4000 + index * 600).ms,
          curve: Curves.easeInOut,
          begin: const Offset(0, 0),
          end: Offset(
            (index.isEven ? 1 : -1) * 30.0,
            (index % 3 == 0 ? 1 : -1) * 25.0,
          ),
        );
  }
}
