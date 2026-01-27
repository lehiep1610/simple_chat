import { Conversation, ConversationWithDetail, Message } from "../entities/conversation.entity";

export interface ConversationRepository {
    findByUserId(userId: string): Promise<ConversationWithDetail[]>;
    findById(conversationId: string): Promise<ConversationWithDetail | null>;
    create(params: { name?: string, isGroup: boolean, participants: string[] }): Promise<Conversation>;
    getMessages(conversationId: string, limit?: number, offset?: number): Promise<Message[]>;
    addMessage(params: { conversationId: string, senderId: string, content: string, messageType?: string }): Promise<Message>;
}