import { Message } from "../entities/message.entity";
import { MessageRepository } from "../repositories/message.repository";


export interface GetMessagesResult {
    messages: Message[];
    hasMore: boolean;
}
export class GetMessageUsecase {
    constructor(private messageRepository: MessageRepository) { }

    async execute(params: {
        conversationId: string,
        limit?: number,
        offset?: number,
    }): Promise<GetMessagesResult> {
        const { conversationId, limit = 50, offset = 0 } = params;
        const rows = await this.messageRepository.findByConversationId(
            conversationId,
            limit + 1,
            offset);

        const hasMore = rows.length > limit;
        const messages = hasMore ? rows.slice(0, limit) : rows;
        return {
            messages: hasMore ? messages.slice(0, limit) : messages,
            hasMore: hasMore
        };
    }
}