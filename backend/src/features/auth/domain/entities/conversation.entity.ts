export interface Conversation {
    id: string;
    name: string | null;
    isGroup: boolean;
    createdAt: Date;
    updatedAt: Date;
}

export interface ConversationWithDetail extends Conversation {
    participants: Participant[];
    lastMessage: Message | null;
    unreadCount?: number;
}

export interface Participant {
    id: string;
    userId: string;
    userName: string;
    userEmail: string;
    avatarUrl: string | null;
    joinedAt: Date;
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