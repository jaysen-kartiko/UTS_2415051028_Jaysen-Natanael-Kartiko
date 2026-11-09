import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/auth_service.dart';
import '../../core/services/profile_service.dart';
import '../../core/services/kos_service.dart';
import '../../core/services/notification_service.dart';
import 'login_page.dart';

import '../components/role_guard.dart';
import 'add_kos.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<UserProfile?> _profileFuture;
  final myId = Supabase.instance.client.auth.currentUser!.id;

  List items = [];
  bool _isLoadingKos = true;

  @override
  void initState() {
    super.initState();
    _profileFuture = ProfileService().getMyProfile();
NotificationService.instance.init();
    _loadKosData();
  }

  Future<void> _loadKosData() async {
    try {
      final data = await KosService().fetchAll();
      setState(() {
        items = data;
        _isLoadingKos = false;
      });
    } catch (e) {
      setState(() => _isLoadingKos = false);
    }
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // === FUNGSI SECURITY TEST RLS ===
  Future<void> _runSecurityTest() async {

    const String sampleKosIdMilikUserA = '1c631214-654b-43e1-9364-bc64460b97d9';
    const String sampleUserAUuid = '79736fe2-7266-4a2b-9a2e-cbb6ccd230b9';

    final kos = KosService();

    debugPrint('=== MEMULAI SECURITY TEST ===');

    // 1. User B mencoba mengubah data User A -> harus DENIED
    final updated = await kos.update(sampleKosIdMilikUserA, {'name': 'DIUBAH USER B'});
    debugPrint(updated
        ? '[FAIL] User B berhasil mengubah data User A'
        : '[PASS] UPDATE ditolak oleh RLS');

    // 2. User B mencoba menghapus data User A -> harus DENIED
    final deleted = await kos.delete(sampleKosIdMilikUserA);
    debugPrint(deleted
        ? '[FAIL] User B berhasil menghapus data User A'
        : '[PASS] DELETE ditolak oleh RLS');

    // 3. User B mencoba INSERT atas nama User A -> harus ERROR 42501
    try {
      await Supabase.instance.client.from('kos').insert({
        'owner_id': sampleUserAUuid,
        'name': 'Kos palsu',
        'address': 'Alamat palsu',
        'price': 1000000,
      });
      debugPrint('[FAIL] INSERT atas nama user lain berhasil');
    } on PostgrestException catch (e) {
      debugPrint('[PASS] INSERT ditolak: ${e.code} - ${e.message}');
    }

    debugPrint('=== SECURITY TEST SELESAI ===');

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security test dijalankan! Cek Debug Console.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile?>(
      future: _profileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final p = snap.data;
        if (snap.hasError || p == null) {
          return const Scaffold(
            body: Center(child: Text('Gagal memuat profil')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('KosFinder (${p.role})'),
            actions: [
              // Tombol untuk menjalankan Security Test
              IconButton(
                tooltip: 'Jalankan Security Test',
                icon: const Icon(Icons.security),
                onPressed: _runSecurityTest,
              ),
              // Tombol Logout
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: _logout,
              ),
            ],
          ),
          body: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(p.name.isEmpty ? p.email : p.name),
                subtitle: Text('${p.email}\nRole: ${p.role}'),
              ),
              const Divider(),
              const ListTile(
                leading: Icon(Icons.list),
                title: Text('Daftar Kos'),
              ),
              _isLoadingKos
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final kos = items[i];
                        final isMine = kos['owner_id'] == myId;

                        return ListTile(
                          title: Text(kos['name'] ?? '-'),
                          subtitle: Text(
                              '${kos['address'] ?? '-'}\nRp ${kos['price'] ?? 0}'),
                          isThreeLine: true,
                          trailing: isMine
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        /* TODO: buka form edit */
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await KosService().delete(kos['id']);
                                        setState(() {
                                          items.removeAt(i);
                                        });
                                      },
                                    ),
                                  ],
                                )
                              : null,
                        );
                      },
                    ),
              const Divider(),
              if (p.isOwner || p.isAdmin)
                const ListTile(
                  leading: Icon(Icons.home_work),
                  title: Text('My Kos'),
                ),
              if (p.isAdmin)
                const ListTile(
                  leading: Icon(Icons.admin_panel_settings),
                  title: Text('Kelola Data (Admin)'),
                ),
            ],
          ),
          floatingActionButton: RoleGuard(
            role: p.role,
            allowed: const ['owner', 'admin'],
            child: FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddKosPage()),
                );

                if (result == true) {
                  _loadKosData();
                }
              },
              icon: const Icon(Icons.add_home),
              label: const Text('Tambah Kos'),
            ),
          ),
        );
      },
    );
  }
}