import { Friend } from "../entities/friendship.entity";
import { FriendshipRepository } from "../repositories/friendship.repository";

export class GetFriendsUsecase {
    constructor(private friendshipRepository: FriendshipRepository) { }

    async execute(userId: string): Promise<Friend[]> {
        return this.friendshipRepository.getFriends(userId);
    }
}