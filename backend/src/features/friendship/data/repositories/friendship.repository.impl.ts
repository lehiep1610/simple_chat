
import { FriendshipDatasource } from "../../../friendship/data/datasources/friendship.datasource";
import { Friend } from "../../domain/entities/friendship.entity";
import { FriendshipRepository } from "../../domain/repositories/friendship.repository";

export class FriendshipRepositoryImpl implements FriendshipRepository {
    constructor(private friendshipDatasource: FriendshipDatasource) { }

    async getFriends(userId: string): Promise<Friend[]> {
        return this.friendshipDatasource.getFriends(userId);
    }

    async addFriend(userId: string, friendId: string): Promise<void> {
        return this.friendshipDatasource.addFriend(userId, friendId);
    }
    async removeFriend(userId: string, friendId: string): Promise<void> {
        return this.friendshipDatasource.removeFriend(userId, friendId);
    }
}