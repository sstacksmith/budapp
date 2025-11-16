import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'l10n/app_localizations.dart';
import 'services/auth_service.dart';
import 'services/ai_service.dart';
import 'models/renovation_plan.dart';

class SmartRenovationPlannerScreen extends StatefulWidget {
  const SmartRenovationPlannerScreen({Key? key}) : super(key: key);

  @override
  State<SmartRenovationPlannerScreen> createState() => _SmartRenovationPlannerScreenState();
}

class _SmartRenovationPlannerScreenState extends State<SmartRenovationPlannerScreen> {
  final AIService _aiService = AIService();
  final AuthService _authService = AuthService();
  List<RenovationPlan> _plans = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<RenovationPlan> plans = await _aiService.getUserRenovationPlans(user.uid);
        setState(() {
          _plans = plans;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Błąd ładowania planów: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.smartRenovationPlanner),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPlans,
            tooltip: 'Odśwież',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _plans.isEmpty
              ? _buildEmptyState(loc)
              : _buildPlansList(loc),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePlanDialog,
        icon: const Icon(Icons.add),
        label: Text(loc.createNewPlan),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home_repair_service,
              size: 80,
              color: Colors.purple[300],
            ),
            const SizedBox(height: 24),
            Text(
              loc.noPlansYet,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              loc.createFirstPlan,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showCreatePlanDialog,
              icon: const Icon(Icons.add),
              label: Text(loc.createNewPlan),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansList(AppLocalizations loc) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _plans.length,
      itemBuilder: (context, index) {
        final plan = _plans[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple[100],
              child: Icon(
                Icons.home_repair_service,
                color: Colors.purple[600],
              ),
            ),
            title: Text(plan.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.description),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.attach_money, size: 16, color: Colors.green[600]),
                    Text(' ${plan.estimatedCost.toStringAsFixed(2)} PLN'),
                    const SizedBox(width: 16),
                    Icon(Icons.home, size: 16, color: Colors.blue[600]),
                    Text(' ${plan.rooms.length} ${loc.rooms}'),
                  ],
                ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      const Icon(Icons.visibility),
                      const SizedBox(width: 8),
                      Text(loc.view),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      const SizedBox(width: 8),
                      Text(loc.edit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(loc.delete, style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    _viewPlan(plan);
                    break;
                  case 'edit':
                    _editPlan(plan);
                    break;
                  case 'delete':
                    _deletePlan(plan);
                    break;
                }
              },
            ),
            onTap: () => _viewPlan(plan),
          ),
        );
      },
    );
  }

  void _showCreatePlanDialog() {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => CreatePlanDialog(
        onPlanCreated: (plan) {
          _loadPlans();
          _showSuccessSnackBar(loc.planCreatedSuccessfully);
        },
      ),
    );
  }

  void _viewPlan(RenovationPlan plan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanDetailsScreen(plan: plan),
      ),
    );
  }

  void _editPlan(RenovationPlan plan) {
    _showErrorSnackBar('Funkcja edycji będzie dostępna wkrótce');
  }

  void _deletePlan(RenovationPlan plan) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.deletePlan),
        content: Text(loc.deletePlanConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _aiService.deleteRenovationPlan(plan.id);
                _loadPlans();
                _showSuccessSnackBar(loc.planDeletedSuccessfully);
              } catch (e) {
                _showErrorSnackBar('Błąd usuwania planu: $e');
              }
            },
            child: Text(loc.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class CreatePlanDialog extends StatefulWidget {
  final Function(RenovationPlan) onPlanCreated;

  const CreatePlanDialog({Key? key, required this.onPlanCreated}) : super(key: key);

  @override
  State<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends State<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final List<Room> _rooms = [];
  bool _isGenerating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(loc.createNewPlan),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: loc.planName,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.pleaseEnterPlanName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: loc.planDescription,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _budgetController,
                decoration: InputDecoration(
                  labelText: loc.budget,
                  border: const OutlineInputBorder(),
                  suffixText: 'PLN',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc.pleaseEnterBudget;
                  }
                  if (double.tryParse(value) == null) {
                    return loc.pleaseEnterValidBudget;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addRoom,
                icon: const Icon(Icons.add),
                label: Text(loc.addRoom),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[600],
                  foregroundColor: Colors.white,
                ),
              ),
              if (_rooms.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  loc.rooms,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ..._rooms.map((room) => ListTile(
                  title: Text(room.name),
                  subtitle: Text('${room.area} m² - ${room.type}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => setState(() => _rooms.remove(room)),
                  ),
                )),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isGenerating ? null : () => Navigator.pop(context),
          child: Text(loc.cancel),
        ),
        ElevatedButton(
          onPressed: _isGenerating ? null : _createPlan,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[600],
            foregroundColor: Colors.white,
          ),
          child: _isGenerating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(loc.create),
        ),
      ],
    );
  }

  void _addRoom() {
    showDialog(
      context: context,
      builder: (context) => AddRoomDialog(
        onRoomAdded: (room) => setState(() => _rooms.add(room)),
      ),
    );
  }

  Future<void> _createPlan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_rooms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseAddAtLeastOneRoom),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Użytkownik nie jest zalogowany');
      }


      RenovationPlan plan = await AIService().generateRenovationPlan(
        userId: user.uid,
        name: _nameController.text,
        description: _descriptionController.text,
        rooms: _rooms,
        budget: double.parse(_budgetController.text),
      );

      
      if (!mounted) return;
      widget.onPlanCreated(plan);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd tworzenia planu: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }
}

class AddRoomDialog extends StatefulWidget {
  final Function(Room) onRoomAdded;

  const AddRoomDialog({Key? key, required this.onRoomAdded}) : super(key: key);

  @override
  State<AddRoomDialog> createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _areaController = TextEditingController();
  final _workDescriptionController = TextEditingController();
  String _selectedType = 'other';

  final List<String> _roomTypes = [
    'kitchen',
    'bathroom',
    'living_room',
    'bedroom',
    'other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _areaController.dispose();
    _workDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(loc.addRoom),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: loc.roomName,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return loc.pleaseEnterRoomName;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaController,
              decoration: InputDecoration(
                labelText: loc.roomArea,
                border: const OutlineInputBorder(),
                suffixText: 'm²',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return loc.pleaseEnterRoomArea;
                }
                if (double.tryParse(value) == null) {
                  return loc.pleaseEnterValidArea;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: loc.roomType,
                border: const OutlineInputBorder(),
              ),
              items: _roomTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getRoomTypeName(type)),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _workDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Opis prac do wykonania',
                hintText: 'np. Wymiana płytek, malowanie ścian, montaż mebli...',
                border: OutlineInputBorder(),
                helperText: '💡 Im dokładniej opiszesz prace, tym lepsze będą rekomendacje AI!',
                helperMaxLines: 2,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Proszę opisać prace do wykonania';
                }
                if (value.length < 20) {
                  return 'Opis powinien mieć co najmniej 20 znaków';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.cancel),
        ),
        ElevatedButton(
          onPressed: _addRoom,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[600],
            foregroundColor: Colors.white,
          ),
          child: Text(loc.add),
        ),
      ],
    );
  }

  void _addRoom() {
    if (_formKey.currentState!.validate()) {
      Room room = Room(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        area: double.parse(_areaController.text),
        type: _selectedType,
        workDescription: _workDescriptionController.text,
        materials: [],
        tasks: [],
        estimatedCost: 0.0,
      );
      widget.onRoomAdded(room);
      Navigator.pop(context);
    }
  }

  String _getRoomTypeName(String type) {
    switch (type) {
      case 'kitchen':
        return 'Kuchnia';
      case 'bathroom':
        return 'Łazienka';
      case 'living_room':
        return 'Salon';
      case 'bedroom':
        return 'Sypialnia';
      default:
        return 'Inne';
    }
  }
}

class PlanDetailsScreen extends StatefulWidget {
  final RenovationPlan plan;

  const PlanDetailsScreen({Key? key, required this.plan}) : super(key: key);

  @override
  State<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends State<PlanDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _selectedMaterialFilter;
  final AIService _aiService = AIService();
  bool _isRegenerating = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _regenerateRecommendations() async {
    setState(() {
      _isRegenerating = true;
    });

    try {
      
      RenovationPlan updatedPlan = await _aiService.regenerateRecommendations(widget.plan);
      
      
      if (!mounted) return;
      
      setState(() {
        widget.plan.recommendations.clear();
        widget.plan.recommendations.addAll(updatedPlan.recommendations);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Wygenerowano ${updatedPlan.recommendations.length} rekomendacji AI!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Błąd: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isRegenerating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.name),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            tooltip: 'Regeneruj rekomendacje AI',
            onPressed: _isRegenerating ? null : _regenerateRecommendations,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: 'Przegląd'),
            Tab(icon: Icon(Icons.lightbulb), text: 'AI Rekomendacje'),
            Tab(icon: Icon(Icons.shopping_cart), text: 'Porównanie cen'),
            Tab(icon: Icon(Icons.receipt_long), text: 'Kosztorys'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(loc),
          _buildAIRecommendationsTab(loc),
          _buildPriceComparisonTab(loc),
          _buildDetailedCostEstimateTab(loc),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AppLocalizations loc) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.planOverview,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(widget.plan.description),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoCard(
                          context,
                          loc.totalBudget,
                          '${widget.plan.totalBudget.toStringAsFixed(2)} PLN',
                          Icons.account_balance_wallet,
                          Colors.blue,
                        ),
                        _buildInfoCard(
                          context,
                          loc.estimatedCost,
                          '${widget.plan.estimatedCost.toStringAsFixed(2)} PLN',
                          Icons.calculate,
                          Colors.green,
                        ),
                        _buildInfoCard(
                          context,
                          loc.rooms,
                          '${widget.plan.rooms.length}',
                          Icons.home,
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              loc.rooms,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...widget.plan.rooms.map((room) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(room.name),
                subtitle: Text('${room.area} m² - ${room.type}'),
                trailing: Text('${room.estimatedCost.toStringAsFixed(2)} PLN'),
              ),
            )),
          ],
        ),
      );
  }

  Widget _buildAIRecommendationsTab(AppLocalizations loc) {
    if (widget.plan.recommendations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isRegenerating) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  '🤖 AI analizuje Twój plan...',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Generowanie inteligentnych rekomendacji...',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                Icon(Icons.psychology, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Brak rekomendacji AI',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rekomendacje AI nie zostały jeszcze wygenerowane.\nKliknij poniżej, aby wygenerować inteligentne wskazówki.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _isRegenerating ? null : _regenerateRecommendations,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Wygeneruj rekomendacje AI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.plan.recommendations.length,
      itemBuilder: (context, index) {
        final rec = widget.plan.recommendations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 3,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: _getRecommendationColor(rec.priority),
              child: Icon(
                _getRecommendationIcon(rec.type),
                color: Colors.white,
                size: 28,
              ),
            ),
            title: Text(
              rec.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  rec.description,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                ),
                if (rec.potentialSavings > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.savings, color: Colors.green[700], size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Oszczędność: ${rec.potentialSavings.toStringAsFixed(2)} PLN',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildPriceComparisonTab(AppLocalizations loc) {
    if (widget.plan.materialPrices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Brak porównania cen',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Porównanie cen będzie dostępne po wygenerowaniu planu.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    Set<String> materialNames = widget.plan.materialPrices
        .map((p) => p.materialName)
        .toSet();
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Wszystkie'),
                selected: _selectedMaterialFilter == null,
                onSelected: (selected) {
                  setState(() {
                    _selectedMaterialFilter = null;
                  });
                },
              ),
              ...materialNames.map((name) => FilterChip(
                label: Text(name),
                selected: _selectedMaterialFilter == name,
                onSelected: (selected) {
                  setState(() {
                    _selectedMaterialFilter = selected ? name : null;
                  });
                },
              )),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _getFilteredPrices().length,
            itemBuilder: (context, index) {
              final price = _getFilteredPrices()[index];
              final isLowestPrice = _isLowestPrice(price);
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: isLowestPrice ? Colors.green[50] : null,
                child: ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store,
                        color: isLowestPrice ? Colors.green[700] : Colors.blue[600],
                      ),
                      if (isLowestPrice)
                        const Text(
                          '💰',
                          style: TextStyle(fontSize: 12),
                        ),
                    ],
                  ),
                  title: Text(
                    price.materialName,
                    style: TextStyle(
                      fontWeight: isLowestPrice ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(price.supplier),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${price.price.toStringAsFixed(2)} ${price.currency}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isLowestPrice ? Colors.green[700] : Colors.green,
                        ),
                      ),
                      if (isLowestPrice)
                        Text(
                          'Najniższa cena!',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  onTap: () {
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  
  List<MaterialPrice> _getFilteredPrices() {
    if (_selectedMaterialFilter == null) {
      return widget.plan.materialPrices;
    }
    return widget.plan.materialPrices
        .where((p) => p.materialName == _selectedMaterialFilter)
        .toList();
  }
  
  bool _isLowestPrice(MaterialPrice price) {
    final sameMaterial = widget.plan.materialPrices
        .where((p) => p.materialName == price.materialName)
        .toList();
    if (sameMaterial.isEmpty) return false;
    final lowestPrice = sameMaterial.map((p) => p.price).reduce((a, b) => a < b ? a : b);
    return price.price == lowestPrice;
  }

  Widget _buildDetailedCostEstimateTab(AppLocalizations loc) {
    Map<String, double> categoryTotals = {};
    
    for (var room in widget.plan.rooms) {
      for (var material in room.materials) {
        categoryTotals[material.category] = 
            (categoryTotals[material.category] ?? 0) + material.totalPrice;
      }
      for (var task in room.tasks) {
        categoryTotals['Robocizna'] = 
            (categoryTotals['Robocizna'] ?? 0) + task.estimatedCost;
      }
    }

    double totalCost = categoryTotals.values.fold(0.0, (sum, cost) => sum + cost);
    double contingency = totalCost * 0.1;
    double grandTotal = totalCost + contingency;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.purple[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCostRow('Suma materiałów i robocizny:', totalCost),
                  const Divider(),
                  _buildCostRow('Rezerwa (10%):', contingency),
                  const Divider(thickness: 2),
                  _buildCostRow(
                    'SUMA CAŁKOWITA:',
                    grandTotal,
                    isTotal: true,
                  ),
                  const Divider(),
                  _buildCostRow(
                    'Pozostało z budżetu:',
                    widget.plan.totalBudget - grandTotal,
                    isRemaining: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Podział na kategorie:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...categoryTotals.entries.map((entry) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(entry.key),
              trailing: Text(
                '${entry.value.toStringAsFixed(2)} PLN',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCostRow(String label, double amount, {bool isTotal = false, bool isRemaining = false}) {
    Color color = isRemaining 
        ? (amount >= 0 ? Colors.green : Colors.red)
        : Colors.black87;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '${amount.toStringAsFixed(2)} PLN',
            style: TextStyle(
              fontSize: isTotal ? 20 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRecommendationColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getRecommendationIcon(String type) {
    switch (type) {
      case 'cost_saving':
        return Icons.savings;
      case 'quality':
        return Icons.star;
      case 'time_saving':
        return Icons.schedule;
      case 'safety':
        return Icons.security;
      default:
        return Icons.lightbulb;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

