import { Request, Response, NextFunction } from "express";
import { GetUsersUsecase } from "../../domain/usecases/get-users.usecase";

export class UsersController {
    constructor(private getUsersUsecase: GetUsersUsecase) { }

    getUsers = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const userId = req.userId;
            if (!userId) {
                return res.status(401).json({ message: 'Unauthorized' });
            }

            const rawLimit = parseInt(req.query.limit as string, 10);
            const rawOffset = parseInt(req.query.offset as string, 10);

            const limit = isNaN(rawLimit) ? 20 : Math.min(rawLimit, 50);
            const offset = isNaN(rawOffset) ? 0 : Math.max(rawOffset, 0);

            const result = await this.getUsersUsecase.execute({
                currentUserId: userId,
                limit,
                offset,
            });

            return res.json({
                data: result.users,
                meta: {
                    total: result.total,
                    hasMore: result.hasMore,
                },
            });
        } catch (error) {
            next(error);
        }
    }
}
