import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> colors;
  final double? width;
  final double height;
  final double borderRadius;
  final bool isLoading;
  final Widget? icon;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.colors,
    this.width,
    this.height = 56,
    this.borderRadius = 28,
    this.isLoading = false,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _rippleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isLoading) return;
    
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
    
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _rippleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ripple effect
              if (_rippleAnimation.value > 0)
                Container(
                  width: widget.width != null ? widget.width! * 1.5 : 200,
                  height: widget.height * 1.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.colors.first.withOpacity(
                      0.2 * (1 - _rippleAnimation.value),
                    ),
                  ),
                ),
              
              // Main button
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: widget.colors.first.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleTap,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: Center(
                      child: widget.isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.icon != null) ...[
                                  widget.icon!,
                                  SizedBox(width: 8),
                                ],
                                Text(
                                  widget.text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    ),
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
