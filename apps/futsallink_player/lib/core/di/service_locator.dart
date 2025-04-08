import 'package:get_it/get_it.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Registrar o repositório home
  serviceLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(),
  );
  
  // Registrar outros serviços aqui conforme necessário
} 