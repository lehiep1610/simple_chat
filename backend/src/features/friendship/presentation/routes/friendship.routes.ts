import { Router } from "express";
import { FriendshipDatasource } from "../../data/datasources/friendship.datasource";
import { GetFriendsUsecase } from "../../domain/usecases/get-friends.usecase";
import { SendFriendRequestUsecase } from "../../domain/usecases/send-friend-request.usecase";
import { FriendshipController } from "../controllers/friendship.controller";
import { authMiddleware } from "../../../../core/middlewares/auth";
import { FriendshipRepositoryImpl } from "../../data/repositories/friendship.repository.impl";

// DI
const friendshipDatasource = new FriendshipDatasource();
const friendshipRepositoryImpl = new FriendshipRepositoryImpl(friendshipDatasource);
const getFriendsUseCase = new GetFriendsUsecase(friendshipRepositoryImpl);
const sendFriendRequestUsecase = new SendFriendRequestUsecase(friendshipRepositoryImpl);
const friendshipController = new FriendshipController(getFriendsUseCase, sendFriendRequestUsecase);

const router = Router();

router.get('/', authMiddleware, friendshipController.getFriends);
router.post('/requests', authMiddleware, friendshipController.sendFriendRequest);

export default router;
