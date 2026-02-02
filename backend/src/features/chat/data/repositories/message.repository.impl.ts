
import { Message } from "../../domain/entities/message.entity";
import { MessageRepository } from "../../domain/repositories/message.repository";
import { MessageDataSource } from "../datasources/message.datasource";

export class MessageRepositoryImpl implements MessageRepository {
    constructor(private messageDatasource: MessageDataSource) { }
    async create(params: { conversationId: string, senderId: string; body: string; messageType: "text" | "image" | "file"; }): Promise<Message> {
        return this.messageDatasource.create(params);
    }

    async findByConversationId(conversationId: string, limit: 50, offset: 0): Promise<Message[]> {
        return this.messageDatasource.findByConversationId(conversationId, limit, offset);
    }
}