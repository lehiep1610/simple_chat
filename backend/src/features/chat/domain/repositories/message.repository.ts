import { Message } from "../entities/message.entity";


export interface MessageRepository {
    create(params: {
        conversationId: string;
        senderId: string;
        body: string;
        messageType: 'text' | 'image' | 'file';
    }): Promise<Message>;

    findByConversationId(conversationId: string, limit?: number, offset?: number): Promise<Message[]>;
}