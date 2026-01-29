import { Router } from "express";
import { FriendshipDatasource } from "../../data/datasources/friendship.datasource";
import { GetFriendsUsecase } from "../../domain/usecases/get-friends.usecase";
import { FriendshipController } from "../controllers/friendship.controller";
import { authMiddleware } from "../../../../core/middlewares/auth";
import { FriendshipRepositoryImpl } from "../../data/repositories/friendship.repository.impl";

//DI
const friendshipDatasource = new FriendshipDatasource();
const friendshipRepositoryImpl = new FriendshipRepositoryImpl(friendshipDatasource);
const getFriendsUseCase = new GetFriendsUsecase(friendshipRepositoryImpl);
const friendshipController = new FriendshipController(getFriendsUseCase);

const router = Router();

router.get('/', authMiddleware, friendshipController.getFriends);

export default router;

