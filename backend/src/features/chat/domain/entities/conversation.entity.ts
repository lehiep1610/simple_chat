export interface Conversation {
    id: string;
    name: string | null;
    lastMessage: string | null;
    lastMessageAt: Date | null;
    avatarUrl: string | null;
    createdAt: Date;
    updatedAt: Date;
}