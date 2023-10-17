import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kendamanomics_mobile/extensions/custom_colors.dart';
import 'package:kendamanomics_mobile/extensions/custom_text_styles.dart';
import 'package:kendamanomics_mobile/models/company.dart';
import 'package:kendamanomics_mobile/providers/select_company_provider.dart';
import 'package:provider/provider.dart';

class SelectCompanyPage extends StatelessWidget {
  static const pageName = 'select-company';
  const SelectCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.of(context).backgroundColor,
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => SelectCompanyProvider(),
          builder: (context, child) {
            return Consumer<SelectCompanyProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Text(
                        'select_company_page.title',
                        style: CustomTextStyles.of(context).regular25,
                        textAlign: TextAlign.center,
                      ).tr(),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: provider.companies.length,
                          itemBuilder: (context, index) => _companyItem(context, company: provider.companies[index]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _companyItem(BuildContext context, {required Company company}) {
    return GestureDetector(
      onTap: () {
        context.pop({'id': company.id, 'name': company.name});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: CustomColors.of(context).borderColor),
        ),
        child: Text(company.name, style: CustomTextStyles.of(context).light24Opacity),
      ),
    );
  }
}
