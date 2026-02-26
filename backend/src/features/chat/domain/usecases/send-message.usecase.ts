import { BadRequestError, NotFoundError } from "../../../../core/errors/app-error";
import { Message } from "../entities/message.entity";
import { ConversationRepository } from "../repositories/conversation.repository";
import { MessageRepository } from "../repositories/message.repository";

export class SendMessageUsecase {
    constructor(
        private messageRepository: MessageRepository,
        private conversationRepository: ConversationRepository,
    ) { }

    async execute(params: {
        conversationId: string;
        senderId: string;
        body: string;
        messageType?: 'text' | 'image' | 'file'
    }): Promise<Message> {
        const { conversationId, senderId, body, messageType = 'text' } = params;

        // Validate
        if (!body || body.trim().length === 0) {
            throw new BadRequestError('Message body cannot be empty');
        }

        // Validate conversation exists
        const conversation = await this.conversationRepository.findById(conversationId);
        if (!conversation) {
            throw new NotFoundError('Conversation not found');
        }

        // Create message
        const message = await this.messageRepository.create({
            conversationId, senderId, body: body.trim(), messageType: messageType
        });

        // Update last message
        await this.conversationRepository.updateLastMessage(conversationId, body.trim());

        return message;
    }
}