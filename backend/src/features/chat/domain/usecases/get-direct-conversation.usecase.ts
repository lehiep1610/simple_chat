import { Message } from "../entities/message.entity";
import { ConversationRepository } from "../repositories/conversation.repository";
import { MessageRepository } from "../repositories/message.repository";

export interface GetConversationUsecaseResult {
    conversationId: string;
    messages: Message[];
    hasMore: boolean;
}

export class GetDirectConversationUsecase {
    constructor(private conversationRepository: ConversationRepository, private messageRepository: MessageRepository) { }

    async execute(params: { userId: string, recipientId: string; limit?: number, offset?: number }): Promise<GetConversationUsecaseResult> {
        const { userId, recipientId, limit = 50, offset = 0 } = params;

        // Find or create conversation
        let conversationId = await this.conversationRepository.findDirectConversation(userId, recipientId);

        if (!conversationId) {
            const conversation = await this.conversationRepository.create({ participants: [userId, recipientId] });
            conversationId = conversation.id;
        }

        // Get message with pagination
        const messages = await this.messageRepository.findByConversationId(
            conversationId,
            limit + 1,  // fetch one extra to check has more
            offset);

        // Check if there are more messsages
        const hasMore = messages.length > limit;
        const resultmessages = hasMore ? messages.slice(0, limit) : messages;

        return { conversationId, messages: resultmessages, hasMore }

    }
}