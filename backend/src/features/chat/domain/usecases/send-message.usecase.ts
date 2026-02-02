import { BadRequestError } from "../../../../core/errors/app-error";
import { Message } from "../entities/message.entity";
import { ConversationRepository } from "../repositories/conversation.repository";
import { MessageRepository } from "../repositories/message.repository";

export class SendMessageUsecase {
    constructor(
        private messageRepository: MessageRepository,
        private conversationRepository: ConversationRepository,
    ) { }

    async execute(params: {
        senderId: string;
        recipientId: string;
        body: string;
        messageType?: 'text' | 'image' | 'file'
    }): Promise<Message> {
        const { senderId, recipientId, body, messageType = 'text' } = params;

        // Validate
        if (!body || body.trim().length === 0) {
            throw new BadRequestError('Message body cannot be empty');
        }

        if (senderId === recipientId) {
            throw new BadRequestError('Cannot send message to yourself');
        }

        // Business logic
        let conversationId = await this.conversationRepository.findDirectConversation(senderId, recipientId);

        if (!conversationId) {
            const conversation = await this.conversationRepository.create({ participants: [senderId, recipientId] });
            conversationId = conversation.id;
        }

        // Create message
        return this.messageRepository.create({
            conversationId, senderId, body: body.trim(), messageType: messageType
        });
    }
}