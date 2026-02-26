import { Request, Response, NextFunction } from "express";
import { GetConversationUsecase } from "../../domain/usecases/get-conversations.usecase";
import { GetMessageUsecase } from "../../domain/usecases/get-message.usecase";
import { SendMessageUsecase } from "../../domain/usecases/send-message.usecase";
import { GetDirectConversationUsecase } from "../../domain/usecases/get-direct-conversation.usecase";

export class ChatController {
    constructor(
        private sendMessageUsecase: SendMessageUsecase,
        private getMessageUsecase: GetMessageUsecase,
        private getConversationUsecase: GetConversationUsecase,
        private getDirectConversationUsecase: GetDirectConversationUsecase
    ) { }

    sendMessage = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const senderId = req.userId!;
            const { conversationId, body, messageType } = req.body;

            if (!conversationId) {
                return res.status(400).json({ message: 'conversationId is required' })
            }

            const message = await this.sendMessageUsecase.execute({ conversationId, senderId, body, messageType })
            res.status(201).json({ message });
        } catch (e) {
            next(e)
        }
    }

    getMessages = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const conversationId = req.params.conversationId as string;;
            const limit = parseInt(req.query.limit as string) || 50;
            const offset = parseInt(req.query.offset as string) || 0;

            const messages = await this.getMessageUsecase.execute({ conversationId, limit, offset });
            res.json({ messages });
        } catch (e) {
            next(e)
        }
    }

    getConversation = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const userId = req.userId!;
            const conversations = await this.getConversationUsecase.execute(userId);
            res.json({ conversations });
        } catch (e) {
            next(e);
        }
    }

    getDirectConversation = async (req: Request, res: Response, next: NextFunction) => {
        try {
            const userId = req.userId!;
            const recipientId = req.params.recipientId as string;


            if (!recipientId) {
                return res.status(400).json({ message: `recipientId is required` });
            }

            const conversationId = await this.getDirectConversationUsecase.execute({ userId, recipientId });
            res.json({ conversationId });
        } catch (e) {
            next(e)
        }
    }
}