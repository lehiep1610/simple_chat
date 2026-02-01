import { Friend } from "../entities/friendship.entity";

export interface FriendshipRepository {
    getFriends(userId: string): Promise<Friend[]>;
    addFriend(userId: string, friendId: string): Promise<void>;
    removeFriend(userId: string, friendId: string): Promise<void>;
}