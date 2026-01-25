import express from 'express';
import authRoutes from './features/auth/presentation/routes/auth.routes';
import { AppError } from './core/errors/app-error';

const app = express();

// Middlewares
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);

// Error handler
app.use((err: Error, req: express.Request, res: express.Response, next: express.NextFunction) => {
    if (err instanceof AppError) {
        return res.status(err.statusCode).json({ message: err.message });
    }

    console.error('Unexpected error:', err);
    res.status(500).json({ message: 'Internal server error' });
});

export default app;