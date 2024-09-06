import 'dart:convert';

import 'package:clock_app/common/types/json.dart';
import 'package:clock_app/common/utils/snackbar.dart';
import 'package:clock_app/debug/logic/logger.dart';
import 'package:clock_app/settings/data/backup_options.dart';
import 'package:clock_app/settings/logic/backup.dart';
import 'package:clock_app/settings/types/backup_option.dart';
import 'package:clock_app/settings/widgets/settings_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BackupOptionCheckBox extends StatelessWidget {
  const BackupOptionCheckBox(
      {super.key, required this.option, required this.onChanged});

  final BackupOption option;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          // checkColor: Colors.white,
          // fillColor: MaterialStateProperty.resolveWith(getColor),
          value: option.selected,
          onChanged: onChanged,
        ),
        Text(
          option.getName(context),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}

class BackupExportScreen extends StatefulWidget {
  const BackupExportScreen({
    super.key,
  });

  @override
  State<BackupExportScreen> createState() => _BackupExportScreenState();
}

class _BackupExportScreenState extends State<BackupExportScreen> {
  @override
  void initState() {
    for (var option in backupOptions) {
      option.selected = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsTopBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
                onPressed: () async {
                  try {
                    final backupData = {};
                    for (var option in backupOptions) {
                      if (option.selected) {
                        backupData[option.key] = await option.encode();
                      }
                    }
                    final result =
                        await saveBackupFile(json.encode(backupData));
                    if (result == null) return;
                    if (context.mounted) {
                      showSnackBar(context, "Export successful!");
                    }
                  } catch (e) {
                    logger.e(e.toString());
                    if (context.mounted) {
                      showSnackBar(context, "Error exporting: ${e.toString()}",
                          error: true);
                    }
                  }
                },
                child:
                    Text(AppLocalizations.of(context)!.exportSettingsSetting)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ...backupOptions.map(
                (option) => BackupOptionCheckBox(
                  option: option,
                  onChanged: (bool? value) {
                    setState(() {
                      option.selected = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class BackupImportScreen extends StatefulWidget {
  const BackupImportScreen({
    super.key,
    required this.data,
  });

  final String data;

  @override
  State<BackupImportScreen> createState() => _BackupImportScreenState();
}

class _BackupImportScreenState extends State<BackupImportScreen> {
  late final List<BackupOption> importOptions = [];
  late final Json dataJson;

  @override
  void initState() {
    dataJson = json.decode(widget.data);

    if (dataJson != null) {
      for (var option in backupOptions) {
        option.selected = true;
        if (dataJson!.keys.contains(option.key)) {
          importOptions.add(option);
        }
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsTopBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
                onPressed: () async {
                  try {
                    if (dataJson == null) return;
                    for (var option in importOptions) {
                      if (option.selected && context.mounted) {
                        await option.decode(context, dataJson![option.key]);
                      }
                    }
                    if (context.mounted) {
                      showSnackBar(context, "Import successful!");
                    }
                  } catch (e) {
                    logger.e(e.toString());
                    if (context.mounted) {
                      showSnackBar(context, "Error importing: ${e.toString()}",
                          error: true);
                    }
                  }
                },
                child:
                    Text(AppLocalizations.of(context)!.importSettingsSetting)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              ...importOptions.map(
                (option) => BackupOptionCheckBox(
                  option: option,
                  onChanged: (bool? value) {
                    setState(() {
                      option.selected = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
