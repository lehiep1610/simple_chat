import { pool } from "../../../../core/config/database";
import { Conversation } from "../../domain/entities/conversation.entity";

export class ConversationDatasource {
    async findByUserId(userId: string): Promise<Conversation[]> {
        const result = await pool.query(`
            SELECT c.id, c.name, c.created_at, c.updated_at
            FROM conversations c
            INNER JOIN conversation_participants cp ON c.id = cp.conversation_id
            WHERE cp.user_id = $1
            ORDER BY c.updated_at DESC
            `, [userId]);

        return result.rows.map(row => ({
            id: row.id,
            name: row.name,
            createdAt: row.created_at,
            updatedAt: row.updated_at,
        }));
    }

    async findById(conversationId: string): Promise<Conversation | null> {
        const result = await pool.query(`
            SELECT c.id, c.name, c.created_at, c.updated_at
            FROM conversation WHERE c.id = $1
            `, [conversationId]);
        if (result.rows.length === 0) return null;
        const row = result.rows[0];
        return {
            id: row.id,
            name: row.name,
            createdAt: row.created_at,
            updatedAt: row.updated_at,
        }
    }

    async create(params: { name?: string, participants: string[] }): Promise<Conversation> {
        const client = await pool.connect();
        try {
            await client.query(`BEGIN`);

            // create conversation
            const convResult = await client.query(`
            INSERT INTO conversations (name)
            VALUE ($1)
            RETURNING id, name, created_at, updated_at
            `, [params.name || null])

            const conversation = convResult.rows[0];

            // add participants
            for (const participantId of params.participants) {
                await client.query(`
                    INSERT INTO conversation_participants(conversation_id, user_id)
                    VALUE($1, $2)
                    `, [conversation.id, participantId])
            }

            await client.query('COMMIT');

            return {
                id: conversation.id,
                name: conversation.name,
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
        FROM conversation c
        JOIN conversation_participants cp1 ON c.id = cp1.conersation_id AND cp1.user_id = $1
        JOIN conversation_participants cp2 ON c.id = cp2.conversation_id AND cp2.user_id =$2
        WHERE (SELECT COUNT(*) FROM conversation_participants WHERE conversation_id = c.id) = 2
        LIMIT 1
    `, [userId1, userId2])
        return result.rows.length > 0 ? result.rows[0].id : null;
    }
}