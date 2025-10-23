import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wger/l10n/generated/app_localizations.dart';
import 'package:wger/models/exercises/exercise_submission_images.dart';
import 'package:wger/providers/add_exercise.dart';
import 'package:wger/providers/user.dart';
import 'package:wger/widgets/add_exercise/image_details_form.dart';
import 'package:wger/widgets/add_exercise/mixins/image_picker_mixin.dart';
import 'package:wger/widgets/add_exercise/preview_images.dart';

/// Step 5 of exercise creation wizard - Image upload with license metadata
///
/// This step allows users to add exercise images with proper CC BY-SA 4.0 license
/// attribution. Unlike the previous implementation that uploaded images directly,
/// this version collects license metadata (title, author, URLs) before adding images.
///
/// Flow:
/// 1. User picks image from camera/gallery
/// 2. ImageDetailsForm is shown to collect license metadata
/// 3. Image + metadata is stored in AddExerciseProvider
/// 4. Final upload happens in Step 6 when user clicks "Submit"
class Step5Images extends StatefulWidget {
  final GlobalKey<FormState> formkey;

  const Step5Images({required this.formkey});

  @override
  State<Step5Images> createState() => _Step5ImagesState();
}

class _Step5ImagesState extends State<Step5Images> with ExerciseImagePickerMixin {
  /// Currently selected image waiting for metadata input
  /// When non-null, ImageDetailsForm is displayed instead of image picker
  ExerciseSubmissionImage? _currentImageToAdd;

  /// Show dialog to choose between Camera and Gallery
  Future<void> _showImageSourceDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).selectImage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context).takePicture),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndShowImageDetails(context, pickFromCamera: true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.collections),
                title: Text(AppLocalizations.of(context).gallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickAndShowImageDetails(context, pickFromCamera: false);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Pick image from camera or gallery and show metadata collection form
  ///
  /// Validates file format (jpg, jpeg, png, webp) and size (<20MB) before
  /// showing the form. Invalid files are rejected with a snackbar message.
  ///
  /// [pickFromCamera] - If true, opens camera; otherwise opens gallery
  void _pickAndShowImageDetails(BuildContext context, {bool pickFromCamera = false}) async {
    final userProvider = context.read<UserProvider>();
    final imagePicker = ImagePicker();

    XFile? selectedImage;
    if (pickFromCamera) {
      selectedImage = await imagePicker.pickImage(source: ImageSource.camera);
    } else {
      selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    }

    if (selectedImage != null) {
      final imageFile = File(selectedImage.path);

      // Validate file type - only common image formats accepted
      bool isFileValid = true;
      String errorMessage = '';

      final extension = imageFile.path.split('.').last;
      const validFileExtensions = ['jpg', 'jpeg', 'png', 'webp'];
      if (!validFileExtensions.any((ext) => extension.toLowerCase() == ext)) {
        isFileValid = false;
        errorMessage = "Select only 'jpg', 'jpeg', 'png', 'webp' files";
      }

      // Validate file size - 20MB limit matches server-side restriction
      final fileSizeInMB = imageFile.lengthSync() / 1024 / 1024;
      if (fileSizeInMB > 20) {
        isFileValid = false;
        errorMessage = 'File Size should not be greater than 20 MB';
      }

      if (!isFileValid) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
        return;
      }

      // Show metadata collection form for valid image
      setState(() {
        _currentImageToAdd = ExerciseSubmissionImage(
          imageFile: imageFile,
          author: userProvider.profile?.username ?? '',
        );
      });
    }
  }

  /// Add image with its license metadata to the provider
  ///
  /// Called when user clicks "ADD" in ImageDetailsForm. The image and metadata
  /// are stored locally in AddExerciseProvider and will be uploaded together
  /// when the exercise is submitted in Step 6.
  ///
  /// [image] - The image file to add
  /// [details] - Map containing license fields (license_title, license_author, etc.)
  void _addImageWithDetails(ExerciseSubmissionImage image) {
    final provider = context.read<AddExerciseProvider>();

    // Store image with metadata - actual upload happens in addExercise()
    provider.addExerciseImages([image]);

    // Reset form state - image is now visible in preview list
    setState(() {
      _currentImageToAdd = null;
    });
  }

  /// Cancel metadata input and return to image picker
  void _cancelImageAdd() {
    setState(() {
      _currentImageToAdd = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formkey,
      child: Column(
        children: [
          // License notice - shown when not entering metadata
          if (_currentImageToAdd == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                AppLocalizations.of(context).add_exercise_image_license,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),

          // Metadata collection form - shown when image is selected
          if (_currentImageToAdd != null)
            ImageDetailsForm(
              submissionImage: _currentImageToAdd!,
              onAdd: _addImageWithDetails,
              onCancel: _cancelImageAdd,
            ),

          // Image picker or preview - shown when not entering metadata
          if (_currentImageToAdd == null)
            Consumer<AddExerciseProvider>(
              builder: (ctx, provider, __) {
                if (provider.exerciseImages.isNotEmpty) {
                  // Show preview of images that have been added with metadata
                  return Column(
                    children: [
                      PreviewExerciseImages(
                        selectedImages: provider.exerciseImages,
                        onAddMore: () => _showImageSourceDialog(context),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showImageSourceDialog(context),
                        icon: const Icon(Icons.add_photo_alternate),
                        label: Text(AppLocalizations.of(context).addImage),
                      ),
                    ],
                  );
                }

                // Empty state - no images added yet
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Icon(Icons.add_photo_alternate, size: 80, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No images selected',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    // Camera and Gallery buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickAndShowImageDetails(context, pickFromCamera: true),
                          icon: const Icon(Icons.camera_alt),
                          label: Text(AppLocalizations.of(context).takePicture),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () => _pickAndShowImageDetails(context),
                          icon: const Icon(Icons.collections),
                          label: Text(AppLocalizations.of(context).gallery),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Only JPEG, PNG and WEBP files below 20 MB are supported',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
