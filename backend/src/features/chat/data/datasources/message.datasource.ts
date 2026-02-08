import { pool } from "../../../../core/config/database";
import { Message } from "../../domain/entities/message.entity";

export class MessageDataSource {
    async create(params: { conversationId: string, senderId: string, body: string, messageType: 'text' | 'image' | 'file' }): Promise<Message> {
        const result = await pool.query(`
            INSERT INTO messages (conversation_id, sender_id, body, message_type)
            VALUES ($1, $2, $3, $4)
            RETURNING id, conversation_id, sender_id, body, message_type, created_at, updated_at
            `, [params.conversationId, params.senderId, params.body, params.messageType])

        const row = result.rows[0];
        return {
            id: row.id,
            conversationId: row.conversation_id,
            senderId: row.sender_id,
            body: row.body,
            messageType: row.message_type,
            createdAt: row.created_at,
            updatedAt: row.updated_at,
        }
    }

    async findByConversationId(conversationId: string, limit: 50, offset: 0): Promise<Message[]> {
        const result = await pool.query(`
            SELECT m.id, m.conversation_id, m.sender_id, m.body, m.message_type, 
                m.created_at, m.updated_at, u.name as sender_name
            FROM messages m
            LEFT JOIN users u ON m.sender_id = u.id
            WHERE m.conversation_id = $1
            ORDER BY m.created_at DESC
            LIMIT $2 OFFSET $3
        `, [conversationId, limit, offset])

        return result.rows.map(row => ({
            id: row.id,
            conversationId: row.conversation_id,
            senderId: row.sender_id,
            senderName: row.sender_name,
            body: row.body,
            messageType: row.message_type,
            createdAt: row.created_at,
            updatedAt: row.updated_at
        }))
    }
}