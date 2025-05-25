import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/quote/quote_bloc.dart';
import '../blocs/quote/quote_event.dart';
import '../blocs/quote/quote_state.dart';
import '../models/quote.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/message_dialog.dart';

class AddQuoteScreen extends StatefulWidget {
  final Quote? quote;

  const AddQuoteScreen({super.key, this.quote});

  @override
  State<AddQuoteScreen> createState() => _AddQuoteScreenState();
}

class _AddQuoteScreenState extends State<AddQuoteScreen> {
  final TextEditingController _quoteTextController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool get _isEditing => widget.quote != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _quoteTextController.text = widget.quote!.text;
      _authorController.text = widget.quote!.author;
    }
  }

  @override
  void dispose() {
    _quoteTextController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _onSaveQuote() {
    if (_formKey.currentState!.validate()) {
      if (_isEditing) {
        // Update existing quote
        final updatedQuote = widget.quote!.copyWith(
          text: _quoteTextController.text.trim(),
          author: _authorController.text.trim(),
        );
        context.read<QuoteBloc>().add(UpdateQuote(quote: updatedQuote));
      } else {
        // Add new quote
        final newQuote = Quote(
          text: _quoteTextController.text.trim(),
          author: _authorController.text.trim(),
        );
        context.read<QuoteBloc>().add(AddQuote(quote: newQuote));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Quote' : 'Add New Quote'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocListener<QuoteBloc, QuoteState>(
        listener: (context, state) {
          if (state.addQuoteError != null) {
            showMessageDialog(
              context,
              'Error Adding Quote',
              state.addQuoteError!,
            );
            context.read<QuoteBloc>().add(
              const LoadAllQuotes(isInitialLoad: false),
            );
          } else if (state.updateQuoteError != null) {
            showMessageDialog(
              context,
              'Error Updating Quote',
              state.updateQuoteError!,
            );
            context.read<QuoteBloc>().add(
              const LoadAllQuotes(isInitialLoad: false),
            );
          } else if (state.deleteQuoteError != null) {
            showMessageDialog(
              context,
              'Error Deleting Quote',
              state.deleteQuoteError!,
            );
            context.read<QuoteBloc>().add(
              const LoadAllQuotes(isInitialLoad: false),
            );
          }

          // operation successful
          if (!state.isLoadingGlobalQuotes &&
              state.addQuoteError == null &&
              state.updateQuoteError == null) {
            context.pop();
          }
        },
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            final bool isOperationLoading =
                state.isLoadingGlobalQuotes ||
                state.isLoadingUserQuotes ||
                state.isLoadingLikedQuotes;
            return Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _quoteTextController,
                            maxLines: 10,
                            minLines: 5,
                            maxLength: 180,
                            decoration: const InputDecoration(
                              labelText: 'Quote Text',
                              alignLabelWithHint: true,
                              hintText: 'Enter the quote...',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the quote text';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _authorController,
                            decoration: const InputDecoration(
                              labelText: 'Author',
                              hintText: 'Enter the author\'s name',
                            ),
                            maxLength: 80,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the author\'s name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: isOperationLoading ? null : _onSaveQuote,
                            child: Text(
                              _isEditing ? 'Update Quote' : 'Share Quote',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isOperationLoading) const LoadingIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
