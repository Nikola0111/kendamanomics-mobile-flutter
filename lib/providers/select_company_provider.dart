import 'package:flutter/cupertino.dart';
import 'package:kendamanomics_mobile/models/company.dart';
import 'package:kendamanomics_mobile/services/company_service.dart';
import 'package:kiwi/kiwi.dart';

class SelectCompanyProvider extends ChangeNotifier {
  final _companyService = KiwiContainer().resolve<CompanyService>();

  final _companies = <Company>[];

  List<Company> get companies => _companies;

  SelectCompanyProvider() {
    _companies.addAll(_companyService.companies);
  }
}
