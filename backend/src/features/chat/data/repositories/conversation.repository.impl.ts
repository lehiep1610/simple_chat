import { Conversation } from "../../domain/entities/conversation.entity";
import { ConversationRepository } from "../../domain/repositories/conversation.repository";
import { ConversationDatasource } from "../datasources/conversation.datasource";

export class ConversationRepositoryImpl implements ConversationRepository {
    constructor(private conversationDatasource: ConversationDatasource) { }
    async findByUserId(userId: string): Promise<Conversation[]> {
        return this.conversationDatasource.findByUserId(userId);
    }
    findById(conversationId: string): Promise<Conversation | null> {
        return this.conversationDatasource.findById(conversationId);
    }
    create(params: { name?: string, creatorId: string, participants: string[] }): Promise<Conversation> {
        return this.conversationDatasource.create(params);
    }
    findDirectConversation(userId1: string, userId2: string): Promise<string | null> {
        return this.conversationDatasource.findDirectConversation(userId1, userId2);
    }
    updateLastMessage(conversationId: string, body: string): Promise<void> {
        return this.conversationDatasource.updateLastMessage(conversationId, body);
    }
}