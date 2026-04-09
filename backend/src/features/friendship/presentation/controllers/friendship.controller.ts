import { Request, Response, NextFunction } from "express";
import { GetFriendsUsecase } from "../../domain/usecases/get-friends.usecase";
import { SendFriendRequestUsecase } from "../../domain/usecases/send-friend-request.usecase";

export class FriendshipController {
    constructor(
        private getFriendsUsecase: GetFriendsUsecase,
        private sendFriendRequestUsecase: SendFriendRequestUsecase,
    ) { }

    getFriends = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const userId = req.userId;
            if (!userId) {
                return res.status(401).json({ message: `Unauthorized` })
            }
            const friends = await this.getFriendsUsecase.execute(userId)
            return res.json({ data: friends });
        } catch (error) {
            next(error);
        }
    }

    sendFriendRequest = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const requesterId = req.userId;
            if (!requesterId) {
                return res.status(401).json({ message: 'Unauthorized' });
            }

            const { recipientId } = req.body;
            if (!recipientId) {
                return res.status(400).json({ message: 'recipientId is required' });
            }

            const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
            if (!UUID_REGEX.test(recipientId)) {
                return res.status(400).json({ message: 'recipientId must be a valid UUID' });
            }

            await this.sendFriendRequestUsecase.execute(requesterId, recipientId);
            return res.status(201).json({ message: 'Friend request sent' });
        } catch (error) {
            if (error instanceof Error && error.message === 'Cannot send friend request to yourself') {
                return res.status(400).json({ message: error.message });
            }
            next(error);
        }
    }
}
