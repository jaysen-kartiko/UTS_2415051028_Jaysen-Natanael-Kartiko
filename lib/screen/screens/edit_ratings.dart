import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/movie.dart';
import '../../core/models/movie_rating.dart';
import '../../core/providers/rating_provider.dart';

class EditReviewScreen extends StatefulWidget {
  final MovieRating rating;
  final Movie? movie;

  const EditReviewScreen({super.key, required this.rating, this.movie});

  @override
  State<EditReviewScreen> createState() => _EditReviewScreenState();
}

class _EditReviewScreenState extends State<EditReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late double _rating;
  late TextEditingController _noteController;
  late DateTime _watchDate;
  late bool _favorite;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.rating.rating;
    _noteController = TextEditingController(text: widget.rating.note);
    _watchDate = DateTime.tryParse(widget.rating.watchDate) ?? DateTime.now();
    _favorite = widget.rating.favorite;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _updateReview() async {
    if (_formKey.currentState!.validate() && widget.rating.id != null) {
      setState(() {
        _isSubmitting = true;
      });

      final ratingProvider = Provider.of<RatingProvider>(context, listen: false);
      final formattedDate = '${_watchDate.year}-${_watchDate.month.toString().padLeft(2, '0')}-${_watchDate.day.toString().padLeft(2, '0')}';

      final success = await ratingProvider.updateRating(
        id: widget.rating.id!,
        rating: _rating,
        note: _noteController.text.trim(),
        watchDate: formattedDate,
        favorite: _favorite,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gagal Memperbarui'),
            content: Text(ratingProvider.errorMessage.isNotEmpty
                ? ratingProvider.errorMessage
                : 'Terjadi kesalahan pada database.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK', style: TextStyle(color: Colors.brown)),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.movie?.title ?? 'Film Tidak Diketahui';
    final year = widget.movie?.year.toString() ?? '';
    final poster = widget.movie?.posterUrl ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Review Film', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: poster.isNotEmpty
                        ? Image.network(poster, width: 60, height: 90, fit: BoxFit.cover)
                        : Container(width: 60, height: 90, color: Colors.grey.shade300),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$title ($year)',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ubah catatan review Anda',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Rating (1.0 - 5.0)',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
              ),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 1.0,
                      max: 5.0,
                      divisions: 8,
                      activeColor: Colors.brown,
                      label: _rating.toString(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                  ),
                  const Icon(Icons.star, color: Colors.amber),
                  Text(
                    _rating.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Catatan Review',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.brown, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Catatan review tidak boleh kosong';
                  }
                  if (value.trim().length < 5) {
                    return 'Catatan review minimal 5 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tanggal Menonton:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _watchDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != _watchDate) {
                        setState(() {
                          _watchDate = picked;
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today, color: Colors.brown, size: 16),
                    label: Text(
                      '${_watchDate.year}-${_watchDate.month.toString().padLeft(2, '0')}-${_watchDate.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.brown),
                    ),
                  ),
                ],
              ),
              SwitchListTile(
                title: const Text(
                  'Tandai sebagai Favorit',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
                ),
                value: _favorite,
                activeColor: Colors.brown,
                onChanged: (bool value) {
                  setState(() {
                    _favorite = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateReview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Perbarui Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}