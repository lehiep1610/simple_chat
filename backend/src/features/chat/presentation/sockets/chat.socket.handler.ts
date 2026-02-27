import { Namespace, Socket } from "socket.io";
import { SendMessageUsecase } from "../../domain/usecases/send-message.usecase";

interface SocketWithAuth extends Socket {
    userId?: string;
}

export class ChatSocketHandler {
    constructor(
        private chatNamespace: Namespace,
        private sendMessageUsecase: SendMessageUsecase
    ) {
        this.setupHandlers();
    }

    private setupHandlers() {
        this.chatNamespace.on('connection', (socket: SocketWithAuth) => {
            console.log(`User connected: ${socket.userId}`);
            this.handleSendMessage(socket);
            this.handleJoinConversation(socket);
            this.handleDisconnect(socket);
        });
    }

    private handleSendMessage(socket: SocketWithAuth) {
        socket.on('send:message', async (data: {
            conversationId: string,
            body: string,
            messageType?: 'text' | 'image' | 'file'
        }) => {
            try {
                const message = await this.sendMessageUsecase.execute({
                    conversationId: data.conversationId,
                    senderId: socket.userId!,
                    body: data.body,
                    messageType: data.messageType || 'text'
                });

                this.chatNamespace.to(data.conversationId).emit('new:message', message);
            } catch (error) {
                console.error('Error sending message:', error);
                socket.emit('error:message', {
                    message: error instanceof Error ? error.message : 'Failed to send message'
                });
            }
        });
    }

    private handleJoinConversation(socket: SocketWithAuth) {
        socket.on('join:conversation', (conversationId: string) => {
            socket.join(conversationId);
        });
    }

    private handleDisconnect(socket: SocketWithAuth) {
        socket.on('disconnect', () => {
            console.log(`User disconnected: ${socket.userId}`);
        });
    }
}