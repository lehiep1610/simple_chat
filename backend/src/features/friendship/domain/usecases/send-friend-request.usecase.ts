import { FriendshipRepository } from "../repositories/friendship.repository";

export class SendFriendRequestUsecase {
    constructor(private friendshipRepository: FriendshipRepository) { }

    async execute(requesterId: string, recipientId: string): Promise<void> {
        if (requesterId === recipientId) {
            throw new Error('Cannot send friend request to yourself');
        }
        return this.friendshipRepository.sendFriendRequest(requesterId, recipientId);
    }
}
