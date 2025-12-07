import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportErrorDrawer extends StatefulWidget {
  final int memberId;
  final String memberName;
  final String? memberNameEnglish;
  final String? memberDob;
  final void Function()? onSubmitted; // Optional callback after submit

  const ReportErrorDrawer({
    super.key,
    required this.memberId,
    required this.memberName,
    this.memberNameEnglish,
    this.memberDob,
    this.onSubmitted,
  });

  @override
  State<ReportErrorDrawer> createState() => _ReportErrorDrawerState();
}

class _ReportErrorDrawerState extends State<ReportErrorDrawer> {
  bool wrongName = false;
  bool wrongDob = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onInputChanged);
    dobController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    nameController.removeListener(_onInputChanged);
    dobController.removeListener(_onInputChanged);
    nameController.dispose();
    dobController.dispose();
    super.dispose();
  }

  bool get canSubmit {
    if (wrongName && nameController.text.trim().isEmpty) return false;
    if (wrongDob && dobController.text.trim().isEmpty) return false;
    return wrongName || wrongDob;
  }

  Future<void> _submitReport() async {
    if (!canSubmit || _submitting) return;
    setState(() => _submitting = true);
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'memberId': widget.memberId,
        'membername': widget.memberName,
        'correctName': wrongName ? nameController.text.trim() : null,
        'correctDob': wrongDob ? dobController.text.trim() : null,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted! Thank you.')),
        );
        widget.onSubmitted?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewInsets = MediaQuery.of(context).viewInsets;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: viewInsets.bottom > 0 ? viewInsets.bottom : 30,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 10,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF0B3B2D), Color(0xFF1F6B3A)],
                    ),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Drag handle
                        Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Center(
                            child: Container(
                              width: 48,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.report_gmailerrorred_outlined,
                                  color: Colors.redAccent,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Report Error',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 22,
                                            letterSpacing: 0.1,
                                          ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Help us keep the family tree accurate.',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Member info
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.white70,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      widget.memberNameEnglish != null &&
                                              widget
                                                  .memberNameEnglish!
                                                  .isNotEmpty
                                          ? widget.memberNameEnglish!
                                          : widget.memberName,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                  if (widget.memberNameEnglish != null &&
                                      widget.memberNameEnglish!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        '(${widget.memberName})',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: Colors.white60,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                              if (widget.memberDob != null &&
                                  widget.memberDob!.isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.cake,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.memberDob!,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Section: What is wrong?
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28),
                          child: Text(
                            'What is wrong?',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _CustomCheckboxTile(
                                checked: wrongName,
                                icon: Icons.edit,
                                label: 'Wrong name or typing error',
                                onChanged:
                                    (val) => setState(() => wrongName = val),
                                inputHint: 'Enter correct name',
                                showInput: wrongName,
                                controller: nameController,
                              ),
                              const SizedBox(height: 10),
                              _CustomCheckboxTile(
                                checked: wrongDob,
                                icon: Icons.cake,
                                label: 'Wrong date of birth',
                                onChanged:
                                    (val) => setState(() => wrongDob = val),
                                inputHint: 'Enter correct date of birth',
                                showInput: wrongDob,
                                controller: dobController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white70,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                icon: const Icon(Icons.close, size: 18),
                                label: const Text('Cancel'),
                                onPressed:
                                    _submitting
                                        ? null
                                        : () => Navigator.of(context).pop(),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      canSubmit && !_submitting
                                          ? Colors.white.withOpacity(0.15)
                                          : Colors.white.withOpacity(0.05),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 22,
                                    vertical: 13,
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  elevation: 0,
                                ),
                                icon:
                                    _submitting
                                        ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.2,
                                          ),
                                        )
                                        : const Icon(Icons.send, size: 18),
                                label: const Text('Submit'),
                                onPressed:
                                    canSubmit && !_submitting
                                        ? _submitReport
                                        : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomCheckboxTile extends StatelessWidget {
  final bool checked;
  final IconData icon;
  final String label;
  final void Function(bool) onChanged;
  final String inputHint;
  final bool showInput;
  final TextEditingController controller;

  const _CustomCheckboxTile({
    required this.checked,
    required this.icon,
    required this.label,
    required this.onChanged,
    required this.inputHint,
    required this.showInput,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color:
            checked
                ? Colors.green.withOpacity(0.15)
                : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: checked ? Colors.green[400]! : Colors.white.withOpacity(0.15),
          width: checked ? 1.6 : 1.0,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onChanged(!checked),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: checked ? Colors.white : Colors.white54,
                    size: 22,
                  ),
                  Checkbox(
                    value: checked,
                    onChanged: (val) => onChanged(val ?? false),
                    activeColor: Colors.white,
                    checkColor: Colors.green[800],
                    side: const BorderSide(color: Colors.white60, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.5,
                        color: checked ? Colors.white : Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showInput)
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 8,
                bottom: 12,
                top: 2,
              ),
              child: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: inputHint,
                  labelStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(icon, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                ),
                style: const TextStyle(fontSize: 16, color: Colors.white),
                textInputAction: TextInputAction.next,
              ),
            ),
        ],
      ),
    );
  }
}
