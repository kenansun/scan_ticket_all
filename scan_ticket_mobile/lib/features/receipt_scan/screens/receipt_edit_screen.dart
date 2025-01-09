import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/receipt.dart';
import '../providers/receipt_state.dart';
import '../../../core/extensions/context_extension.dart';

class ReceiptEditScreen extends ConsumerStatefulWidget {
  final String receiptId;

  const ReceiptEditScreen({
    super.key,
    required this.receiptId,
  });

  @override
  ConsumerState<ReceiptEditScreen> createState() => _ReceiptEditScreenState();
}

class _ReceiptEditScreenState extends ConsumerState<ReceiptEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Receipt _receipt;
  bool _isLoading = true;
  String? _error;

  final _merchantNameController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _noteController = TextEditingController();
  final _merchantAddressController = TextEditingController();
  final _merchantPhoneController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _taxAmountController = TextEditingController();
  final _serialNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReceipt();
  }

  @override
  void dispose() {
    _merchantNameController.dispose();
    _totalAmountController.dispose();
    _noteController.dispose();
    _merchantAddressController.dispose();
    _merchantPhoneController.dispose();
    _taxNumberController.dispose();
    _taxAmountController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  Future<void> _loadReceipt() async {
    try {
      final receipt = await ref
          .read(receiptStateProvider.notifier)
          .getReceiptDetail(widget.receiptId);
      if (receipt != null) {
        setState(() {
          _receipt = receipt;
          _isLoading = false;
          _initializeControllers();
        });
      } else {
        setState(() {
          _error = '未找到小票信息';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _initializeControllers() {
    _merchantNameController.text = _receipt.merchantName ?? '';
    _totalAmountController.text =
        _receipt.totalAmount?.toStringAsFixed(2) ?? '';
    _noteController.text = _receipt.note ?? '';
    _merchantAddressController.text = _receipt.merchantAddress ?? '';
    _merchantPhoneController.text = _receipt.merchantPhone ?? '';
    _taxNumberController.text = _receipt.taxNumber ?? '';
    _taxAmountController.text =
        _receipt.taxAmount?.toStringAsFixed(2) ?? '';
    _serialNumberController.text = _receipt.serialNumber ?? '';
  }

  Future<void> _saveReceipt() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final updatedReceipt = _receipt.copyWith(
        merchantName: _merchantNameController.text,
        totalAmount: double.tryParse(_totalAmountController.text),
        note: _noteController.text,
        merchantAddress: _merchantAddressController.text,
        merchantPhone: _merchantPhoneController.text,
        taxNumber: _taxNumberController.text,
        taxAmount: double.tryParse(_taxAmountController.text),
        serialNumber: _serialNumberController.text,
      );

      await ref
          .read(receiptStateProvider.notifier)
          .updateReceipt(updatedReceipt);

      if (mounted) {
        context.showSnackBar('保存成功');
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _error!,
                style: context.textTheme.titleMedium?.copyWith(
                  color: context.colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadReceipt,
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑小票'),
        actions: [
          TextButton(
            onPressed: _saveReceipt,
            child: const Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 基本信息
              _buildSectionTitle('基本信息'),
              _buildTextField(
                controller: _merchantNameController,
                label: '商家名称',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入商家名称';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _totalAmountController,
                label: '金额',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入金额';
                  }
                  if (double.tryParse(value) == null) {
                    return '请输入有效的金额';
                  }
                  return null;
                },
              ),
              _buildDropdownField(
                label: '分类',
                value: _receipt.category,
                items: ReceiptCategory.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(AppConstants
                              .receiptCategoryText[e.toString().split('.').last]!),
                        ))
                    .toList(),
                onChanged: (ReceiptCategory? value) {
                  if (value != null) {
                    setState(() {
                      _receipt = _receipt.copyWith(category: value);
                    });
                  }
                },
              ),
              // 商家信息
              const SizedBox(height: 24),
              _buildSectionTitle('商家信息'),
              _buildTextField(
                controller: _merchantAddressController,
                label: '地址',
              ),
              _buildTextField(
                controller: _merchantPhoneController,
                label: '电话',
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _taxNumberController,
                label: '税号',
              ),
              _buildTextField(
                controller: _taxAmountController,
                label: '税额',
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _serialNumberController,
                label: '流水号',
              ),
              // 备注
              const SizedBox(height: 24),
              _buildSectionTitle('备注'),
              _buildTextField(
                controller: _noteController,
                label: '备注',
                maxLines: 3,
              ),
              // 标签
              const SizedBox(height: 24),
              _buildSectionTitle('标签'),
              Wrap(
                spacing: 8,
                children: [
                  ...AppConstants.defaultTags.map((tag) {
                    final isSelected = _receipt.tags.contains(tag);
                    return FilterChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _receipt = _receipt.copyWith(
                              tags: [..._receipt.tags, tag],
                            );
                          } else {
                            _receipt = _receipt.copyWith(
                              tags: _receipt.tags
                                  .where((t) => t != tag)
                                  .toList(),
                            );
                          }
                        });
                      },
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines ?? 1,
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
