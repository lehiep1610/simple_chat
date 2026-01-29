export interface Conversation {
    id: string;
    name: string | null;
    createdAt: Date;
    updatedAt: Date;
}

export interface Message {
    id: string;
    conversationId: string;
    senderId: string;
    senderName?: string;
    body: string;
    messageType: 'text' | 'image' | 'file';
    createdAt: Date;
    updatedAt: Date;
}