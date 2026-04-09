export interface UserPreview {
    id: string;
    name: string;
    avatarUrl: string | null;
}

export interface UsersPage {
    users: UserPreview[];
    total: number;
    hasMore: boolean;
}
