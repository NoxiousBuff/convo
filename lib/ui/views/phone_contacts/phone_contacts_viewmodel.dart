import 'package:hint/api/hive.dart';
import 'package:stacked/stacked.dart';
import 'package:hint/app/app_logger.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class PhoneContactsViewModel extends BaseViewModel {
  final log = getLogger('PhoneContactsViewModel');

  final countryCodePattern =
      r'\+(?:998|996|995|994|993|992|977|976|975|974|973|972|971|970|968|967|966|965|964|963|962|961|960|886|880|856|855|853|852|850|692|691|690|689|688|687|686|685|683|682|681|680|679|678|677|676|675|674|673|672|670|599|598|597|595|593|592|591|590|509|508|507|506|505|504|503|502|501|500|423|421|420|389|387|386|385|383|382|381|380|379|378|377|376|375|374|373|372|371|370|359|358|357|356|355|354|353|352|351|350|299|298|297|291|290|269|268|267|266|265|264|263|262|261|260|258|257|256|255|254|253|252|251|250|249|248|246|245|244|243|242|241|240|239|238|237|236|235|234|233|232|231|230|229|228|227|226|225|224|223|222|221|220|218|216|213|212|211|98|95|94|93|92|91|90|86|84|82|81|66|65|64|63|62|61|60|58|57|56|55|54|53|52|51|49|48|47|46|45|44\D?1624|44\D?1534|44\D?1481|44|43|41|40|39|36|34|33|32|31|30|27|20|7|1\D?939|1\D?876|1\D?869|1\D?868|1\D?849|1\D?829|1\D?809|1\D?787|1\D?784|1\D?767|1\D?758|1\D?721|1\D?684|1\D?671|1\D?670|1\D?664|1\D?649|1\D?473|1\D?441|1\D?345|1\D?340|1\D?284|1\D?268|1\D?264|1\D?246|1\D?242|1)\D?';

  List<Contact>? _contacts;
  List<Contact>? get contacts => _contacts;

  void updateContacts(List<Contact> contact) {
    _contacts = contact;
    notifyListeners();
  }

  Future<bool> _requestContactsPermission() async {
    final permission = Permission.contacts;
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> gettingNumbers() async {
    setBusy(true);

    try {
      if (_contacts != null) {
        log.wtf('Step1:$_contacts');
        for (var contact in _contacts!) {
          log.wtf('Step2:$contact');
          final phones = contact.phones;
          if (phones != null && phones.isNotEmpty) {
            log.wtf('Step3:$phones');
            for (var phone in phones) {
              log.wtf('Step4:$phone');
              final value = phone.value;
              if (value != null) {
                final v = value;
                final phoneNumber = v.toString();
                final number = numberFormatter(phoneNumber);
                // final code = extractCode(number);
                final key = number;
                await hiveApi.save(HiveApi.userContacts, key, number);
                
              }
            }
          }
        }
      }
    } catch (e) {
      log.e('GettingNumbers Error:$e');
    }
    setBusy(false);
  }

  // String? extractCode(String number) {
  //   RegExp exp = RegExp(countryCodePattern);
  //   Iterable<RegExpMatch> matches = exp.allMatches(number);

  //   final match = matches.first;
  //     String? code = number.substring(match.start, match.end);
  //   return code ?? '+91' ;
  // }

  String numberFormatter(String number) {
    const countryCodePattern =
        r'\+(?:998|996|995|994|993|992|977|976|975|974|973|972|971|970|968|967|966|965|964|963|962|961|960|886|880|856|855|853|852|850|692|691|690|689|688|687|686|685|683|682|681|680|679|678|677|676|675|674|673|672|670|599|598|597|595|593|592|591|590|509|508|507|506|505|504|503|502|501|500|423|421|420|389|387|386|385|383|382|381|380|379|378|377|376|375|374|373|372|371|370|359|358|357|356|355|354|353|352|351|350|299|298|297|291|290|269|268|267|266|265|264|263|262|261|260|258|257|256|255|254|253|252|251|250|249|248|246|245|244|243|242|241|240|239|238|237|236|235|234|233|232|231|230|229|228|227|226|225|224|223|222|221|220|218|216|213|212|211|98|95|94|93|92|91|90|86|84|82|81|66|65|64|63|62|61|60|58|57|56|55|54|53|52|51|49|48|47|46|45|44\D?1624|44\D?1534|44\D?1481|44|43|41|40|39|36|34|33|32|31|30|27|20|7|1\D?939|1\D?876|1\D?869|1\D?868|1\D?849|1\D?829|1\D?809|1\D?787|1\D?784|1\D?767|1\D?758|1\D?721|1\D?684|1\D?671|1\D?670|1\D?664|1\D?649|1\D?473|1\D?441|1\D?345|1\D?340|1\D?284|1\D?268|1\D?264|1\D?246|1\D?242|1)\D?';
    final String formattedNumber = number
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(RegExp(r"\s+"), "")
        .replaceAll('-', '')
        .replaceAll(RegExp(countryCodePattern), '');
    return formattedNumber;
  }

  Future<void> getContacts() async {
    if (await _requestContactsPermission()) {
      final List<Contact> localContacts = await ContactsService.getContacts(
          withThumbnails: false, photoHighResolution: false);
      updateContacts(localContacts);
      log.wtf('Contacts:$_contacts');
      log.wtf('Length:${_contacts!.length}');
    }
  }
}
