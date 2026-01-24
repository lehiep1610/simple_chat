import { Router } from 'express';
import { AuthController } from '../controllers/auth.controller';
import { AuthDatasource } from '../../data/datasources/auth.datasource';
import { AuthRepositoryImpl } from '../../data/repositories/auth.repository.impl';
import { RegisterUsecase } from '../../domain/usecases/register.usecase';
import { LoginUsecase } from '../../domain/usecases/login.usecase';

// DI
const authDataSource = new AuthDatasource();
const authRepository = new AuthRepositoryImpl(authDataSource);
const registerUsecase = new RegisterUsecase(authRepository);
const loginUsecase = new LoginUsecase(authRepository);
const authController = new AuthController(loginUsecase, registerUsecase);

const router = Router();
router.post('/register', authController.register);
router.post('/login', authController.login);

export default router;