
import { createServer } from 'http';
import app from './app';
import { initDatabase } from './core/config/database';
import { Server } from 'socket.io';
import { setupChatSocket } from './features/chat/presentation/routes/chat.routes';

const PORT = process.env.PORT || 3000;

const start = async () => {
    await initDatabase();

    const httpServer = createServer(app);
    const io = new Server(httpServer, {
        cors: {
            origin: '*',
            methods: ['GET', 'POST'],
        },
    });

    setupChatSocket(io);

    app.listen(PORT, () => {
        console.log(`🚀 Server running at http://localhost:${PORT}`);
    });
};

start();