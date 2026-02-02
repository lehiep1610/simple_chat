import { Message } from "../entities/message.entity";
import { MessageRepository } from "../repositories/message.repository";

export class GetMessageUsecase {
    constructor(private messageRepository: MessageRepository) { }

    async execute(params: {
        conversationId: string,
        limit?: number,
        offset?: number,
    }): Promise<Message[]> {
        const { conversationId, limit = 50, offset = 0 } = params;
        return this.messageRepository.findByConversationId(conversationId, limit, offset)
    }
}