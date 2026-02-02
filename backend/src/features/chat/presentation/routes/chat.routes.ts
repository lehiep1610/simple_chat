import { Router } from "express";
import { ConversationDatasource } from "../../data/datasources/conversation.datasource";
import { MessageDataSource } from "../../data/datasources/message.datasource";
import { ConversationRepositoryImpl } from "../../data/repositories/conversation.repository.impl";
import { MessageRepositoryImpl } from "../../data/repositories/message.repository.impl";
import { GetConversationUsecase } from "../../domain/usecases/get-conversations.usecase";
import { GetMessageUsecase } from "../../domain/usecases/get-message.usecase";
import { SendMessageUsecase } from "../../domain/usecases/send-message.usecase";
import { ChatController } from "../controllers/chat.controller";
import { authMiddleware } from "../../../../core/middlewares/auth";

// Datasource
const messageDatasource = new MessageDataSource;
const conversationDatasource = new ConversationDatasource;

// Repository 
const messageRepository = new MessageRepositoryImpl(messageDatasource);
const conversationRepository = new ConversationRepositoryImpl(conversationDatasource);

// Usecase
const sendMessageUsecase = new SendMessageUsecase(messageRepository, conversationRepository);
const getMessageUsecase = new GetMessageUsecase(messageRepository);
const getConversationUsecase = new GetConversationUsecase(conversationRepository);

// Controller
const chatController = new ChatController(sendMessageUsecase, getMessageUsecase, getConversationUsecase);

const router = Router();

router.use(authMiddleware);

// Routes
router.post('/messages', chatController.sendMessage);
router.get('/conversations', chatController.getConversation);
router.get('conversations/:conversationId/messages', chatController.getMessages);

export default router;

