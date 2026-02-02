import { Request, Response, NextFunction } from "express";
import { GetFriendsUsecase } from "../../domain/usecases/get-friends.usecase";

export class FriendshipController {
    constructor(private getFriendsUsecase: GetFriendsUsecase) { }

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

}


