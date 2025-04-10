import 'package:mockito/annotations.dart';
import 'package:lyrix_frontend/account_service.dart';

@GenerateMocks([AccountService])
void main() {
  // This is needed to keep the file active during the build
  print("Generating mocks for AccountService...");
}
