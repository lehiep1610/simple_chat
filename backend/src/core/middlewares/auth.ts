import { Request, Response, NextFunction } from "express";
import jwt from 'jsonwebtoken'

export const authMiddleware = (req: Request, res: Response, next: NextFunction) => {
    try {
        const authHeader = req.get(`authorization`);

        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({ message: `No token provided` })
        }

        const token = authHeader.split(` `)[1];
        const decoded = jwt.verify(token, process.env.JWT_SECRET!);
        if (typeof decoded !== 'object' || !('userId' in decoded)) {
            return res.status(401).json({ message: `Invalid token` });
        }
        req.userId = (decoded as any).userId;
        next();
    } catch (error) {
        if (error instanceof jwt.TokenExpiredError) {
            return res.status(401).json({ message: 'Token expired' });
        }
        if (error instanceof jwt.JsonWebTokenError) {
            return res.status(401).json({ message: 'Invalid token' });
        }
        return res.status(401).json({ message: 'Authentication failed' });
    }
}