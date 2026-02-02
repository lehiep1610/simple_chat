import { User } from '../../../auth/domain/entities/user.entity';

export interface Friend {
    id: string;
    friendId: string;
    friendName: string;
    friendEmail: string;
    friendAvatarUrl: string | null;
    createdAt: Date;
}