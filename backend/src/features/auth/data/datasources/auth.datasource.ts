import { pool } from '../../../../core/config/database';
import { User, UserWithPassword } from '../../domain/entities/user.entity';

export class AuthDatasource {
    async findByEmail(email: string): Promise<UserWithPassword | null> {
        const result = await pool.query('SELECT id, email, hashed_password, name, avatar_url, created_at, updated_at FROM users WHERE email = $1', [email]);
        if (result.rows.length === 0) {
            return null;
        }
        const user = result.rows[0];
        return {
            id: user.id,
            email: user.email,
            name: user.name,
            hashedPassword: user.hashed_password,
            avatarUrl: user.avatar_url,
            createdAt: user.created_at,
            updatedAt: user.updated_at,
        };
    }

    async findById(id: string): Promise<User | null> {
        const result = await pool.query('SELECT id, email, name, avatar_url, created_at, updated_at FROM users WHERE id = $1', [id]);
        if (result.rows.length === 0) {
            return null;
        }
        const user = result.rows[0];
        return {
            id: user.id,
            email: user.email,
            name: user.name,
            avatarUrl: user.avatar_url,
            createdAt: user.created_at,
            updatedAt: user.updated_at,
        };
    }

    async create(user: { email: string, hashedPassword: string, name: string }): Promise<User> {
        const result = await pool.query('INSERT INTO users (email, hashed_password, name) VALUES ($1, $2, $3) RETURNING id, email, name, avatar_url, created_at, updated_at', [user.email, user.hashedPassword, user.name]);
        const newUser = result.rows[0];
        return {
            id: newUser.id,
            email: newUser.email,
            name: newUser.name,
            avatarUrl: newUser.avatar_url,
            createdAt: newUser.created_at,
            updatedAt: newUser.updated_at,
        };
    }
}