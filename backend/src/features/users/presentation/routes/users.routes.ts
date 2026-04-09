import { Router } from "express";
import { authMiddleware } from "../../../../core/middlewares/auth";
import { UsersDatasource } from "../../data/datasources/users.datasource";
import { UsersRepositoryImpl } from "../../data/repositories/users.repository.impl";
import { GetUsersUsecase } from "../../domain/usecases/get-users.usecase";
import { UsersController } from "../controllers/users.controller";

// DI
const usersDatasource = new UsersDatasource();
const usersRepositoryImpl = new UsersRepositoryImpl(usersDatasource);
const getUsersUsecase = new GetUsersUsecase(usersRepositoryImpl);
const usersController = new UsersController(getUsersUsecase);

const router = Router();

router.get('/', authMiddleware, usersController.getUsers);

export default router;
