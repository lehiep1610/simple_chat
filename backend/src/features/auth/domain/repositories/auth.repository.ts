import { User, UserWithPassword } from '../entities/user.entity';

export interface AuthRepository {
    create(user: { email: string, hashedPassword: string, name: string }): Promise<User>;
    findById(id: string): Promise<User | null>;
    findByEmail(email: string): Promise<UserWithPassword | null>;
}