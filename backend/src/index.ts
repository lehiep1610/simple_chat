import app from './app';
import { initDatabase } from './core/config/database';

const PORT = process.env.PORT || 3000;

const start = async () => {
    await initDatabase();

    app.listen(PORT, () => {
        console.log(`🚀 Server running at http://localhost:${PORT}`);
    });
};

start();