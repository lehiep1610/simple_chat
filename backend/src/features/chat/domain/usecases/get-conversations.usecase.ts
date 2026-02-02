import { Conversation } from "../entities/conversation.entity";
import { ConversationRepository } from "../repositories/conversation.repository";

export class GetConversationUsecase {
    constructor(private conversationRepository: ConversationRepository) { }
    async execute(userId: string): Promise<Conversation[]> {
        return this.conversationRepository.findByUserId(userId);
    }
}