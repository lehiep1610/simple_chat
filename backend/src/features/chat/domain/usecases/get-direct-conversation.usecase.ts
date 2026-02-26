import { Message } from "../entities/message.entity";
import { ConversationRepository } from "../repositories/conversation.repository";
import { MessageRepository } from "../repositories/message.repository";

export class GetDirectConversationUsecase {
    constructor(private conversationRepository: ConversationRepository) { }

    async execute(params: { userId: string, recipientId: string; limit?: number, offset?: number }): Promise<string> {
        const { userId, recipientId, limit = 50, offset = 0 } = params;

        // Find or create conversation
        let conversationId = await this.conversationRepository.findDirectConversation(userId, recipientId);

        if (!conversationId) {
            const conversation = await this.conversationRepository.create({ participants: [userId, recipientId], creatorId: userId });
            conversationId = conversation.id;
        }

        return conversationId;

    }
}