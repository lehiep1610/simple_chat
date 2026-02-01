import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

export const pool = new Pool({
    connectionString: process.env.LOCAL_DATABASE_URL,
});

export const initDatabase = async () => {
    try {
        await pool.query(`SELECT 1`);
        console.log('Database connected successfully');

        // Create user table if not exists
        await pool.query(`
            CREATE TABLE IF NOT EXISTS users (
                id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                email VARCHAR(255) UNIQUE NOT NULL,
                hashed_password VARCHAR(255) NOT NULL,
                name VARCHAR(255) NOT NULL,
                avatar_url VARCHAR(500),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `);

        // create conversation table if not exists
        await pool.query(`
            CREATE TABLE IF NOT EXISTS conversations(
                id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                name VARCHAR(255),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `);

        // create messages table if not exists
        await pool.query(`
            CREATE TABLE IF NOT EXISTS messages(
                id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
                sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                body TEXT NOT NULL,
                message_type VARCHAR(50) DEFAULT 'text',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        `);

        // create conversation_participants
        await pool.query(`
            CREATE TABLE IF NOT EXISTS conversation_participants(
                id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
                user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                UNIQUE(conversation_id, user_id)
            )
        `)

        // create friend table
        await pool.query(`
            CREATE TABLE IF NOT EXISTS friendships(
                user_low_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                user_high_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (user_low_id, user_high_id),
                CHECK (user_low_id < user_high_id)
            )
        `)

        // indexes
        await pool.query(`
            CREATE INDEX IF NOT EXISTS idx_message_conversation_id ON messages(conversation_id);
            CREATE INDEX IF NOT EXISTS idx_conversation_participants_user_id ON conversation_participants(user_id);
            `)

        console.log('All table created successfully');
    } catch (error) {
        console.error('Error connecting to database:', error);
        process.exit(1);
    }
}