import { pool } from "../../../../core/config/database";
import { Conversation } from "../../domain/entities/conversation.entity";

export class ConversationDatasource {
    async findByUserId(userId: string): Promise<Conversation[]> {
        const result = await pool.query(`
            SELECT c.id, c.name, c.last_message, c.last_message_at, c.avatar_url, c.created_at, c.updated_at
            FROM conversations c
            INNER JOIN conversation_participants cp ON c.id = cp.conversation_id
            WHERE cp.user_id = $1
            ORDER BY COALESCE(c.last_message_at, c.updated_at) DESC
            `, [userId]);
        if (result.rows.length === 0) return [];
        return result.rows.map(row => ({
            id: row.id,
            name: row.name,
            lastMessage: row.last_message,
            lastMessageAt: row.last_message_at,
            avatarUrl: row.avatar_url,
            createdAt: row.created_at,
            updatedAt: row.updated_at,
        }));
    }

    async findById(conversationId: string): Promise<Conversation | null> {
        const result = await pool.query(`
            SELECT c.id, c.name, c.created_at, c.updated_at, c.avatar_url, c.last_message, c.last_message_at
            FROM conversations c WHERE c.id = $1
            `, [conversationId]);
        if (result.rows.length === 0) return null;
        const row = result.rows[0];
        return {
            id: row.id,
            name: row.name,
            lastMessage: row.last_message,
            lastMessageAt: row.last_message_at,
            avatarUrl: row.avatar_url,
            createdAt: row.created_at,
            updatedAt: row.updated_at,
        }
    }

    async create(params: { name?: string, creatorId: string, participants: string[] }): Promise<Conversation> {
        const client = await pool.connect();
        try {
            await client.query(`BEGIN`);

            let conversationName: string | null = params.name ?? null;
            let conversationAvatarUrl: string | null = null;

            // DM (Direct Message) conversation
            if (!conversationName && params.participants.length === 2) {
                const otherUserId = params.participants.find(id => id !== params.creatorId);
                if (otherUserId) {
                    const otherUser = await client.query(`
                        SELECT name, avatar_url FROM users WHERE id = $1
                        `, [otherUserId]);
                    if (otherUser.rows.length > 0) {
                        conversationName = otherUser.rows[0].name;
                        conversationAvatarUrl = otherUser.rows[0].avatar_url;
                    }
                }
            }

            // create conversation
            const convResult = await client.query(`
                INSERT INTO conversations (name, avatar_url)
                VALUES ($1, $2)
                RETURNING id, name, last_message, last_message_at, avatar_url, created_at, updated_at
                `, [conversationName, conversationAvatarUrl]);
            const conversation = convResult.rows[0];

            // add participants
            for (const participantId of params.participants) {
                await client.query(`
                    INSERT INTO conversation_participants(conversation_id, user_id)
                    VALUES($1, $2)
                    `, [conversation.id, participantId])
            }

            await client.query('COMMIT');

            return {
                id: conversation.id,
                name: conversation.name,
                lastMessage: conversation.last_message,
                lastMessageAt: conversation.last_message_at,
                avatarUrl: conversation.avatar_url,
                createdAt: conversation.created_at,
                updatedAt: conversation.updated_at,

            }
        } catch (error) {
            await client.query(`ROLLBACK`);
            throw error;
        } finally {
            client.release();
        }
    }

    async findDirectConversation(userId1: string, userId2: string): Promise<string | null> {
        const result = await pool.query(`
        SELECT c.id
        FROM conversations c
        JOIN conversation_participants cp1 ON c.id = cp1.conversation_id AND cp1.user_id = $1
        JOIN conversation_participants cp2 ON c.id = cp2.conversation_id AND cp2.user_id =$2
        WHERE (SELECT COUNT(*) FROM conversation_participants WHERE conversation_id = c.id) = 2
        LIMIT 1
    `, [userId1, userId2])
        return result.rows.length > 0 ? result.rows[0].id : null;
    }

    async updateLastMessage(conversationId: string, body: string): Promise<void> {
        await pool.query(`
            UPDATE conversations 
            SET last_message = $1, last_message_at = NOW(), updated_at = NOW()
            WHERE id = $2
            `, [body.length > 100 ? body.substring(0, 100) + '...' : body, conversationId])
    }
}