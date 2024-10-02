import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocean_rescue/pages/dumpReport/dump_dashboard_screen.dart';
import 'dart:io';
import 'package:uuid/uuid.dart'; // For generating unique IDs

import '../../resources/ReportDumpsFirestoreMethods.dart';
import '../../theme/colorTheme.dart';
import '../../widget/popup/ErrorPopup.dart';
import '../../widget/popup/SuccessPopup.dart';
import '../../models/reportdump.dart' as model;

void main() => runApp(MaterialApp(home: ReportDumpPage()));

class ReportDumpPage extends StatefulWidget {
  const ReportDumpPage({super.key});

  @override
  _ReportDumpPageState createState() => _ReportDumpPageState();
}

class _ReportDumpPageState extends State<ReportDumpPage> {
  File? _image; // Variable to store the selected image
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  String? _selectedUrgency;
  String _name = '';
  String _description = '';
  String _eventLocation = '';
  final ReportDumpsFirestoreMethods _firestoreMethods =
      ReportDumpsFirestoreMethods();

  // Method to pick an image
  Future<void> _pickImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to handle report dump submission
  Future<void> _submitReportDump(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (_selectedUrgency == null) {
        showErrorPopup(
            context, 'Urgency Level', 'Please select an urgency level.');
        return;
      }
      if (_image == null) {
        showErrorPopup(context, 'Image Missing', 'Please upload an image.');
        return;
      }

      try {
        // Generate a unique ID for the dump report
        String id = const Uuid().v1();

        // Upload the image to Firebase Storage and get the download URL
        String imageUrl =
            await _firestoreMethods.uploadImageToStorage(id, _image!);

        // Create a ReportDump model instance, including the timestamp
        model.ReportDump newDump = model.ReportDump(
          id: id,
          name: _name,
          description: _description,
          eventLocation: _eventLocation,
          urgencyLevel: _selectedUrgency!,
          imageUrl: imageUrl,
          timestamp:
              DateTime.now(), // Set the timestamp to the current date and time
        );

        // Save the report to Firestore
        await _firestoreMethods.saveReportDump(newDump);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DumpsDashboard()),
        );

        // Show success popup
        showSuccessPopup(context, 'Report Submitted',
            'Dump report has been successfully submitted.');
      } catch (e) {
        showErrorPopup(context, 'Submission Failed',
            'Error occurred while submitting: $e');
      }
    } else {
      showErrorPopup(
          context, 'Invalid Form', 'Please fill all fields correctly.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/logo/logo_without_name.png', // replace with your logo asset
            height: 40,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 16),
              _buildHeader(),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                label: 'Name',
                hintText: 'Enter your name',
                onSaved: (value) => _name = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter your name'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                label: 'Description',
                hintText: 'Enter description',
                maxLines: 3,
                onSaved: (value) => _description = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a description'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text('Urgency Level'),
              const SizedBox(height: 8),
              _buildUrgencyButtons(),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                label: 'Event Location',
                hintText: 'Enter event location',
                suffixIcon: const Icon(Icons.search),
                onSaved: (value) => _eventLocation = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter event location'
                    : null,
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: ColorTheme.liteGreen1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text('Map Placeholder')),
              ),
              const SizedBox(height: 16),
              const Text('Image Upload',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildImagePreview(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(context),
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Image'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildReportButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Rest of the UI widgets remain the same...
  Widget _buildHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF08BDBD), // Left-side color
            Color(0xFF1877F2), // Right-side color
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              'assets/post/createNewPost.png',
              height: 70,
              width: 70,
            ),
          ),
          const Expanded(
            child: Text(
              'Report Dump',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledTextField({
    required String label,
    required String hintText,
    int? maxLines,
    Widget? suffixIcon,
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
            suffixIcon: suffixIcon,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          maxLines: maxLines,
          validator: validator,
          onSaved: onSaved,
        ),
      ],
    );
  }

  Widget _buildUrgencyButtons() {
    final urgencies = ['Low', 'Normal', 'High', 'Urgent'];
    final colors = [Colors.green, Colors.blue, Colors.orange, Colors.red];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(urgencies.length, (index) {
        return GestureDetector(
          onTap: () => setState(() => _selectedUrgency = urgencies[index]),
          child: urgencyButton(
            urgencies[index],
            colors[index],
            isSelected: _selectedUrgency == urgencies[index],
          ),
        );
      }),
    );
  }

  Widget urgencyButton(String label, Color color, {bool isSelected = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? color : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(label,
            style: TextStyle(color: isSelected ? Colors.white : color)),
      ),
    );
  }

  Widget _buildImagePreview() {
    return _image != null
        ? Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image:
                  DecorationImage(image: FileImage(_image!), fit: BoxFit.cover),
            ),
          )
        : Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text('No Image Selected',
                  style: TextStyle(color: Colors.grey.shade600)),
            ),
          );
  }

  Widget _buildReportButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF08BDBD), // Left-side color
            Color(0xFF1877F2), // Right-side color
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: () => _submitReportDump(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.transparent,
        ),
        child: const Text('Report Dump', 
        style: TextStyle(fontSize: 18, color: ColorTheme.white),
        ),
      ),
    );
  }
}
