import { Socket } from "socket.io";
import jwt from 'jsonwebtoken';

interface SocketWithAuth extends Socket {
    userId?: string;
}

export const socketAuthMiddleware = (socket: SocketWithAuth, next: (err?: Error) => void) => {
    try {
        const token = socket.handshake.auth.token;
        if (!token) {
            return next(new Error('Authentication error: Token missing'));
        }
        const decoded = jwt.verify(token, process.env.JWT_SECRET!);
        if (typeof decoded !== 'object' || !('userId' in decoded)) {
            return next(new Error('Authentication error: Invalid token'));
        }
        socket.userId = (decoded as any).userId;
        next();
    } catch (error) {
        return next(new Error('Authentication error: Unknown error'));
    }
}