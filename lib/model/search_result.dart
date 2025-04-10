import 'package:safmobile_portal/model/invoice.dart';
import 'package:safmobile_portal/model/jobsheet.dart';

class SearchResult {
  final Invoice? invoice;
  final Jobsheet? jobsheet;

  SearchResult.invoice(this.invoice) : jobsheet = null;
  SearchResult.jobsheet(this.jobsheet) : invoice = null;

  bool get isInvoice => invoice != null;
  bool get isJobsheet => jobsheet != null;
}
