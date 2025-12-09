import 'package:flutter/material.dart';
import 'package:projectapp/Providers/UploadingScholarshipFlowProvider.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});
  
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with TickerProviderStateMixin {
  late AnimationController _tickController;
  late Animation<double> _tickAnimation;

  late AnimationController _textController;
  late Animation<double> _textAnimation;
  late UploadingScholarshipFlowProvider _uploadingScholarshipFlowProvider;

  @override
  void initState() {
    super.initState();

    // Tick animation
    _tickController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _tickAnimation = CurvedAnimation(
      parent: _tickController,
      curve: Curves.elasticOut,
    );

    // Text fade-in animation
    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    // Start animations with a delay
    _tickController.forward().then((_) {
      _textController.forward();
    });
  }



  @override void didChangeDependencies() {
    super.didChangeDependencies();
    _uploadingScholarshipFlowProvider = Provider.of<UploadingScholarshipFlowProvider>(context);
  }

  @override
  void dispose() {
    _tickController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _tickAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  padding: EdgeInsets.all(32),
                  child: Icon(
                    Icons.check,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 24),
              FadeTransition(
                opacity: _textAnimation,
                child: Column(
                  children: [
                    Text(
                      'Done Successfully!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      ' ${_uploadingScholarshipFlowProvider.uploadedScholarships.length} Scholarships have been inserted successfully.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36),
              FadeTransition(
                opacity: _textAnimation,
                child: ElevatedButton(
                  onPressed: () {
                    _uploadingScholarshipFlowProvider.reset();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}