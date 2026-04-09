import { pool } from "../../../../core/config/database";
import { UserPreview, UsersPage } from "../../domain/entities/user-preview.entity";
import { GetUsersParams } from "../../domain/repositories/users.repository";

export class UsersDatasource {
    async getUsers(params: GetUsersParams): Promise<UsersPage> {
        const { currentUserId, limit, offset } = params;

        const query = `
            SELECT u.id, u.name, u.avatar_url
            FROM users u
            WHERE u.id != $1
              AND NOT EXISTS (
                  SELECT 1 FROM friendships f
                  WHERE (f.user_low_id = LEAST(u.id, $1::uuid) AND f.user_high_id = GREATEST(u.id, $1::uuid))
              )
              AND NOT EXISTS (
                  SELECT 1 FROM friend_requests fr
                  WHERE (fr.requester_id = $1 AND fr.recipient_id = u.id)
                     OR (fr.requester_id = u.id AND fr.recipient_id = $1)
              )
            ORDER BY u.name ASC
            LIMIT $2 OFFSET $3
        `;

        const countQuery = `
            SELECT COUNT(*) AS total
            FROM users u
            WHERE u.id != $1
              AND NOT EXISTS (
                  SELECT 1 FROM friendships f
                  WHERE (f.user_low_id = LEAST(u.id, $1::uuid) AND f.user_high_id = GREATEST(u.id, $1::uuid))
              )
              AND NOT EXISTS (
                  SELECT 1 FROM friend_requests fr
                  WHERE (fr.requester_id = $1 AND fr.recipient_id = u.id)
                     OR (fr.requester_id = u.id AND fr.recipient_id = $1)
              )
        `;

        const [rowsResult, countResult] = await Promise.all([
            pool.query(query, [currentUserId, limit, offset]),
            pool.query(countQuery, [currentUserId]),
        ]);

        const users: UserPreview[] = rowsResult.rows.map(row => ({
            id: row.id,
            name: row.name,
            avatarUrl: row.avatar_url,
        }));

        const total = parseInt(countResult.rows[0].total, 10);
        const hasMore = offset + users.length < total;

        return { users, total, hasMore };
    }
}
