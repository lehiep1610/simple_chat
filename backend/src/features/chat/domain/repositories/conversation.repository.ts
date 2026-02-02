import { Conversation } from "../entities/conversation.entity";

export interface ConversationRepository {
    findByUserId(userId: string): Promise<Conversation[]>;
    findById(conversationId: string): Promise<Conversation | null>;
    create(params: { name?: string, participants: string[] }): Promise<Conversation>;
    findDirectConversation(userId1: string, userId2: string): Promise<string | null>;
}