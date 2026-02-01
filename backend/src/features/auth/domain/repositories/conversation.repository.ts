import { Conversation, Message } from "../entities/conversation.entity";

export interface ConversationRepository {
    findByUserId(userId: string): Promise<Conversation[]>;
    findById(conversationId: string): Promise<Conversation | null>;
    create(params: { name?: string, participants: string[] }): Promise<Conversation>;
    getMessages(conversationId: string, limit?: number, offset?: number): Promise<Message[]>;
    addMessage(params: { conversationId: string, senderId: string, content: string, messageType?: string }): Promise<Message>;
}