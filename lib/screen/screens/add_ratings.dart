import 'package:flutter/material.dart';

class AddReviewScreen extends StatefulWidget {
  final Map<String, dynamic>? movieData;

  const AddReviewScreen({super.key, this.movieData});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 3.0;
  final TextEditingController _noteController = TextEditingController();
  DateTime _watchDate = DateTime.now();
  bool _favorite = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movieData ?? {
      'title': 'Oppenheimer',
      'year': 2023,
      'poster_url': 'https://picsum.photos/seed/oppenheimer/300/450',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Review Film', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    child: Image.network(
                      movie['poster_url'],
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${movie['title']} (${movie['year']})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Bagikan pengalaman menonton Anda',
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
                  if (value == null || value.isEmpty) {
                    return 'Catatan review tidak boleh kosong';
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
                      '${_watchDate.day}-${_watchDate.month}-${_watchDate.year}',
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Simpan Review', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}