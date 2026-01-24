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

        console.log('User table created successfully');
    } catch (error) {
        console.error('Error connecting to database:', error);
        process.exit(1);
    }
}