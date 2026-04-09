import { pool } from "../../../../core/config/database";
import { Friend } from "../../domain/entities/friendship.entity";

export class FriendshipDatasource {
    async getFriends(userId: string): Promise<Friend[]> {
        const result = pool.query(`
            SELECT 
                u.id as friend_id,
                u.name as friend_name,
                u.email as friend_email,
                u.avatar_url as friend_avatar_url,
                f.created_at
            FROM friendships f
            INNER JOIN users u ON (
            CASE 
                WHEN f.user_low_id =$1 THEN f.user_high_id = u.id
                ELSE f.user_low_id = u.id
            END
            )
            WHERE f.user_low_id = $1 OR f.user_high_id = $1
            ORDER BY u.name ASC
        `, [userId]);

        return (await result).rows.map(row => ({
            id: row.friend_id,
            friendId: row.friend_id,
            friendName: row.friend_name,
            friendEmail: row.friend_email,
            friendAvatarUrl: row.friend_avatar_url,
            createdAt: row.create_at,
        }))
    }

    async addFriend(userId: string, friendId: string): Promise<void> {
        const [userLowId, userHighId] = [userId, friendId].sort();

        await pool.query(`
        INSERT INTO friendships(user_low_id, user_high_id)
        VALUE($1, $2)
        ON CONFLICT (user_low_id, user_high_id) DO NOTHING
        `, [userLowId, userHighId]);
    }

    async removeFriend(userId: string, friendId: string): Promise<void> {
        const [userLowId, userHighId] = [userId, friendId].sort();

        await pool.query(`
            DELETE FROM friendships
            WHERE user_low_id = $1 AND user_high_id = $2
        `, [userLowId, userHighId]);
    }

    async sendFriendRequest(requesterId: string, recipientId: string): Promise<void> {
        await pool.query(`
            INSERT INTO friend_requests (requester_id, recipient_id, status)
            VALUES ($1, $2, 'pending')
            ON CONFLICT (requester_id, recipient_id) DO NOTHING
        `, [requesterId, recipientId]);
    }
}
